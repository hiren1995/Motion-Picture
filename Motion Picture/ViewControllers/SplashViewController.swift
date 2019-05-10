//
//  ViewController.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 26/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    let timer = Timer()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        animation()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Custom Functions
    func initialize() {
        imgBackground.image = UIImage(named: "bg")
        imgLogo.image = UIImage(named: "logo")
        lblText.text = "str_appName".localized()
        lblText.font = setNoteWorthyBoldFont(size: 30)
    }

    func animation() {
        
        UIView.animate(withDuration: 1, animations: {
            self.imgLogo.frame = CGRect(x: self.imgLogo.frame.origin.x, y: (self.view.frame.height / 2)-150, width: self.imgLogo.frame.width, height: self.imgLogo.frame.height)
        }) { (true) in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.imgLogo.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
            }, completion: { (true) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.imgLogo.transform = CGAffineTransform.identity
                }, completion: { (true) in
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.imgLogo.transform = CGAffineTransform(rotationAngle: CGFloat(-30*Double.pi/180))
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.imgLogo.transform = CGAffineTransform(rotationAngle: CGFloat(30*Double.pi/180))
                        }, completion: { (true) in
                            UIView.animate(withDuration: 0.3, animations: {
                                self.imgLogo.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                            }, completion: { (true) in
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.lblText.frame = CGRect(x: self.lblText.frame.origin.x, y: (self.view.frame.height / 2), width: self.lblText.frame.width, height: self.lblText.frame.height)
                                }, completion: { (true) in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                        
                                        self.checkLogin()
                                        
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
    }
    
    func checkLogin() {
        
        let isLogin = UserDefaults.standard.bool(forKey: .isLogin)
        
        if isLogin {
            
            if UserDefaults.standard.data(forKey: .userData) != nil {
                let data = UserDefaults.standard.data(forKey: .userData)
                let decoder = JSONDecoder()
                do {
                    let loginDataModel = try decoder.decode(LoginData.self, from: data!)
                    LoginData.shared = loginDataModel
                    let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
                    
                    self.appDelegate.window?.rootViewController = rootViewController
                }catch(let error) {
                    print(error.localizedDescription)
                }
            }
        } else {
            
            let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.appDelegate.window?.rootViewController = rootViewController
        }
        
    }
}

