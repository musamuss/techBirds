//
//  ReviewsHeaderCell.swift
//  techBirds
//
//  Created by Artem Belkov on 01.08.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class ReviewsHeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var metricLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(appName: String, rating: Double, metric: String) {
        self.titleLabel.text = appName
        self.subtitleLabel.text = "\(rating) из 5"
        self.metricLabel.text = metric
    }
}

