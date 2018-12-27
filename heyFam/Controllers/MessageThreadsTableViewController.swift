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

class MessageThreadsTableViewController: UITableViewController {
    
    var messages = [Message]()
    
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
        checkIfUserLoggedIn()
//        fetchMessages()
    }
    
    func checkIfUserLoggedIn() {
        let uid = Auth.auth().currentUser?.uid
        if uid == nil {
            performSegue(withIdentifier: "signOutSegue", sender: self)
        }
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
    }
    
//    func fetchMessages() {
//        SVProgressHUD.show()
//        Database.database().reference().child("Messages").observe(.childAdded) { (snapshot) in
//            if let values = snapshot.value as? [String: Any] {
//                let fromID = values["fromID"] as? String
//                let toID = values["toID"] as? String
//                let timestamp = values["timestamp"] as? Int
//                let text = values["text"] as? String
//                self.messages.append(Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp))
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    SVProgressHUD.dismiss()
//                }
//            }
//        }
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadCell", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.toID
        cell.detailTextLabel?.text = message.text
        return cell
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
