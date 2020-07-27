//
//  ProfileUpdateViewController.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class ProfileUpdateViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2.0
        profileImageView.clipsToBounds = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    @IBAction func onClickSaveProfile(_ sender: Any) {
        if let text = nameTextField.text {
            FirebaseChatManager.shared.saveUserInfo(name: text, imageUrl: nil)
            UserDefaults.standard.setValue(false, forKey: "onProfile")
            UserDefaults.standard.setValue(true, forKey: "loggedIn")
            self.goToChatListingPage()
        }
    }
    
    func goToChatListingPage() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.chatPage) as? ChatListingViewController ?? UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
