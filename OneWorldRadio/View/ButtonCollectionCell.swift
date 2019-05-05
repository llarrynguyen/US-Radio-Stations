//
//  ButtonCollectionCell.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 5/4/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class ButtonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var collectionButton: UIButton!
    
    var searchClosure: VoidClosureParameter?
    var myFavoritesClosure: VoidClosureParameter?
    
    @IBOutlet weak var searchButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setup() {
        self.collectionButton.layer.cornerRadius = self.collectionButton.frame.height/2
        self.collectionButton.clipsToBounds = true
        self.collectionButton.setTitleColor(.white, for: .normal)
        self.searchButton.layer.cornerRadius  = self.searchButton.layer.frame.height/2
        self.searchButton.clipsToBounds = true
        self.searchButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        searchClosure?()
    }
    
    @IBAction func collectionTapped(_ sender: Any) {
        myFavoritesClosure?()
    }
}
