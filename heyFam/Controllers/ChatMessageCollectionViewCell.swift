//
//  ChatMessageCollectionViewCell.swift
//  heyFam
//
//  Created by Maulik Sharma on 28/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class ChatMessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var chatBubble: UIView!
    @IBOutlet var chatMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatBubble.layer.cornerRadius = 17
    }

}
