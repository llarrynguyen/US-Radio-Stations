//
//  SimpleLableView.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/22/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class SimpleLabelView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        //Bundle.main.loadNibNamed("SimpleLableView", owner: self, options: nil)
        contentView.pinch(self)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
