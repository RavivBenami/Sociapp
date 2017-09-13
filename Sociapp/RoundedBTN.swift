//
//  RoundedBTN.swift
//  Sociapp
//
//  Created by Raviv Benami on 12/09/2017.
//  Copyright © 2017 Raviv Benami. All rights reserved.
//

import UIKit

class RoundedBTN: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
        imageView?.contentMode = .scaleAspectFit
        
}
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width/2
    }
}
