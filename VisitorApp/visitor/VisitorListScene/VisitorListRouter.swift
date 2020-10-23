

import UIKit

protocol visitorListRoutingLogic {
    func routeToChart(data: [Visit])
    func routeToBarChart(fetcheddata : [Visit])
}

class VisitorListRouter : visitorListRoutingLogic {
 
    var navigationController: UINavigationController?
    var viewController : VisitorListViewController?
    
   static func VisitorListModule() -> VisitorListViewController {
        
        let viewController = VisitorListRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorDataViewController") as! VisitorListViewController
        return viewController
        
    } 
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func routeToChart(data: [Visit]){
        print(data)
        let visitorChart = VisitorChartRouter.visitorChartmodule(visitData: data)
        viewController?.navigationController?.pushViewController(visitorChart, animated: true)
    }
    
    func routeToBarChart(fetcheddata : [Visit]){
      
        print(fetcheddata)
        let visitorBarChart = VisitorBarChartRouter.visitorBarChartModule(visitorData: fetcheddata)
        viewController?.navigationController?.pushViewController(visitorBarChart, animated: true)
    }

}
