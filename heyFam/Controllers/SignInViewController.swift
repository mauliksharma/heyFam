//
//  SignInViewController.swift
//  heyFam
//
//  Created by Maulik Sharma on 05/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var signInProfileImageView: UIImageView! {
        didSet {
            signInProfileImageView.isUserInteractionEnabled = true
            signInProfileImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapProfilePhotoImageView)))
        }
    }
    var customProfilePhotoSelected = false
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet var inputContainerView: UIView! {
        didSet {
            inputContainerView?.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var authButton: UIButton!
    
    @IBOutlet var inputContainerViewAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet var nameTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var firstSeparatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet var emailTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var passwordTextFieldHeightConstraint: NSLayoutConstraint!
    
    @IBAction func toggleSegment(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let inputContainerViewAspectRatioMultiplier: CGFloat = selectedIndex == 0 ? 8/2 : 8/3
        let nameTextFieldHeightMultiplier: CGFloat = selectedIndex == 0 ? 0 : 1/3
        let emailpassTextFieldHeightMultiplier: CGFloat = selectedIndex == 0 ? 1/2 : 1/3
        
        inputContainerViewAspectRatioConstraint.isActive = false
        inputContainerViewAspectRatioConstraint = NSLayoutConstraint(item: inputContainerView, attribute: .width, relatedBy: .equal, toItem: inputContainerView, attribute: .height, multiplier: inputContainerViewAspectRatioMultiplier , constant: 0)
        inputContainerViewAspectRatioConstraint.isActive = true
        
        nameTextFieldHeightConstraint.isActive = false
        nameTextFieldHeightConstraint = NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: inputContainerView, attribute: .height, multiplier: nameTextFieldHeightMultiplier, constant: 0)
        nameTextFieldHeightConstraint.isActive = true
        
        emailTextFieldHeightConstraint.isActive = false
        emailTextFieldHeightConstraint = NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: inputContainerView, attribute: .height, multiplier: emailpassTextFieldHeightMultiplier, constant: 0)
        emailTextFieldHeightConstraint.isActive = true
        
        passwordTextFieldHeightConstraint.isActive = false
        passwordTextFieldHeightConstraint = NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: inputContainerView, attribute: .height, multiplier: emailpassTextFieldHeightMultiplier, constant: 0)
        passwordTextFieldHeightConstraint.isActive = true
        
        signInProfileImageView.image = UIImage(named: "chat")
        signInProfileImageView.isUserInteractionEnabled = selectedIndex == 0 ? false : true
        customProfilePhotoSelected = false
        authButton.setTitle(selectedIndex == 0 ? "Sign In" : "Sign Up", for: .normal)
    }
    
    @objc func handleTapProfilePhotoImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        signInProfileImageView.image = selectedImage
        signInProfileImageView.layer.cornerRadius = signInProfileImageView.frame.width / 2
        signInProfileImageView.clipsToBounds = true
        customProfilePhotoSelected = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func triggerAuth(_ sender: UIButton) {
        if segmentedControl.selectedSegmentIndex == 0 {
            signIn()
        } else {
            signUp()
        }
    }
    
    func signIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Invalid Form")
            return
        }
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                print(error)
                return
            }
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func signUp() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else
        {
            print("Invalid Form")
            return
        }
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                print(error)
                return
            }
            guard let uid = result?.user.uid else { return }
            
            if self.customProfilePhotoSelected {
                let imageName = UUID().uuidString
                let storeRef = Storage.storage().reference().child("ProfileImages").child("\(imageName).jpeg")
                if let data = self.signInProfileImageView.image?.jpegData(compressionQuality: 0.1) {
                    
                    storeRef.putData(data, metadata: nil, completion: { (_, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        storeRef.downloadURL(completion: { (url, er) in
                            if let er = er {
                                print(er)
                                return
                            }
                            guard let url = url else { return }
                            let values = ["name": name, "email": email, "photoURL": url.absoluteString]
                            self.registerUserIntoDatabase(uid: uid, values: values)
                        })
                    })
                }
            }
            else {
                let values = ["name": name, "email": email, "photoURL": ""]
                self.registerUserIntoDatabase(uid: uid, values: values)
            }
        }
    }
    
    func registerUserIntoDatabase(uid: String, values: [String: String]) {
        let dbRef = Database.database().reference().child("Users").child(uid)
        dbRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
