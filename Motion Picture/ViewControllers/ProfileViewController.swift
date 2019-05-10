//
//  ProfileViewController.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 27/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController {

    @IBOutlet weak var viewProfileData: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "str_title_homeVC".localized()
        imgProfilePic.sd_setImage(with: LoginData.shared?.profilePicURL, placeholderImage: UIImage(named: "ic_user1x"))
        
        lblUserName.text = LoginData.shared?.userName
        lblEmail.text =     LoginData.shared?.eMail
    }
    
    override func viewDidLayoutSubviews() {
        viewProfileData.layoutIfNeeded()
        viewProfileData.addBorderShadow(shadowOpacity: 0.5, shadowRadius: 10, shadowColor: UIColor.darkGray)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
