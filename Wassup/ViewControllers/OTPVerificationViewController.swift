//
//  OTPVerificationViewController.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class OTPVerificationViewController: UIViewController {
    @IBOutlet weak var otpTextField: UITextField!
    
    lazy var backgroundView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    lazy var spinnerView:SpinnerView = {
      let screenSize: CGRect = UIScreen.main.bounds
        return SpinnerView(frame: CGRect(x: screenSize.width/2 - 50.0, y: screenSize.height/2 - 50.0, width: 100, height: 100))
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickVerifyOTP(_ sender: Any) {
        loadLoaderView()
        FirebaseAuthManager.shared.signIn(withOTP: otpTextField.text ?? "") { [weak self](error) in
            if let _ = error  {
                self?.removeLoaderView()
                return
            }
            //success sign in
            self?.checkIfUserAlreadyExists()
        }
    }
    
    private func checkIfUserAlreadyExists() {
        FirebaseChatManager.shared.checkIfUserWithPhoneNumberExists { [weak self](flag) in
            self?.removeLoaderView()
            if flag {
                UserDefaults.standard.setValue(false, forKey: "onProfile")
                UserDefaults.standard.setValue(true, forKey: "loggedIn")
                self?.openChatListingPage()
            }else {
                UserDefaults.standard.setValue(true, forKey: "onProfile")
                self?.openProfileUpdationPage()
            }
        }
    }
    
    private func openProfileUpdationPage() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.profileUpdate) as? ProfileUpdateViewController ?? UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func openChatListingPage() {
           let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.chatPage) as? ChatListingViewController ?? UIViewController()
           self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loadLoaderView() {
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(spinnerView)
        spinnerView.animate()
    }
    
    private func removeLoaderView() {
        spinnerView.removeFromSuperview()
        backgroundView.removeFromSuperview()
    }
}
