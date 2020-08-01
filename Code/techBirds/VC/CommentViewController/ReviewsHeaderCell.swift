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
    @IBOutlet weak var metricValueValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        metricLabel.text = " положительных отзывов"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(appName: String, rating: Double, metric: Double) {
        self.titleLabel.text = appName
        self.subtitleLabel.text = "\(String(format: "%.1f", rating)) из 5"
        self.metricValueValue.text = "\(round(metric * 1000) / 1000)%"
    }
}

