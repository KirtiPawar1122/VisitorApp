//
//  VisitorChartTableViewCell.swift
//  VisitorApp
//
//  Created by Mayur Kamthe on 04/09/20.
//  Copyright © 2020 Mayur Kamthe. All rights reserved.
//

import UIKit

class VisitorChartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var meetingLabel: UILabel!
    @IBOutlet weak var otherLable: UILabel!
    @IBOutlet weak var guestvisitLable: UILabel!
    @IBOutlet weak var interviewLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
