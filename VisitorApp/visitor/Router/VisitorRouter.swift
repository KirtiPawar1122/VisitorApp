
import UIKit
 
protocol VisitorRoutingLogic {
     func routeToVisitorList()
}

class VisitorRouter : VisitorRoutingLogic {
    
    var viewcontroller : VisitorViewController?
    
    func routeToVisitorList() {
        let visitorList = VisitorListRouter.VisitorListModule()
       // let visitorList = VisitorListRouter.self
        viewcontroller?.navigationController?.pushViewController(visitorList, animated: true)
    }
    
}
