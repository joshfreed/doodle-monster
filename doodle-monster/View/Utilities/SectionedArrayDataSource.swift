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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[(indexPath as NSIndexPath).section].cellForItemAtIndexPath(indexPath, collectionView: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return sections[(indexPath as NSIndexPath).section].viewForSupplementaryElementOfKind(collectionView, kind: kind, atIndexPath: indexPath)
    }
}

protocol CollectionViewCell: NibLoadableView {
    associatedtype Item
    func configure(_ item: Item)
}

protocol SupplementaryView: NibLoadableView {
    func configure(_ section: Int)
}

protocol SectionProtocol {
    var count: Int { get }
    func cellForItemAtIndexPath(_ indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell
    func viewForSupplementaryElementOfKind(_ collectionView: UICollectionView, kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView
}

class SupplementaryViewFactory<T: SupplementaryView> {
    func buildView(_ collectionView: UICollectionView, kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
            withReuseIdentifier: String(describing: T.self),
            for: indexPath
        )
    }
}

class Section<Item,
             CellType: CollectionViewCell,
             HeaderType: SupplementaryView,
             FooterType: SupplementaryView>: SectionProtocol
             where CellType.Item == Item {
    fileprivate(set) var items: [Item]
    var headerViewFactory: SupplementaryViewFactory<HeaderType>?
    var footerViewFactory: SupplementaryViewFactory<FooterType>?

    var count: Int {
        return items.count
    }
    
    init(items: [Item]) {
        self.items = items
    }

    func replaceItems(_ items: [Item]) {
        self.items = items
    }

    func cellForItemAtIndexPath(_ indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let item = items[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CellType.self), for: indexPath) as! CellType
//        let cell: CellType = collectionView.dequeueReusableCell(forIndexPath: indexPath) as! CellType
        cell.configure(item)
        return cell as! UICollectionViewCell
    }

    func viewForSupplementaryElementOfKind(_ collectionView: UICollectionView, kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = headerViewFactory!.buildView(collectionView, kind: kind, atIndexPath: indexPath) as! HeaderType
            header.configure((indexPath as NSIndexPath).section)
            return header as! UICollectionReusableView
        } else {
            guard let factory = footerViewFactory, let footer = factory.buildView(collectionView, kind: kind, atIndexPath: indexPath) as? FooterType else {
                fatalError("Expected a footer view")
            }
            footer.configure((indexPath as NSIndexPath).section)
            return footer as! UICollectionReusableView
        }
    }
}

