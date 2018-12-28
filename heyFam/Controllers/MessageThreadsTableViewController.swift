//
//  MessageThreadsTableViewController.swift
//  heyFam
//
//  Created by Maulik Sharma on 05/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MessageThreadsTableViewController: UITableViewController, ViewControllerTransitionDelegate, UINavigationControllerDelegate {
    
    var messages = [Message]()
    var mostRecentMessagesDictionary  = [String: Message]()
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError {
            SVProgressHUD.dismiss()
            print(signOutError)
            return
        }
        SVProgressHUD.dismiss()
        performSegue(withIdentifier: "signOutSegue", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.delegate = self
        checkIfUserLoggedIn()
        fetchMessagesForUser()
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            performSegue(withIdentifier: "signOutSegue", sender: self)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let _ = viewController as? MessageThreadsTableViewController {
            messageThreadsVCWillShow()
        }
    }
    
    func messageThreadsVCWillShow() {
        removeThreadsData()
        tableView.reloadData()
        fetchMessagesForUser()
    }
    
    func removeThreadsData() {
        messages.removeAll()
        mostRecentMessagesDictionary.removeAll()
    }
    
    func showChatLog(for user: User) {
        performSegue(withIdentifier: "showChatLog", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newMessageSegue" {
            if let newMessageTVC = (segue.destination as? UINavigationController)?.visibleViewController as? NewMessageTableViewController {
                newMessageTVC.messageThreadsTVC = self
            }
        }
        if segue.identifier == "showChatLog" {
            if let chatLogVC = segue.destination as? ChatLogViewController, let user = sender as? User {
                chatLogVC.user = user
            }
        }
        if segue.identifier == "signOutSegue" {
            if let signInVC = segue.destination as? SignInViewController {
                signInVC.vcTransitionDelegate = self
            }
        }
    }
    
    func fetchMessagesForUser() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
//        SVProgressHUD.show()
        Database.database().reference().child("UserMessagesReferences").child(currentUID).observe(.childAdded) { (snapshot) in
            
            let messageID = snapshot.key
            Database.database().reference().child("Messages").child(messageID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let values = snapshot.value as? [String: Any] {
                    let fromID = values["fromID"] as? String
                    let toID = values["toID"] as? String
                    let timestamp = values["timestamp"] as? Int
                    let text = values["text"] as? String
                    let message = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)
                    let withUserID = fromID! == currentUID ? toID! : fromID!
                    self.mostRecentMessagesDictionary[withUserID] = message
                    self.messages = Array(self.mostRecentMessagesDictionary.values).sorted{$0.timestamp! > $1.timestamp!}
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                        SVProgressHUD.dismiss()
                    }
                }

            })
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadCell", for: indexPath)
        if let customTVC = cell as? CustomTableViewCell {
            
            let message = messages[indexPath.row]
            let currentUID = Auth.auth().currentUser?.uid
            let withUserID = message.fromID! == currentUID! ? message.toID! : message.fromID!
            Database.database().reference().child("Users").child(withUserID).observeSingleEvent(of: .value) { (snapshot) in
                if let values = snapshot.value as? [String: String] {
                    customTVC.nameLabel.text = values["name"]
                    if let urlString = values["photoURL"] {
                        customTVC.photoImageView.loadImageUsingCache(fromURLString: urlString)
                    }
                    customTVC.detailLabel.text = message.text
                    
                    let date = Date(timeIntervalSince1970: Double(message.timestamp!))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    customTVC.timestampLabel.text = dateFormatter.string(from: date)

                }
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    

}
