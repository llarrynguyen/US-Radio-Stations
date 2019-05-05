//
//  StationCollectionViewCell.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/10/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class StationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var themeImageView: UIImageView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
        
    }
    
    private func setUpCell() {
        self.contentView.layer.cornerRadius = 7
        
    }
    
    func update(station: RadioStation) {
        themeImageView.clipsToBounds = true
        let imageUrl = URL(string: station.logo)
        if let url = imageUrl {
            themeImageView.download(from: url, contentMode: UIView.ContentMode.scaleAspectFill, placeholder: UIImage(named: "placeholder-featured-image"), completionHandler: nil)
        }
        
    }

}
