//
//  SignInViewController.swift
//  heyFam
//
//  Created by Maulik Sharma on 05/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
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
        
        authButton.setTitle(selectedIndex == 0 ? "Sign In" : "Sign Up", for: .normal)
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
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func signUp() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("Invalid Form")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error)
                return
            }
            guard let uid = result?.user.uid else { return }
            
            let dbRef = Database.database().reference().child("Users").child(uid)
            let values = ["name": name, "email": email]
            dbRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print(err)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
            
        }
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
