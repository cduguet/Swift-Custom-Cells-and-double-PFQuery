//
//  UserCell.swift
//  CrowdTransfer Beta
//
//  Created by Cristian Duguet on 4/28/15.
//  Copyright (c) 2015 CrowdTransfer. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
