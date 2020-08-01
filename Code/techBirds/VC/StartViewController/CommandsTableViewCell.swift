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

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            moveIn()
        } else {
            moveOut()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }

    private let moveDuration: TimeInterval = 0.2
    private let moveScale: CGFloat = 0.95
    
    private func moveIn() {
        layer.removeAllAnimations()

        UIView.animate(withDuration: moveDuration) { [unowned self] in
            self.transform = .init(scaleX: self.moveScale, y: self.moveScale)
        }
    }

    private func moveOut() {
        layer.removeAllAnimations()

        UIView.animate(withDuration: moveDuration) { [unowned self] in
            self.transform = .identity
        }
    }
}
