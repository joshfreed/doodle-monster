//
//  ArrayDataSource.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class ArrayDataSource<T: CellProtocol, Item where T.ItemType == Item>: NSObject, UICollectionViewDataSource {
    var items: [Item]
    let identifier: String
    
    init(items: [Item], cellIdentifier: String)
    {
        self.items = items
        self.identifier = cellIdentifier
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! T
        cell.configure(getItemAtIndex(indexPath))
        return cell as! UICollectionViewCell
    }
    
    func getItemAtIndex(indexPath: NSIndexPath) -> Item {
        return items[indexPath.row]
    }
    
    func replaceItems(items: [Item]) {
        self.items = items
    }
}

protocol CellProtocol {
    typealias ItemType
    
    func configure(item: ItemType)
}

