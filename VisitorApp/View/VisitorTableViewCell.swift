

import UIKit

class VisitorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var visitorName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var visitPurpose: UILabel!
    @IBOutlet weak var subView: UIView!
    
    var currentDate = Date()
    override func awakeFromNib() {
        super.awakeFromNib()
        cellConfigure()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var cornerRadius: CGFloat = 10
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 3
    var shadowColor: UIColor? = UIColor.white
    var shadowOpacity: Float = 0.5
    
    func cellConfigure(){
        innerView.layer.masksToBounds = false
        innerView.backgroundColor = #colorLiteral(red: 0.9530216518, green: 0.9518444257, blue: 0.9521387322, alpha: 1)
        innerView.layer.borderWidth = 0
        innerView.layer.borderColor = UIColor.black.cgColor
        date.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        visitorName.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        visitPurpose.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
   /* func setUpCellData(visitData: Visit){
        visitorName.text = visitData.visitors?.value(forKey: "name") as? String
        visitPurpose.text = visitData.purpose
        
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatterForDisplayDate
        guard let compareDate = visitData.date else { return }
        let compareDbDate = formatter.string(from: compareDate)
        let compareDateDbDate = formatter.date(from: compareDbDate)
        let timedata = getDateDifference(start: compareDateDbDate!, end: currentDate)
        //print(visitData)
        date.text = compareDbDate
        if timedata <= VisitorDataViewControllerConstants.timeLimit {
            subView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            subView.backgroundColor = #colorLiteral(red: 0.6087739468, green: 0.09021262079, blue: 0.1081616506, alpha: 1)
        }
    } */
    func setUpCellData(visitData: DisplayData){
        visitorName.text = visitData.name
        visitPurpose.text = visitData.purspose
        guard let profileURL = URL(string: visitData.profileImage) else { return }
        profileImage.af.setImage(withURL: profileURL)
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatterForDisplayDate
        let compareDate = visitData.date
        let compareDbDate = formatter.string(from: compareDate)
        let compareDateDbDate = formatter.date(from: compareDbDate)
        let timedata = getDateDifference(start: compareDateDbDate!, end: currentDate)
        //print(visitData)
        date.text = compareDbDate
        if timedata <= VisitorDataViewControllerConstants.timeLimit {
            subView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            subView.backgroundColor = #colorLiteral(red: 0.6087739468, green: 0.09021262079, blue: 0.1081616506, alpha: 1)
        }
    }
    
    
    func getDateDifference(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)
        
        let seconds = dateComponents.second
        return Int(seconds! / 3600)
    }
}
