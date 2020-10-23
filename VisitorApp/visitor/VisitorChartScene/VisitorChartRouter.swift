

import UIKit

protocol VisitorChartRoutingLogic {
}


class VisitorChartRouter : VisitorChartRoutingLogic {
  
    static func visitorChartmodule(visitData : [Visit]) -> VisitorChartViewController {
        let chartVC = VisitorChartRouter.mainstoryboard.instantiateViewController(withIdentifier: "ChartViewController") as! VisitorChartViewController
        chartVC.visits = visitData
        return chartVC
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
}
