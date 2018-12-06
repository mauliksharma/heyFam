//
//  NewMessageTableViewController.swift
//  heyFam
//
//  Created by Maulik Sharma on 06/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Firebase

let imagesCache = NSCache<NSString, UIImage>()

class NewMessageTableViewController: UITableViewController {
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        
    }
    
    func fetchUsers() {
        Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            if let values = snapshot.value as? [String: String] {
                let user = User(name: values["name"], email: values["email"], photoURL: values["photoURL"])
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        if let userCell = cell as? UserTableViewCell {
            
            let user = users[indexPath.row]
            userCell.nameLabel.text = user.name
            userCell.emailLabel.text = user.email
            
            if let urlString = user.photoURL{
                userCell.photoImageView.loadImageUsingCache(fromURLString: urlString)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView {
    func loadImageUsingCache(fromURLString urlString: String) {
        self.image = nil
        
        if let cachedImage = imagesCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, let image = UIImage(data: imageData) {
                        self.image = image
                        imagesCache.setObject(image, forKey: urlString as NSString)
                    }
                }
            }
        }
    }
}
