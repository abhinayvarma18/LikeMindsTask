//
//  ProfileUpdateViewController.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class ProfileUpdateViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    var imagePicker = UIImagePickerController()
    var imageUrl:String?
    
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
        addGestureToProfileView()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func addGestureToProfileView() {
        profileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(onClickProfile))
        profileImageView.addGestureRecognizer(gesture)
    }
    
    @objc func onClickProfile() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){

            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image = chosenImage
    }
    
    func uploadImageToFirebase(image:Data) {
        FirebaseAuthManager.shared.uploadProfileImage(image: image) { [weak self](url) in
            if url != nil {
                self?.imageUrl = url
                if let text = self?.nameTextField.text {
                    self?.updateProfileData(text: text)
                }else {
                    //show error
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        makeProfileViewCircular()
    }

    private func makeProfileViewCircular() {
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2.0
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func onClickSaveProfile(_ sender: Any) {
        self.resignFirstResponder()
        if profileImageView.image != nil {
            loadLoaderView()
            uploadImageToFirebase(image: profileImageView.image!.pngData()!)
        }else if let text = nameTextField.text {
            loadLoaderView()
            updateProfileData(text: text)
        }else {
            //show error to add a name
        }
    }
    
    private func updateProfileData(text:String) {
        UserDefaults.standard.setValue(text, forKey: "name")
        UserDefaults.standard.setValue(imageUrl, forKey: "image")
        FirebaseChatManager.shared.saveUserInfo(name: text, imageUrl: imageUrl)
        UserDefaults.standard.setValue(false, forKey: "onProfile")
        UserDefaults.standard.setValue(true, forKey: "loggedIn")
        removeLoaderView()
        self.goToChatListingPage()
    }
    
    func goToChatListingPage() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.chatListPage) as? ChatListingViewController ?? UIViewController()
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
