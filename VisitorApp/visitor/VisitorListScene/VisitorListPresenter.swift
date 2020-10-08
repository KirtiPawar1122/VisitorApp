
import UIKit

protocol VisitorListPresentationLogic {
    func presentListFetchResult(response: VisitorList.fetchVisitorList.Response)
}

class VisitorListPresenter: VisitorListPresentationLogic  {
  
    var viewDataObject : VisitorListDisplayLogic?
    
    func presentListFetchResult(response: VisitorList.fetchVisitorList.Response) {
        print(response)
        let viewModelList = response.visit
        let viewModel = VisitorList.fetchVisitorList.ViewModel(visit: viewModelList)
        viewDataObject?.displayVisitorList(viewModel: viewModel)
    }
    
}
