

import Foundation


enum VisitorForm {
    
    enum fetchVisitorRecord{
        struct Request {
            var phoneNo: String?
        }
        
        struct Response {
            var visit: Visit?
        }
        
        struct ViewModel {
            var visit: Visit?
        }
    }
    
    enum saveVisitorRecord {
        struct Request {
            var name: String?
            var email: String
            var phoneNo: String?
            var visitPurpose: String?
            var visitingName: String?
            var companyName: String?
            var profileImage: Data?
            var currentDate: Date?
        }
        
        struct Response {
            
        }
        
        struct  ViewModel {
            
        }
    }
    
    enum saveVisitorsRecord {
        struct Request {
            var email: String
            var phonNo: String
            var profileImage: String
            var name: String
            var visits: [[String: Any]]
        }
        
        struct Response {
            
        }
        
        struct  ViewModel {
            
        }
    }
    
    enum fetchVisitorsRecord{
        struct Request {
            var phoneNo: String?
        }
        
        struct Response {
            var visitorData: DisplayData
        }
        
        struct ViewModel {
            var visitorData: DisplayData
        }
    }
    
}
