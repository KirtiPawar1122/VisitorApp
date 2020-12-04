
import UIKit
 
protocol VisitorRoutingLogic {
    func routeToVisitorList()
    func routeToVisitorPrint(email: String)
}

class VisitorRouter : VisitorRoutingLogic {
    
    var viewcontroller : VisitorViewController?
    
    func routeToVisitorList() {
        let visitorList = VisitorListRouter.VisitorListModule()
        viewcontroller?.navigationController?.pushViewController(visitorList, animated: true)
    }
    
    func routeToVisitorPrint( email: String) {
        //print(data)
        print(email)
        let visitorPrint = VisitorPrintRouter.visitorPrintmodule(visitorEmail: email)
        viewcontroller?.navigationController?.pushViewController(visitorPrint, animated: true)
    }
}
