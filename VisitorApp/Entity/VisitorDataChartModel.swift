
import Foundation
enum VisitPurpose : String, CaseIterable{
    case meeting
    case guestVisit
    case interview
    case other
    
}
struct  VisitData {
    var visitPurpose : VisitPurpose
    var purposeCount : Int
}

struct VisitorChartDataModel{
    var totalVisit : Int
    var visitTypes = [VisitData]()
}
