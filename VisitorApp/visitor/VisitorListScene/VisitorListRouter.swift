

import UIKit

struct VisitorListRouterConstants {
    static let visitorListViewController = "VisitorDataViewController"
    static let mainStoryboard = "Main"
}


protocol visitorListRoutingLogic {
    func routeToChart(data: [Visit])
    func routeToBarChart(fetcheddata: [Visit], selectedData: Visit)
   // func routeToBarChartData(selectedData: Visit)
}

class VisitorListRouter : visitorListRoutingLogic {
 
    var navigationController: UINavigationController?
    var viewController : VisitorListViewController?
    
   static func VisitorListModule() -> VisitorListViewController {
        
    let viewController = VisitorListRouter.mainstoryboard.instantiateViewController(withIdentifier: VisitorListRouterConstants.visitorListViewController) as! VisitorListViewController
        return viewController
    } 
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:VisitorListRouterConstants.mainStoryboard,bundle: Bundle.main)
    }
    
    func routeToChart(data: [Visit]){
        //print(data)
        let visitorChart = VisitorChartRouter.visitorChartModule(visitData: data)
        viewController?.navigationController?.pushViewController(visitorChart, animated: true)
    }
    
    func routeToBarChart(fetcheddata: [Visit], selectedData: Visit){
        let visitorBarChart = VisitorBarChartRouter.visitorBarChartModule(visitorAllData: fetcheddata, visitorData: selectedData)
        viewController?.navigationController?.pushViewController(visitorBarChart, animated: true)
    }
}
