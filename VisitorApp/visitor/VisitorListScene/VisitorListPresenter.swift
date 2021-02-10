
import UIKit

protocol VisitorListPresentationLogic {
    func presentVisitorListResult(response: VisitorList.fetchVisitorList.Response)
}

class VisitorListPresenter: VisitorListPresentationLogic  {
  
    var viewDataObject : VisitorListDisplayLogic?
    
    func presentVisitorListResult(response: VisitorList.fetchVisitorList.Response) {
        //print(response)
        let viewModelList = response.visit
        let viewModel = VisitorList.fetchVisitorList.ViewModel(visit: viewModelList)
        viewDataObject?.displayVisitorList(viewModel: viewModel)
    }
}
