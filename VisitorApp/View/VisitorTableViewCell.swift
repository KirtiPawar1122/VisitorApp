

import UIKit

class VisitorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var visitorName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var emailID: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var visitPurpose: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
     var cornerRadius: CGFloat = 10
     var shadowOffsetWidth: Int = 0
     var shadowOffsetHeight: Int = 3
     var shadowColor: UIColor? = UIColor.white
     var shadowOpacity: Float = 0.5
    
     override func layoutSubviews() {
        
        //innerView.layer.cornerRadius = cornerRadius
        innerView.layer.masksToBounds = false
        innerView.backgroundColor = #colorLiteral(red: 0.9530216518, green: 0.9518444257, blue: 0.9521387322, alpha: 1)
       // innerView.layer.shadowColor = shadowColor?.cgColor
        //subView.layer.cornerRadius = 5
        //innerView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        //innerView.layer.shadowOpacity = shadowOpacity
        innerView.layer.borderWidth = 0
        innerView.layer.borderColor = UIColor.black.cgColor
        //subView.backgroundColor = #colorLiteral(red: 0.6087739468, green: 0.09021262079, blue: 0.1081616506, alpha: 1)
        date.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        visitorName.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        visitPurpose.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //profileImage.contentMode = .scaleAspectFit
    }
}
