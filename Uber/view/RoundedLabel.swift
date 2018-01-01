//
//  RoundedLabel.swift
//  Uber
//
//  Created by Avi Davidov on 18/11/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit

class RoundedView: UILabel {


    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView(){
        self.layer.cornerRadius = 10
    }

}
