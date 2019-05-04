//
//  CollectionViewLayoutBacker.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/22/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit
import Foundation

class GenericDataSource<T> : NSObject {
    var data: DynamikValue<[T]> = DynamikValue([])
}

class ColorDataSource : GenericDataSource<UIColor>, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        
        cell.backgroundColor = data.value[indexPath.row]
        return cell
    }
}
