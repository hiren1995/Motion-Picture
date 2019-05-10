//
//  ExtData.swift
//  Wings Society
//
//  Created by LogicalWings Mac on 18/02/19.
//  Copyright © 2019 LogicalWings Mac. All rights reserved.
//

import Foundation

extension Data{
    
    func getDictionaryFromData() -> NSDictionary {
        
        var dictResponse = NSDictionary()
        
        do {
            
            let responseObject = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            dictResponse = responseObject as! NSDictionary
            
        } catch (let error) {
            print(error)
        }
        
        return dictResponse
    }
    
    func getCheckSumArrayData() -> [String : Any] {
        
        var dictResponse = [String : Any]()
        
        do {
            
            let responseObject = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            
            dictResponse = responseObject as! [String : Any]
            
            print(dictResponse)
            
        } catch (let error) {
            print(error)
        }
        
        return dictResponse
    }
    
}
