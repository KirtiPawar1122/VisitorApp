
import UIKit

class VisitorRouter {
    
    class func getFirstScreen() -> VisitorViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier:"VisitorViewController") as! VisitorViewController
        
        let interactorObj = VisitorInteractor()
        let presenter = VisitorPresenter()
                
        view.interactor = interactorObj
        interactorObj.presenterProtocol = presenter
        presenter.viewObj = view
        
        return view
    }

}
