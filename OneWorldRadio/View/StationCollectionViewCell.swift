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
    
    @IBOutlet weak var stationNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
        
    }
    
    private func setUpCell() {
        self.layer.cornerRadius = 4
        
    }
    
    func update(station: RadioStation) {
        stationNameLabel.text = station.name
        stationNameLabel.textColor = SPConstants.ColorPaletteHex.lightSkyBlue.color
        stationNameLabel.clipsToBounds = true
        themeImageView.clipsToBounds = true
        let imageUrl = URL(string: station.logo)
        if let url = imageUrl {
            themeImageView.download(from: url, contentMode: UIView.ContentMode.scaleAspectFill, placeholder: UIImage(named: "placeholder-featured-image"), completionHandler: nil)
        }
        
    }

}
