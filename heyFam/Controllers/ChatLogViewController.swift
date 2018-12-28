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

class ChatLogViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet {
            self.title = user?.name
            fetchMessages()
        }
    }
    
    var messages = [Message]()
    
    @IBOutlet var chatLogCollectionView: UICollectionView!
    @IBOutlet var composeContainerView: UIView!
    @IBOutlet var composeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composeTextField.delegate = self
        chatLogCollectionView.delegate = self
        chatLogCollectionView.dataSource = self
    }
    
    func fetchMessages() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("UserMessagesReferences").child(currentUID).observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            Database.database().reference().child("Messages").child(messageID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let values = snapshot.value as? [String: Any] {
                    let fromID = values["fromID"] as? String
                    let toID = values["toID"] as? String
                    let timestamp = values["timestamp"] as? Int
                    let text = values["text"] as? String
                    let message = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)
                    if message.chatPartnerID == self.user?.uid {
                        self.messages.append(message)
                        DispatchQueue.main.async {
                            self.chatLogCollectionView.reloadData()
                        }
                    }
                }
            })
        }
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
        let messageRef = Database.database().reference().child("Messages").childByAutoId()
        messageRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            let senderMessagesRef = Database.database().reference().child("UserMessagesReferences").child(fromID)
            let recipientMessagesRef = Database.database().reference().child("UserMessagesReferences").child(toID)
            let val = [messageRef.key!: 1]
            senderMessagesRef.updateChildValues(val)
            recipientMessagesRef.updateChildValues(val)
        }
        
        composeTextField.text = ""
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath)
        if let chatMessageCVC = cell as? ChatMessageCollectionViewCell {
            let message = messages[indexPath.row]
            chatMessageCVC.chatMessageLabel.text = message.text
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
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
