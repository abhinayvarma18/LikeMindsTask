//
//  ViewController.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class AddPhoneNumberViewController: UIViewController {
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onClickSubmit(_ sender: Any) {
        let firebaseAuthManager = FirebaseAuthManager.shared
        let phoneNum = "+" + (countryCodeTextField.text ?? "91") + (phoneNumberTextField.text ?? "")
        firebaseAuthManager.verifyPhone(withPhoneNumber: phoneNum) { [weak self](error) in
            if let _ = error {
                
            }
            self?.goToOTPPage()
        }
    }
    
    private func goToOTPPage() {
         let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.verifyOTP) as? OTPVerificationViewController ?? UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

