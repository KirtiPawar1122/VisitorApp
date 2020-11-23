
import UIKit

class VisitorPrintViewController: UIViewController {

    
    @IBOutlet var visitorCardView: UIView!
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var printButton: UIButton!
    @IBOutlet var VisitDate: UILabel!
    @IBOutlet var visitorName: UILabel!
    @IBOutlet var companyName: UILabel!
    
    @IBOutlet var companyLogo: UIImageView!
    var printData = Visit()
    var selectedImge = "no-image"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(printData)
       
        VisitDate.text = printData.date
        visitorName.text = printData.visitors?.value(forKey: "name") as? String
        print(printData.visitors?.value(forKey: "profileImage") as! Data)
        let image = UIImage(data: printData.visitors?.value(forKey: "profileImage") as! Data)
        print(image!)
        profileImage.image = image
        
        //companyName.text = "Wurth IT India Pvt. Ltd."
        visitorCardView.layer.borderWidth = 3
        visitorCardView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        visitorCardView.layer.cornerRadius = 10
    
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        visitorCardView.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        printButton.layer.cornerRadius = 5
        printButton.layer.borderColor = UIColor.black.cgColor
        printButton.layer.shadowColor = UIColor.black.cgColor
        printButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        printButton.layer.shadowRadius = 5
        printButton.layer.shadowOpacity = 1.0
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backImage")!)
        
    }

}
