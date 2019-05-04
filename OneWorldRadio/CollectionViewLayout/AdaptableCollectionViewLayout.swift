//
//  AdaptableCollectionViewLayout.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/22/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

enum CollectionLayoutType {
    case inline
    case list
    case grid
}

class AdaptableCollectionViewLayout: UICollectionViewFlowLayout {
    var display : CollectionLayoutType = .grid {
        didSet {
            if display != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    convenience init(display: CollectionLayoutType) {
        self.init()
        
        self.display = display
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.configLayout()
    }
    
    func configLayout() {
        switch display {
        case .inline:
            self.scrollDirection = .horizontal
            if let collectionView = self.collectionView {
                self.itemSize = CGSize(width: collectionView.frame.width * 0.9, height: 300)
            }
            
        case .grid:
            
            self.scrollDirection = .vertical
            if let collectionView = self.collectionView {
                let optimisedWidth = (collectionView.frame.width - minimumInteritemSpacing) / 2
                self.itemSize = CGSize(width: optimisedWidth , height: optimisedWidth) // keep as square
            }
            
        case .list:
            self.scrollDirection = .vertical
            if let collectionView = self.collectionView {
                self.itemSize = CGSize(width: collectionView.frame.width , height: 130)
            }
        }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.configLayout()
    }
}
