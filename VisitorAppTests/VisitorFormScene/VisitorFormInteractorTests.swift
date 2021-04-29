
@testable import VisitorApp
import XCTest

class VisitorFormInteractorTests: XCTestCase
{
    
  // MARK: - Subject under test
  
  var sut: VisitorInteractor!
  var phoneNo: String?
    
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorFormInteractor()
    phoneNo = "8411912075"
  }
  
  override func tearDown()
  {
    super.tearDown()
    phoneNo = nil
  }
  
  // MARK: - Test setup
  
  func setupVisitorFormInteractor()
  {
    sut = VisitorInteractor()
    
  }
  
  // MARK: - Test doubles
  
  class VisitorFormPresentationLogicSpy:  VisitorFormPrsentationLogic
  {
   
    //var visits = [Visit]()
    var presentFetchRecordCalled = false
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response) {
        presentFetchRecordCalled = true
    }
    
    func presentFethcedResults(response: VisitorForm.fetchVisitorsRecord.Response) {
        presentFetchRecordCalled = true
    }
    
  }
  
  // MARK: - Tests Cases
  
  func testFetchRecord()
  {
    // Given
    let spy = VisitorFormPresentationLogicSpy()
    sut.presenter = spy

    let requestData = VisitorForm.fetchVisitorsRecord.Request(phoneNo: phoneNo)
    
    // When
    sut.fetchVisitorsReccord(request: requestData)
    
    // Then
    XCTAssertNotNil(spy.presentFetchRecordCalled, "Present Fetch Record is called")
  }
    
    func testSaveRecord(){
        
        let visitData = VisitModel(date: Date(), company: "Wurth It", purpose: "Meeting", contactPersonName: "HR", profileVisitImage: "")
        let requestSave = VisitorForm.saveVisitorsRecord.Request(email: "k@gmail.com", phonNo: "8411912075", profileImage: "", name: "Kirti Pawar", visits: [visitData.dictionary])
        
        sut.saveVisitorsRecord(request: requestSave)
        
        XCTAssert(true)
    }
}
