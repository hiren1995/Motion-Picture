//
//  BaseViewController.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 26/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController,ApiCallbacks {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setNoteWorthyBoldFont(size : Int)->UIFont {
        return UIFont(name: "Noteworthy-Bold", size: CGFloat(size))!
    }
    
    func setSystemBoldFont(size : Int) -> UIFont {
        return UIFont.boldSystemFont(ofSize: CGFloat(size))
    }
    
    func showAlert(Title:String,Message:String) {
        let alertVc = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let done = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVc.addAction(done)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    
    func serverResponseMessages(_ message: String) {
        self.view.makeToast(message, duration: 3.0, position: .bottom)
    }
    
    //MARK: Api Callsbackmethods
    
    func onHttpResponse(request: ApiRequest, data: Any) {
        
    }
    
    func onHttpError(error: String) {
        //DispatchQueue.main.sync {
        self.serverResponseMessages(error)
        //}
    }
}
