

import UIKit

class VisitorChartRouter {
    
    static func visitorChartmodule(visitData : [Visit]) -> ChartViewController {
        let chartVC = VisitorChartRouter.mainstoryboard.instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
        
        let VisitorChartRouterObject = VisitorChartRouter()
        let VisitorChartInteractorObject = VisitorChartInteractor()
        let VisitorChartPresenterObject = VisitorChartPresenter()
     
        VisitorChartInteractorObject.data = visitData
        chartVC.chartRouter = VisitorChartRouterObject
        chartVC.chartInteractor = VisitorChartInteractorObject
        VisitorChartInteractorObject.presenter = VisitorChartPresenterObject
        VisitorChartPresenterObject.viewObj = chartVC

        return chartVC
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
}
