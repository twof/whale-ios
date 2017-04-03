//
//  AnswerCell.swift
//  Whale
//
//  Created by fnord on 3/31/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit
import AlamofireImage

class AnswerCell: UITableViewCell {

    @IBOutlet weak var videoThumbnailImageView: UIImageView! = UIImageView()
    @IBOutlet weak var fromUserLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(answer: AnswerViewModel) -> Self{
        answer.getImage(completion: { (image) in
            self.videoThumbnailImageView.image = image
        })
       
        fromUserLabel.text = answer.questionSenderText
        return self
    }
}
