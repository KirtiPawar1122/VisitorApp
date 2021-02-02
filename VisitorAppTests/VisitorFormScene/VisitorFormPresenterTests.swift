
@testable import VisitorApp
import XCTest

class VisitorFormPresenterTests: XCTestCase
{
  // MARK: - Subject under test
  
   var sut: VisitorPresenter?
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorFormPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
    sut = nil
  }
  
  // MARK: - Test setup
  
  func setupVisitorFormPresenter()
  {
     sut = VisitorPresenter()
  }
  
  // MARK: - Test doubles
  
  class VisitorFormDisplayLogicSpy: VisitorFormDisplayLogic
  {
    var displayFetchRecordCalled = false
    
    func displayVisitorData(viewModel: VisitorForm.fetchVisitorRecord.ViewModel) {
        displayFetchRecordCalled = true
    }
  }
  
  // MARK: - Tests cases
  
    func testPresentFetchRecord()
  {
    // Given
    let spy = VisitorFormDisplayLogicSpy()
    sut?.viewObj = spy

    let visits = Visit()
    let response = VisitorForm.fetchVisitorRecord.Response(visit: visits)
  
    // When
    sut?.presentFetchResults(response: response)
    
    // Then
    XCTAssertTrue(spy.displayFetchRecordCalled, "presentFetchResults(response:) should ask the view controller to display the result")
  }
}
