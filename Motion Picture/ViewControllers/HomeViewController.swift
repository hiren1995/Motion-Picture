//
//  HomeViewController.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 27/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class HomeViewController: BaseViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    var indexSelected = Int()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.customGreenTheme
        self.title = "str_appName".localized()
        HomeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        HomeTableView.allowsMultipleSelection = false
        
        sendRequestForVideoListing()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToVideoPlayer" {
            if let controller = segue.destination as? VidePlayerViewController {
                controller.selectedIndex = self.indexSelected
            }
        }
    }
    
    // MARK: Custom Functions
    func sendRequestForVideoListing() {
        HttpManager.defaultManager.executeHttpRequest(apiRequest: .getVideoListing, apiCallbacks: self)
    }
   
    // MARK: Button Actions
    @IBAction func btnProfileAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "HomeToProfile", sender: nil)
    }
    
    @IBAction func btnLogoutAction(_ sender: UIBarButtonItem) {
        let alertVc = UIAlertController(title: "str_logout".localized(), message: "str_alert_logout".localized(), preferredStyle: .alert)
        let done = UIAlertAction(title: "str_ok".localized(), style: .default) { (okAction) in
            
            GIDSignIn.sharedInstance()?.signOut()
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            UserDefaults.standard.removeObject(forKey: .isLogin)
            UserDefaults.standard.removeObject(forKey: .userData)
            
            let rootViewController = self.mainStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.appDelegate.window?.rootViewController = rootViewController
        }
        let cancel = UIAlertAction(title: "str_cancel".localized(), style: .cancel, handler: nil)
        alertVc.addAction(done)
        alertVc.addAction(cancel)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    // MARK: API Callbacks
    
    override func onHttpResponse(request: ApiRequest, data: Any) {
        
        switch request {
        case .getVideoListing:
            
            let decoder = JSONDecoder()
            
            do{
                
                let responseVideoArray = try decoder.decode([VideoListingData].self, from: data as! Data)
                VideoListingArray.shared = responseVideoArray
                HomeTableView.reloadData()
               
            }catch(let error) {
                print(error.localizedDescription)
            }
            
            break
        }
        
    }
}

// MARK: Table Datasource and Delegates

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if VideoListingArray.shared == nil {
            return 0
        }else {
            return VideoListingArray.shared!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.ViewBackground.addBorderShadowDown(shadowOpacity: 0.7, shadowRadius: 7, shadowColor: UIColor.darkGray)
        cell.selectionStyle = .none
        cell.VideoObj = VideoListingArray.shared![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected = indexPath.row
        self.performSegue(withIdentifier: "HomeToVideoPlayer", sender: nil)
    }
    
}
