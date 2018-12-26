//
//  ChatLogViewController.swift
//  heyFam
//
//  Created by Maulik Sharma on 26/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChatLogViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var user: User? {
        didSet {
            self.title = user?.name
        }
    }
    
    @IBOutlet var chatLogCollectionView: UICollectionView!
    @IBOutlet var composeContainerView: UIView!
    @IBOutlet var composeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        handleSendMessage()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleSendMessage()
        return true
    }
    
    func handleSendMessage() {
        guard let text = composeTextField.text, !text.isEmpty else { return }
        guard let fromID = Auth.auth().currentUser?.uid, let toID = user?.uid else { return }
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["fromID": fromID, "toID": toID, "timestamp": timestamp, "text": text ] as [String : Any]
        let dbRef = Database.database().reference().child("Messages").childByAutoId()
        dbRef.updateChildValues(values)
        composeTextField.text = ""
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath)
        return cell
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
