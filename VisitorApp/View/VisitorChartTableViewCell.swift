

import UIKit

class VisitorChartTableViewCell: UITableViewCell {

    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!

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
        sectionLabel.font = UIFont(name: VisitorsChartViewControllerConstants.font, size: VisitorsChartViewControllerConstants.fontSize)
        dataLabel.font = UIFont(name: VisitorsChartViewControllerConstants.font, size: VisitorsChartViewControllerConstants.fontSize)
    }

}
