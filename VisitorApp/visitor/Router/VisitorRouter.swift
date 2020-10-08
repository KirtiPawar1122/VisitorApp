
import UIKit
 
protocol VisitorRoutingLogic {
     func routeToVisitorList()
}

class VisitorRouter : VisitorRoutingLogic {
    
    var viewcontroller : VisitorViewController?
    
    func routeToVisitorList() {
        
        let visitorList = VisitorListRouter.VisitorListModule()
        viewcontroller?.navigationController?.pushViewController(visitorList, animated: true)
    }
    
}
