

import UIKit

class ApiConfig: NSObject {
    
    static let PROTOCOL: String = "https"
  
    // Testing
    static let HOST: String = "interview-e18de.firebaseio.com"
    
    // Live
    //static let HOST: String = "interview-e18de.firebaseio.com"
    
    static let PATH: String = ""
    static let BASE_URL: String =  PROTOCOL + "://" + HOST + PATH
    
}
