
@testable import VisitorApp
import XCTest


class VisitorFormInteractorTest: XCTestCase {
    
    var interactorTest = VisitorInteractor()
   
    // MARK: - Test lifecycle
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    class VisitorFormPresentationLogicTest: VisitorFormPrsentationLogic {
        var presentFetchResultsObject = false
        
        func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response){
            presentFetchResultsObject = true
            print(response)
        }
        
    }

    // MARK: test for Fetch Record
    func testFetchRecord() {
        
        //Given
        let email = "k@gmail.com"
        let visitorFormPresentationLogicTest = VisitorFormPresentationLogicTest()
        interactorTest.presenter = visitorFormPresentationLogicTest
        
        //When
        let request = VisitorForm.fetchVisitorRecord.Request(email: email)
        interactorTest.fetchRequest(request: request)
        
        //Then
        XCTAssert(visitorFormPresentationLogicTest.presentFetchResultsObject, "fetchRequest()")
        }
    
    //MARK: test for Save Data
    func testSaveData(){
        
        //Given
        let requestSave = VisitorForm.saveVisitorRecord.Request(name: "abc", address: "abc", email: "k@gmail.com", phoneNo: 1234567890, visitPurpose: "Other", visitingName: "HR", companyName: "Wurth", profileImage: Data(), currentDate: "")
        
        //When
        interactorTest.saveVisitorRecord(request: requestSave)
        
        //Then
        XCTAssert(true)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            //Put the code you want to measure the time of here.
        }
    }

}
