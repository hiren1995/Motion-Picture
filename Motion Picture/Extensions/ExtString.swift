//
//  ExtString.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 26/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import Foundation


extension String {
    
    static let isLogin = "isLogin"
    static let userData = "userData"
    
    func localized()->String {
        return NSLocalizedString(self, comment: "")
    }
}
