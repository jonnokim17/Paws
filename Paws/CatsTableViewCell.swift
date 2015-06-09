//
//  CatsTableViewCell.swift
//  Paws
//
//  Created by Jonathan Kim on 6/9/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit

class CatsTableViewCell: PFTableViewCell {

    @IBOutlet weak var catImageView: UIImageView?
    @IBOutlet weak var catNameLabel: UILabel?
    @IBOutlet weak var catVotesLabel: UILabel?
    @IBOutlet weak var catCreditLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
