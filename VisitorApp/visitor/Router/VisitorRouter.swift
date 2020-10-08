
import UIKit

struct VisitorRouterConstants {
    static let storyboardName = "Main"
    static let viewName = "VisitorViewController"
}
 
protocol routerProtocol {
     var navigationController: UINavigationController? { get }
     func routeToVisitorList(navigationController: UINavigationController)
    
}
class VisitorRouter : routerProtocol {
    var navigationController: UINavigationController?

   /* class func mainScreen() -> VisitorViewController {
        let storyboard = UIStoryboard(name: VisitorRouterConstants.storyboardName, bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: VisitorRouterConstants.viewName) as! VisitorViewController
        
        let interactorObject = VisitorInteractor()
        let presenter = VisitorPresenter()
        let router = VisitorRouter()
        
        view.router = router
        view.interactor = interactorObject
        interactorObject.presenter = presenter
        presenter.viewObj = view 
      //  router.navigationController = view.navigationController
        return view
    }  */
    
    func routeToVisitorList(navigationController: UINavigationController) {
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorDataViewController") as! VisitorDataViewController
        let VisitorList = VisitorListRouter.VisitorListModule()
        navigationController.pushViewController(VisitorList, animated: true)
    }
}
