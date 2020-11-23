
import UIKit
 
protocol VisitorRoutingLogic {
    func routeToVisitorList()
    func routeToVisitorPrint(data: Visit)
}

class VisitorRouter : VisitorRoutingLogic {
    
    var viewcontroller : VisitorViewController?
    
    func routeToVisitorList() {
        let visitorList = VisitorListRouter.VisitorListModule()
        viewcontroller?.navigationController?.pushViewController(visitorList, animated: true)
    }
    
    func routeToVisitorPrint(data: Visit) {
        print(data)
        let visitorPrint = VisitorPrintRouter.visitorPrintmodule(visitData: data)
        viewcontroller?.navigationController?.pushViewController(visitorPrint, animated: true)
    }
}
