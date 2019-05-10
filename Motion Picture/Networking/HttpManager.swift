
import Foundation
import UIKit
import SVProgressHUD
//import Firebase

class HttpManager{
    
    static let defaultManager = HttpManager()
    
    static var accessToken = String()
    
    var previousRequest : ApiRequest?
    
    static var shared: HttpManager {
        return defaultManager
    }
    
    func executeHttpRequest(apiRequest: ApiRequest, apiCallbacks: ApiCallbacks){
       
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let datatask = URLSession.shared.dataTask(with: apiRequest.createHttpRequest()){ (responseData, response, responseError) in

            SVProgressHUD.dismiss()

            if responseError == nil {
                if let httpResponse = response as? HTTPURLResponse {

                    let statusCode = httpResponse.statusCode

                    print(statusCode)

                    if statusCode == 200 {

                        //let dictResponse = responseData?.getDictionaryFromData()
                        //print(dictResponse)
                        
                        if responseData != nil {
                        
                        apiRequest.parseResponseData(data: responseData!, httpResponse: httpResponse, apiCallbacks: apiCallbacks)

                        }else{

                        }
                    }
                    else if (statusCode == 400){
                        //let dictResponse = responseData?.getDictionaryFromData()
                        //print(dictResponse)
                        
                        //if let message = dictResponse!["error_description"] as? String{
                        //    DispatchQueue.main.async {
                        //        apiCallbacks.onHttpError(error: message)
                        //    }
                        //}
                    }else if (statusCode == 401){
                       
                    }
                    else if(statusCode == 403){
                        DispatchQueue.main.async {
                            apiCallbacks.onHttpError(error: "string_server_error".localized())
                            print("Server Failed To Respond")
                        }
                    }
                    else{
                        
                        //let dictResponse = responseData?.getDictionaryFromData()
                        //print(dictResponse)
                        
                        //if let message = dictResponse!["error_description"] as? String{
                        //    DispatchQueue.main.async {
                        //        apiCallbacks.onHttpError(error: message)
                        //    }
                        //}else{
                        //    DispatchQueue.main.async {
                        //        apiCallbacks.onHttpError(error: "string_something_wrong".localized())
                        //    }
                        //}
                    }
                }
            }else{
                print("executeHttpRequest \(responseError)")
                DispatchQueue.main.async {
                    apiCallbacks.onHttpError(error: (responseError?.localizedDescription)!)
                }
            }
        }
        datatask.resume()

    }
    
}


