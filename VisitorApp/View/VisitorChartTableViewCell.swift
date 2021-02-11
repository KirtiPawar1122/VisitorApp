

import UIKit

class VisitorChartTableViewCell: UITableViewCell {

    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
}
