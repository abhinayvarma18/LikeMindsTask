//
//  WelcomeScreenViewController.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickAgree(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.addPhone) as? AddPhoneNumberViewController ?? UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
