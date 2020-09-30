

import UIKit

protocol PresenterProtocol {
    func dataFromInteractor(visitorData : [Visit])
    func compareData(compareData: [Visitor])
}

class VisitorPresenter: PresenterProtocol {

    var viewObj: ViewProtocol?
    func dataFromInteractor(visitorData: [Visit]) {
        print(visitorData)
        viewObj?.loadData(visitorData: visitorData)
    }
    
    func compareData(compareData: [Visitor]) {
        print(compareData)
        viewObj?.compareData(compareEmail: compareData)
    }
}
