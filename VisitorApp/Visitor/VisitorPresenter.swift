

import UIKit

protocol PresenterProtocol {
    func getDatafromInteractor(visitorData : [Visit])
    func getCompareEmailData(compareData: [Visit])
}


class VisitorPresenter: PresenterProtocol {
    
    var viewObj: ViewProtocol?
    
    func getDatafromInteractor(visitorData: [Visit]) {
        print(visitorData)
        viewObj?.loadData(visitorData: visitorData)
    }
    
    func getCompareEmailData(compareData: [Visit]) {
        print(compareData)
    }
}
