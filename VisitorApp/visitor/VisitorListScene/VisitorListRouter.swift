

import UIKit

class VisitorListRouter {
    
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

}
