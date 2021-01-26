
@testable import VisitorApp
import XCTest

class VisitorFormInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorInteractor!
  var phoneNo: String?
  // MARK: Test lifecycle
  
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
  
  // MARK: Test setup
  
  func setupVisitorFormInteractor()
  {
    sut = VisitorInteractor()
    
  }
  
  // MARK: Test doubles
  
  class VisitorFormPresentationLogicSpy:  VisitorFormPrsentationLogic
  {
   
    //var visits = [Visit]()
    var presentFetchRecordCalled = false
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response) {
        presentFetchRecordCalled = true
    }
  }
  
  // MARK: Tests
  
  func testFetchRecord()
  {
    // Given
    let spy = VisitorFormPresentationLogicSpy()
    sut.presenter = spy
    let requestData = VisitorForm.fetchVisitorRecord.Request(phoneNo: phoneNo)
    
    // When
    sut.fetchRequest(request: requestData)
    
    // Then
    XCTAssertNotNil(spy.presentFetchRecordCalled, "Present Fetch Record is called")
  }
    
}
