

import UIKit

protocol VisitorChartRoutingLogic {
}

struct VisitorChartRouterConstants {
    static let chartIdentifier = "ChartViewController"
    static let mainStoryboard = "Main"
}

class VisitorChartRouter : VisitorChartRoutingLogic {
  
    static func visitorChartModule() -> VisitorChartViewController {
        let chartVC = VisitorChartRouter.mainstoryboard.instantiateViewController(withIdentifier:  VisitorChartRouterConstants.chartIdentifier ) as! VisitorChartViewController
        //chartVC.visits = visitData
        return chartVC
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name: VisitorChartRouterConstants.mainStoryboard,bundle: Bundle.main)
    }
    
}
