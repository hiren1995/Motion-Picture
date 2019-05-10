//
//  ExtImage.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 28/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func getCropRatio() -> CGFloat{
        let widthRatio = CGFloat(self.size.width/self.size.height)
        return widthRatio
    }
}
