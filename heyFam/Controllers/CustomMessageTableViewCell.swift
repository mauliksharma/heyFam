//
//  CustomMessageTableViewCell.swift
//  heyFam
//
//  Created by Maulik Sharma on 30/11/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class CustomMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
