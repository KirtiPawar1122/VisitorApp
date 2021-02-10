
import UIKit
 
protocol VisitorRoutingLogic {
    func routeToVisitorList()
    func routeToVisitorPrint(phoneNo: String)
}

class VisitorRouter : VisitorRoutingLogic {
    
    var viewController : VisitorViewController?
    
    func routeToVisitorList() {
        let visitorList = VisitorListRouter.VisitorListModule()
        viewController?.navigationController?.pushViewController(visitorList, animated: true)
    }
    
    func routeToVisitorPrint(phoneNo: String) {
        print(phoneNo)
        let visitorPrint = VisitorPrintRouter.visitorPrintModule(visitorPhoneNo: phoneNo)
        viewController?.navigationController?.pushViewController(visitorPrint, animated: true)
    }
}
