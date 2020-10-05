

import UIKit

class VisitorBarChartRouter {
    
    
    static func visitorBarChartModule(visitorData : [Visit]) -> VisitorChartViewController {
     
        let barChartVC = VisitorBarChartRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorChartViewController") as! VisitorChartViewController
        
        let visitorBarChartRouterObject = VisitorBarChartRouter()
        let visitorBarChartInteractorObject = VisitorBarChartInteractor()
        let visitorBarChartPresenterObject = VisitorBarChartPresenter()
        
        visitorBarChartInteractorObject.data = visitorData
        barChartVC.barChartRouter = visitorBarChartRouterObject
        barChartVC.barChartInterator = visitorBarChartInteractorObject
        visitorBarChartInteractorObject.presenterObj = visitorBarChartPresenterObject
        visitorBarChartPresenterObject.viewObject = barChartVC 
        
        return barChartVC
    }
    
    static var mainstoryboard: UIStoryboard{
           return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    
    
}
