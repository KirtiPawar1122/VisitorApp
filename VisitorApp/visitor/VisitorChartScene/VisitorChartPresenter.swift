

import UIKit

protocol chartPrsenterProtocol {
    func chartData(visitdata : [Visit])
}

class VisitorChartPresenter : chartPrsenterProtocol {
    
    var viewObj : loadDataOnChartProtocol?
    
    func chartData(visitdata: [Visit]) {
        print(visitdata)
        viewObj?.loadData(fetchedData: visitdata)
    }

}
