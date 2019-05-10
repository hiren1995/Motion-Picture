//
//  LoginData.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 27/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import Foundation

struct LoginData : Codable {
    
    var userName: String?
    var eMail: String?
    var profilePicURL: URL?
    
    static var shared: LoginData?
    
    enum CodingKeys: String, CodingKey {
        
        case userName = "userName"
        case eMail = "eMail"
        case profilePicURL = "profilePicURL"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        eMail = try values.decodeIfPresent(String.self, forKey: .eMail)
        profilePicURL = try values.decodeIfPresent(URL.self, forKey: .profilePicURL)
    }
}
