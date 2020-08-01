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
        
        toneView.layer.cornerRadius = toneView.bounds.height / 2
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            moveIn()
        } else {
            moveOut()
        }
    }
    
    func configure(review: Review) {
        self.nicknameLabel.text = review.author
        self.dateLabel.text = "" //review.team.rawValue
        self.descriptionLabel.text = review.text
        self.toneView.backgroundColor = review.category.color
        self.toneLabel.text = review.category.title
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

private extension Review.Category {
    var title: String {
        switch self {
        case .bug: return "🐛 Баг"
        case .comment: return "⛔️ Замечание"
        case .like: return "🎉 Похвала"
        case .proposal: return "🚀 Предложение"
        case .question: return "❓ Вопрос"
        default: return "💔 Неопределено"
        }
    }
    
    var color: UIColor {
        switch self {
        case .bug: return #colorLiteral(red: 1, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        case .comment: return #colorLiteral(red: 1, green: 0.8745098039, blue: 0.4196078431, alpha: 1)
        case .like: return #colorLiteral(red: 0.6078431373, green: 0.9294117647, blue: 0.5058823529, alpha: 1)
        case .proposal: return #colorLiteral(red: 0.6078431373, green: 0.9294117647, blue: 0.5058823529, alpha: 1)
        case .question: return #colorLiteral(red: 1, green: 0.8745098039, blue: 0.4196078431, alpha: 1)
        default: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
}
