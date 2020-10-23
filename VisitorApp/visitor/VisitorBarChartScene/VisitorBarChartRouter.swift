

import UIKit

protocol VisitorBarChartRoutingLogic{
}

class VisitorBarChartRouter : VisitorBarChartRoutingLogic {
    static func visitorBarChartModule(visitorData : [Visit]) -> VisitorBarChartViewController {
        let barChartVC = VisitorBarChartRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorChartViewController") as! VisitorBarChartViewController
        barChartVC.datavisit = visitorData
        return barChartVC
    }
    
    static var mainstoryboard: UIStoryboard{
           return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
