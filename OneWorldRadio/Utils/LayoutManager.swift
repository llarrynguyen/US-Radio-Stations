//
//  LayoutManager.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/3/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit


extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: width/2 + minX, y: height/2 + minY)
    }
}

class LayoutManager {
    
    let rect: CGRect
    
    init(rect: CGRect) {
        self.rect = rect
    }
    
    func width(_ percentage: CGFloat) -> CGFloat {
        return percentage * rect.width / 100
    }
    
    func height(_ percentage: CGFloat) -> CGFloat {
        return percentage * rect.height / 100
    }
    
    func X(_ percentage: CGFloat, from: UIView) -> CGFloat {
        return width(percentage) + from.frame.maxX
    }
    
    func Y(_ percentage: CGFloat, from: UIView) -> CGFloat {
        return height(percentage) + from.frame.maxY
    }
    
    func ReverseX(_ percentage: CGFloat, width: CGFloat) -> CGFloat {
        return (rect.width - self.width(percentage)) - width
    }
    
    func ReverseY(_ percentage: CGFloat, height: CGFloat) -> CGFloat {
        return (rect.height - self.height(percentage)) - height
    }
    
    func ReverseY(_ percentage: CGFloat, height: CGFloat, from: UIView) -> CGFloat {
        return from.frame.minY - self.height(percentage) - height
    }
    
    static func Width(_ percentage: CGFloat, of view: UIView) -> CGFloat {
        return view.frame.width * (percentage / 100)
    }
    
    static func Height(_ percentage: CGFloat, of view: UIView) -> CGFloat {
        return view.frame.height * (percentage / 100)
    }
    
    static func widthScreen(_ percentage: CGFloat) -> CGFloat {
        return percentage * UIScreen.main.bounds.width / 100
    }
    
    static func heightScreen(_ percentage: CGFloat) -> CGFloat {
        return percentage * UIScreen.main.bounds.height / 100
    }
    
}



