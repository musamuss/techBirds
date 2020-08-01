//
//  CommandsTableViewCell.swift
//  techBirds
//
//  Created by admin on 01.08.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class CommandsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }

}
