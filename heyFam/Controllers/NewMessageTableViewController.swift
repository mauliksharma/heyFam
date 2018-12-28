//
//  NewMessageTableViewController.swift
//  heyFam
//
//  Created by Maulik Sharma on 06/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

let imagesCache = NSCache<NSString, UIImage>()

class NewMessageTableViewController: UITableViewController {
    
    var messageThreadsTVC: MessageThreadsTableViewController?
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUsers() {
        SVProgressHUD.show()
        Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            if let currentUID = Auth.auth().currentUser?.uid, uid != currentUID {
                if let values = snapshot.value as? [String: String] {
                    let user = User(name: values["name"], email: values["email"], photoURL: values["photoURL"], uid: uid)
                    self.users.append(user)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        if let userCell = cell as? CustomTableViewCell {
            
            let user = users[indexPath.row]
            userCell.nameLabel.text = user.name
            userCell.detailLabel.text = user.email
            
            if let urlString = user.photoURL {
                userCell.photoImageView.loadImageUsingCache(fromURLString: urlString)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userSelected = users[indexPath.row]
        messageThreadsTVC?.showChatLog(for: userSelected)
        dismiss(animated: true, completion: nil)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


