//
//  SideBarMenu.swift
//  
//
//  Created by Avi Davidov on 06/10/2017.
//

import UIKit

class SideBarMenu : UIView {
    
    var currentView : UIView
    var menuView = UIView()
    
    
    init(currentView : UIView) {
        super.init()
        self.currentView = currentView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showSideMenu() {
        
        menuView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: currentView.frame.size.height))
        menuView.backgroundColor = UIColor.lightGray
    }
    
    func hideSideMenu() {
       
    }
}
