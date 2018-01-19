//
//  CircleButton.swift
//  Uber
//
//  Created by Avi Davidov on 14/01/2018.
//  Copyright © 2018 Avi Davidov. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView () {
        
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
