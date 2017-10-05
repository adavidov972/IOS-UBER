//
//  ToolbarTextField.swift
//  Uber
//
//  Created by Avi Davidov on 24/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit

class ToolbarTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [spaceButton,doneButton]
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneAction(){
        self.sendActions(for: .editingDidEndOnExit)
    }
}
