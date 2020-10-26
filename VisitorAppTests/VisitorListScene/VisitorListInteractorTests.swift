

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
    
    var visits = [Visit]()
    var presentFethcedDataCalled = false
    func presentVisitorListResult(response: VisitorList.fetchVisitorList.Response) {
        presentFethcedDataCalled = true
        let res = response.visit
        visits = res
    }
  }
  
  // MARK: Tests
  
  func testForFetchAllVisitorData()
  {
    // Given
    let spy = VisitorListPresentationLogicSpy()
    sut.listPresenterProtocol = spy
    
    let request = VisitorList.fetchVisitorList.Request()
    
    // When
    sut.fetchVisitorData(request: request)
    
    // Then
    XCTAssertTrue(spy.presentFethcedDataCalled, "fetchVisitorData(request:) should ask the presenter to format the result")
    XCTAssertNotNil(spy.visits.count, "Data is not nil")
  }
}
