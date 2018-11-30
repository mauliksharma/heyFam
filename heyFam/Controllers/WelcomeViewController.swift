//
//  WelcomeViewController.swift
//  heyFam
//
//  Created by Maulik Sharma on 30/11/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "gotoChat", sender: self)
        }
        
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
