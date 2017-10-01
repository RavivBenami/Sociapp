//
//  CircleView.swift
//  Sociapp
//
//  Created by Raviv Benami on 14/09/2017.
//  Copyright © 2017 Raviv Benami. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    

    
    

}
