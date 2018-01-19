//
//  LibPhoneCheckManager.swift
//  Uber
//
//  Created by Avi Davidov on 16/01/2018.
//  Copyright © 2018 Avi Davidov. All rights reserved.
//

import Foundation
import libPhoneNumber_iOS

class LibPhoneCheckManager {
    
    static let manager = LibPhoneCheckManager()
    
    func isPhoneNumberValid(phoneStr : String)-> Bool {
        
        let phoneUtil = NBPhoneNumberUtil()
        
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneStr, defaultRegion: "IL")
            return phoneUtil.isValidNumber(forRegion: phoneNumber, regionCode: "IL")
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return false
    }
}
