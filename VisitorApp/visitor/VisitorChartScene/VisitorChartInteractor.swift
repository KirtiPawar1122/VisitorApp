

import UIKit

class VisitorChartInteractor {

    var data : [Visit] = []
    var presenter : chartPrsenterProtocol?
    
    func loadData() {
        print(data)
        presenter?.chartData(visitdata: data)
    }
}
