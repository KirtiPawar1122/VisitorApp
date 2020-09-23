
import UIKit

class VisitorRouter {
    
    class func getFirstScreen() -> VisitorViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier:"VisitorViewController") as! VisitorViewController
        
        let interactorObject = VisitorInteractor()
        let presenter = VisitorPresenter()
        
        view.interactor = interactorObject
        interactorObject.presenterProtocol = presenter
        presenter.viewObj = view
        
        return view
    }

}
