//
//  OpCodeTableViewCell.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/10/20.
//

import UIKit

class OpCodeTableViewCell: UITableViewCell {

    //Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
