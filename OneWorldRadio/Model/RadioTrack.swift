//
//  RadioTrack.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/11/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

struct Track {
    var title: String
    var artworkImage: UIImage?
    var artworkLoaded = false
    
    init(title: String) {
        self.title = title
    }
}

