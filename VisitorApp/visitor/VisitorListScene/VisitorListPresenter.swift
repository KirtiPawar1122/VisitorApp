
import UIKit

protocol VisitorListPresenterProtocol {
    func visitorAllData(data : [Visit])
}

class VisitorListPresenter : VisitorListPresenterProtocol {
    
    var viewDataObject : VisitorDataProtocol?

    func visitorAllData(data: [Visit]) {
        print(data)
        viewDataObject?.viewProtocol(visitorData: data)
    }
}
