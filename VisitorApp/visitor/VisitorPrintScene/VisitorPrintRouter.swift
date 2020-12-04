

import UIKit

class VisitorPrintRouter {
    
    static func visitorPrintmodule(visitorEmail: String) -> VisitorPrintViewController {
        let printVC = VisitorPrintRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorPrintViewController") as! VisitorPrintViewController
       // printVC.printData = visitData
        printVC.selectedEmail = visitorEmail
        return printVC
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
