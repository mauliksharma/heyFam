//
//  Message.swift
//  heyFam
//
//  Created by Maulik Sharma on 26/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let text: String?
    let fromID: String?
    let toID: String?
    let timestamp: Int?
    
    var chatPartnerID: String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}
