

import Foundation

enum VisitorList {
    
    enum fetchVisitorList{
        struct Request {
            
        }
        struct Response {
            var visit : [Visit]?
        }
        struct ViewModel {
            var visit : [Visit]?
        }
    }
    
   
}
