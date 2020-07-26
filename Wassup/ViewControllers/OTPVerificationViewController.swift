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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickVerifyOTP(_ sender: Any) {
        FirebaseAuthManager.shared.signIn(withOTP: otpTextField.text ?? "") { [weak self](error) in
            if let _ = error  {
                
            }
            self?.goToProfilePage()
        }
    }
    
    private func goToProfilePage() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.profileUpdate) as? ProfileUpdateViewController ?? UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
