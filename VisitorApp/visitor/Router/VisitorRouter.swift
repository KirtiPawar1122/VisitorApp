
import UIKit
 
protocol VisitorRoutingLogic {
    func routeToVisitorList()
    func routeToVisitorPrint(phoneNo: String)
}

class VisitorRouter : VisitorRoutingLogic {
    
    var viewcontroller : VisitorViewController?
    
    func routeToVisitorList() {
        let visitorList = VisitorListRouter.VisitorListModule()
        viewcontroller?.navigationController?.pushViewController(visitorList, animated: true)
    }
    
    func routeToVisitorPrint(phoneNo: String) {
        //print(phoneNo)
        let visitorPrint = VisitorPrintRouter.visitorPrintmodule(visitorPhoneNo: phoneNo)
        viewcontroller?.navigationController?.pushViewController(visitorPrint, animated: true)
    }
}
