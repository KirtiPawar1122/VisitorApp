
import UIKit

protocol VisitorListPresentationLogic {
 //   func visitorAllData(data : [Visit])
    func presentListFetchResult(response: VisitorList.fetchVisitorList.Response)
}

class VisitorListPresenter: VisitorListPresentationLogic  {
  
    var viewDataObject : VisitorListDisplayLogic?

  /*  func visitorAllData(data: [Visit]) {
        print(data)
        viewDataObject?.viewProtocol(visitorData: data)
    } */
    
    func presentListFetchResult(response: VisitorList.fetchVisitorList.Response) {
        print(response)
        let viewModelList = response.visit
        let viewModel = VisitorList.fetchVisitorList.ViewModel(visit: viewModelList)
        viewDataObject?.displayVisitorList(viewModel: viewModel)
    }
    
}
