

import UIKit

class VisitorPrintRouter {
    
    static func visitorPrintmodule(visitData: Visit) -> VisitorPrintViewController {
        let printVC = VisitorPrintRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorPrintViewController") as! VisitorPrintViewController
        printVC.printData = visitData
        return printVC
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
