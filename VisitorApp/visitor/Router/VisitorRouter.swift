
import UIKit

class VisitorRouter {
    weak var navigationController: UINavigationController?

    class func mainScreen() -> VisitorViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier:"VisitorViewController") as! VisitorViewController
        
        let interactorObject = VisitorInteractor()
        let presenter = VisitorPresenter()
        let router = VisitorRouter()
        
        view.interactor = interactorObject
        interactorObject.presenterProtocol = presenter
        presenter.viewObj = view
        view.router = router

        return view
    }
    
   func routeToVisitorList() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorDataViewController") as! VisitorDataViewController
        navigationController?.pushViewController(vc, animated: true)
       
    }
}
