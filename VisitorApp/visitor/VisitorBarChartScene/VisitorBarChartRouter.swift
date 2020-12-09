

import UIKit

protocol VisitorBarChartRoutingLogic{
    func routeToPrintVisitors()
}

class VisitorBarChartRouter : VisitorBarChartRoutingLogic {
   
    var viewController: VisitorBarChartViewController?
    var navigationController: UINavigationController?
    
    static func visitorBarChartModule(visitorAllData: [Visit], visitorData: Visit) -> VisitorBarChartViewController {
        let barChartVC = VisitorBarChartRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorChartViewController") as! VisitorBarChartViewController
        barChartVC.datavisit = visitorAllData
        barChartVC.selectedData = visitorData
        return barChartVC
    }
    
    static var mainstoryboard: UIStoryboard{
           return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func routeToPrintVisitors() {
        //let visitorData = VisitorPrintRouter.visitorPrintmodule(visitData: data)
        //viewController?.navigationController?.pushViewController(visitorData, animated: true)
     }
}
