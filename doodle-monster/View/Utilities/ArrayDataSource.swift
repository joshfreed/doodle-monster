//
//  ArrayDataSource.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class ArrayDataSource<T: CellProtocol, Item>: NSObject, UICollectionViewDataSource, UITableViewDataSource where T.ItemType == Item {
    var items: [Item]
    let identifier: String
    
    init(items: [Item], cellIdentifier: String)
    {
        self.items = items
        self.identifier = cellIdentifier
    }

    func getItemAtIndex(_ indexPath: IndexPath) -> Item {
        return items[(indexPath as NSIndexPath).row]
    }

    func replaceItems(_ items: [Item]) {
        self.items = items
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
        cell.configure(getItemAtIndex(indexPath))
        return cell as! UICollectionViewCell
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! T
        cell.configure(items[(indexPath as NSIndexPath).row])
        return cell as! UITableViewCell
    }
}

protocol CellProtocol {
    associatedtype ItemType
    
    func configure(_ item: ItemType)
}

