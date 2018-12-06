//
//  TableViewCell.swift
//  heyFam
//
//  Created by Maulik Sharma on 06/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImageView?.layer.cornerRadius = photoImageView.frame.width / 2
        photoImageView?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
