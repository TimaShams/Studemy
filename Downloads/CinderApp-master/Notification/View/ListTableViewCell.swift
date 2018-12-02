//
//  ListTableViewCell.swift
//  Notification
//
//  Created by MacBook Pro on 16/11/2018.
//  Copyright © 2018 FatemaShams. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var container: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.setShadow()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
