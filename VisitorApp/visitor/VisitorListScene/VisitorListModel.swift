

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
    
    enum fetchVisitorRecordByName{
        struct Request {
            var name: String?
        }
        struct Response {
            var visit: [Visit]?
        }
        struct ViewModel {
            var visit: [Visit]?
        }
    }
}
