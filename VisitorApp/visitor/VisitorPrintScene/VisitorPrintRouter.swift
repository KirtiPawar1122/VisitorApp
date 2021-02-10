

import UIKit

class VisitorPrintRouter {
    
    static func visitorPrintModule(visitorPhoneNo: String) -> VisitorPrintViewController {
        let printVC = VisitorPrintRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorPrintViewController") as! VisitorPrintViewController
        printVC.selectedPhoneNo = visitorPhoneNo
        return printVC
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
