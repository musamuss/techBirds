//
//  CommentsTableViewCell.swift
//  techBirds
//
//  Created by Игорь Силаев on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toneView: UIView!
    @IBOutlet weak var toneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(review: Review) {
        self.nicknameLabel.text = review.author
        self.dateLabel.text = review.team.rawValue
        self.descriptionLabel.text = review.text
        self.toneView.backgroundColor = .red
        self.toneLabel.text = review.category.rawValue
    }
}
