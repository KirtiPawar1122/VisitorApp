

@testable import VisitorApp
import XCTest

class VisitorListInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorListInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorListInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorListInteractor()
  {
    sut = VisitorListInteractor()
  }
  
  // MARK: Test doubles
  
  class VisitorListPresentationLogicSpy: VisitorListPresentationLogic
  {
   
    func presentAllVisitorsRecord(response: VisitorList.fetchVisitorRecordByName.Response) {
        print(response)
    }

    var visits = [Visit]()
    var presentFethcedDataCalled = false
    func presentVisitorListResult(response: VisitorList.fetchVisitorList.Response) {
        presentFethcedDataCalled = true
        let res = response.visit
        visits = res!
    }
    
    var displayData = [DisplayData]()
    func presentVisitorsList(response: VisitorList.fetchAllVisitorsList.Response) {
        presentFethcedDataCalled = true
        let res = response.visitorList
        displayData = res
    }
    
  }
  
  // MARK: Tests    
    
    func testForFetchVisitorsRecord() {
        let spy = VisitorListPresentationLogicSpy()
        sut.listPresenterProtocol = spy
         
        let request = VisitorList.fetchAllVisitorsList.Request()
        sut.fetchVisitorList(request: request)
            
        XCTAssertNotNil(spy.presentFethcedDataCalled, "Present Fetch Record is called")
    }
}
