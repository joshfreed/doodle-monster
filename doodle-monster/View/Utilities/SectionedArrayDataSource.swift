//
//  SectionedArrayDataSource.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/15/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class SectionedArrayDataSource<Item>: NSObject, UICollectionViewDataSource {
    var sections: [SectionProtocol]
    
    override init()
    {
        self.sections = []
        super.init()
    }
    
    init(sections: [SectionProtocol])
    {
        self.sections = sections
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].cellForItemAtIndexPath(indexPath, collectionView: collectionView)
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return sections[indexPath.section].viewForSupplementaryElementOfKind(collectionView, kind: kind, atIndexPath: indexPath)
    }
}

protocol CollectionViewCell: NibLoadableView {
    associatedtype Item
    func configure(item: Item)
}

protocol SupplementaryView: NibLoadableView {
    func configure(section: Int)
}

protocol SectionProtocol {
    var count: Int { get }
    func cellForItemAtIndexPath(indexPath: NSIndexPath, collectionView: UICollectionView) -> UICollectionViewCell
    func viewForSupplementaryElementOfKind(collectionView: UICollectionView, kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
}

class SupplementaryViewFactory<T: SupplementaryView> {
    func buildView(collectionView: UICollectionView, kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind,
            withReuseIdentifier: String(T),
            forIndexPath: indexPath
        )
    }
}

class Section<Item,
             CellType: CollectionViewCell,
             HeaderType: SupplementaryView,
             FooterType: SupplementaryView
             where CellType.Item == Item>: SectionProtocol {
    private(set) var items: [Item]
    var headerViewFactory: SupplementaryViewFactory<HeaderType>?
    var footerViewFactory: SupplementaryViewFactory<FooterType>?

    var count: Int {
        return items.count
    }
    
    init(items: [Item]) {
        self.items = items
    }

    func replaceItems(items: [Item]) {
        self.items = items
    }

    func cellForItemAtIndexPath(indexPath: NSIndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CellType), forIndexPath: indexPath) as! CellType
//        let cell: CellType = collectionView.dequeueReusableCell(forIndexPath: indexPath) as! CellType
        cell.configure(item)
        return cell as! UICollectionViewCell
    }

    func viewForSupplementaryElementOfKind(collectionView: UICollectionView, kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = headerViewFactory!.buildView(collectionView, kind: kind, atIndexPath: indexPath) as! HeaderType
            header.configure(indexPath.section)
            return header as! UICollectionReusableView
        } else {
            guard let factory = footerViewFactory, footer = factory.buildView(collectionView, kind: kind, atIndexPath: indexPath) as? FooterType else {
                fatalError("Expected a footer view")
            }
            footer.configure(indexPath.section)
            return footer as! UICollectionReusableView
        }
    }
}

