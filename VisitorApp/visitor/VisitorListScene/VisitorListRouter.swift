

import UIKit

protocol visitorListProtocol {
    var navigationController: UINavigationController? { get }
}

class VisitorListRouter {
    
    var navigationController: UINavigationController?
    
    static func VisitorListModule() -> VisitorDataViewController {
        
        let viewController = VisitorListRouter.mainstoryboard.instantiateViewController(withIdentifier: "VisitorDataViewController") as! VisitorDataViewController
        let visitorListInteractorObject = VisitorListInteractor()
        let visitorListPresenterObject = VisitorListPresenter()
        let visitorListRouterObject = VisitorListRouter()
        
        viewController.visitorDataRouter = visitorListRouterObject
        viewController.interactor = visitorListInteractorObject
        visitorListInteractorObject.listPresenterProtocol = visitorListPresenterObject
        visitorListPresenterObject.viewDataObject = viewController

        return viewController
        
    }
    
    static var mainstoryboard: UIStoryboard{
           return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func routeToChart(data: [Visit],navigationController : UINavigationController){
       print("in route to chart function")
        print(data)
        let visitorChart = VisitorChartRouter.visitorChartmodule(visitData: data)
        navigationController.pushViewController(visitorChart, animated: true)
    }
    
    func routeToBarChart(fetcheddata : [Visit], navigationController : UINavigationController){
        print("In function route to barchart")
        print(fetcheddata)
        
        let visitorBarChart = VisitorBarChartRouter.visitorBarChartModule(visitorData: fetcheddata)
        navigationController.pushViewController(visitorBarChart, animated: true)
        
    }

}
