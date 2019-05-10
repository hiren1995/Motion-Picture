//
//  SignInViewController.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 26/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class SignInViewController: BaseViewController {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgPlane: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var viewGoogleButton: UIView!
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var lblGoogleSignin: UILabel!
    @IBOutlet weak var viewImgGoogle: UIView!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewGoogleButton.alpha = 0
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1/2), execute: {
            
            self.animation()
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialize()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Custom Functions
    func initialize() {
        
        lblText.text = "str_appName".localized()
        lblGoogleSignin.text = "str_googleSignin".localized()
        lblText.font = setNoteWorthyBoldFont(size: 30)
        lblGoogleSignin.font = setSystemBoldFont(size: 20)
        
        imgBackground.image = UIImage(named: "bg")
        imgLogo.image = UIImage(named: "logo")
        imgGoogle.image = UIImage(named: "ic_google1x")
        imgPlane.image = UIImage(named: "ic_plane1x")
        
        viewGoogleButton.backgroundColor = UIColor.customblue
        viewImgGoogle.backgroundColor = UIColor.white
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    func animation() {
        
        UIView.animate(withDuration: 1, animations: {
            self.imgPlane.frame = CGRect(x: self.view.frame.width - 100, y: self.view.frame.height/2, width: self.imgPlane.frame.width, height: self.imgPlane.frame.height)
        }) { (true) in
            UIView.animate(withDuration: 0.05, animations: {
                self.imgPlane.transform = CGAffineTransform(rotationAngle: CGFloat(-90*Double.pi/180))
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    self.imgPlane.frame = CGRect(x: 50, y: 300, width: self.imgPlane.frame.width, height: self.imgPlane.frame.height)
                    
                    UIView.animate(withDuration: 1, animations: {
                        self.viewGoogleButton.alpha = 1.0
                    }) { (true) in
                        
                    }
                }) { (true) in
                    UIView.animate(withDuration: 0.05, animations: {
                        self.imgPlane.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                    }) { (true) in
                        UIView.animate(withDuration: 1, animations: {
                            self.imgPlane.frame = CGRect(x: self.view.frame.width + 100, y: -10, width: self.imgPlane.frame.width, height: self.imgPlane.frame.height)
                        }) { (true) in
                            self.imgPlane.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Button Actions
    
    @IBAction func btnSigninAction(_ sender: Any) {
    
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.signOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension SignInViewController: GIDSignInUIDelegate {
    
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil{
            showAlert(Title: "Error !!", Message: "Error occured during Google Signin")
            return
        }
       
        /*
        print(user.profile.email)
        print(user.profile.givenName)
        print(user.profile.familyName)
        print(user.profile.name)
        print(user.profile.imageURL(withDimension: 100))
        */
        
        
        // Google Authentication Completed Now Firebase Authentication
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        
        let firebaseAuthCredentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signInAndRetrieveData(with: firebaseAuthCredentials) { (authResult, error) in
            //print(authResult?.user.displayName)
            //print(authResult?.user.email)
            //print(authResult?.user.photoURL)
            
            let userData = ["userName":authResult?.user.displayName,"eMail":authResult?.user.email,"profilePicURL":authResult?.user.photoURL?.absoluteString]
            
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
                UserDefaults.standard.set(jsonData, forKey: .userData)
                UserDefaults.standard.set(true, forKey: .isLogin)
                
                if UserDefaults.standard.data(forKey: .userData) != nil {
                    let data = UserDefaults.standard.data(forKey: .userData)
                    let decoder = JSONDecoder()
                    do {
                        let loginDataModel = try decoder.decode(LoginData.self, from: data!)
                        LoginData.shared = loginDataModel
                        let rootViewController = self.mainStoryBoard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
                        self.appDelegate.window?.rootViewController = rootViewController
                    }catch(let error) {
                        print(error.localizedDescription)
                    }
                }
                
            }catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
}
