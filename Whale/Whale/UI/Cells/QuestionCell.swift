//
//  QuestionCell.swift
//  Whale
//
//  Created by fnord on 3/29/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    var question: Question? = nil

    @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(question: Question) -> Self {
        self.question = question
        questionLabel.text = self.question?.content
        return self
    }
}
