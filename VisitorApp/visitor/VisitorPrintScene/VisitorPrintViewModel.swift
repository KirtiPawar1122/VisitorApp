

import Foundation

enum VisitorPrint {

   enum VisitorPrintData {
    
      struct Request  {
        var phoneNo: String?
       }
    
       struct Response {
           var visitData: Visit?
       }
    
       struct ViewModel {
           var visitData: Visit?
        }
    }
}
