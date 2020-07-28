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
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @IBAction func onClickSubmit(_ sender: Any) {
        self.resignFirstResponder()
        let firebaseAuthManager = FirebaseAuthManager.shared
        let phoneNum = "+" + (countryCodeTextField.text ?? "91") + (phoneNumberTextField.text ?? "")
        self.loadLoaderView()
        firebaseAuthManager.verifyPhone(withPhoneNumber: phoneNum) { [weak self](error) in
            self?.removeLoaderView()
            if let _ = error {
                return
            }
            self?.goToOTPPage()
        }
    }
    
    private func goToOTPPage() {
         let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.verifyOTP) as? OTPVerificationViewController ?? UIViewController()
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

