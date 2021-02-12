

import UIKit

class VisitorPieChartTableViewCell: UITableViewCell {

     @IBOutlet var sectionTitleLabel: UILabel!
     @IBOutlet var dataCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCellUI(){
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        layer.backgroundColor = UIColor.clear.cgColor
        sectionTitleLabel.font = UIFont(name: ChartViewControllerConstants.boldFont, size: ChartViewControllerConstants.defaultFontSize)
        dataCountLabel.font = UIFont(name: ChartViewControllerConstants.boldFont, size: ChartViewControllerConstants.defaultFontSize)
        sectionTitleLabel.textColor = UIColor.white
        dataCountLabel.textColor = UIColor.white
    }
    
}
