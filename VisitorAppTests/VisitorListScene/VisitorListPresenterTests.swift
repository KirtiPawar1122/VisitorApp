

@testable import VisitorApp
import XCTest

class VisitorListPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorListPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorListPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorListPresenter()
  {
    sut = VisitorListPresenter()
  }
  
  // MARK: Test doubles
  
  class VisitorListDisplayLogicSpy: VisitorListDisplayLogic
  {
    
    var displayVisit : [Visit] = []
    var displayVisitorListCalled = false
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel) {
        displayVisitorListCalled = true
        let viewModelList = viewModel.visit
        displayVisit = viewModelList!
    }

  }
  
  // MARK: Tests
  
  func testPresentSomething()
  {
    //Given
    let spy = VisitorListDisplayLogicSpy()
    sut.viewDataObject = spy
    let response = VisitorList.fetchVisitorList.Response(visit: [])
    
    //When
    sut.presentVisitorListResult(response: response)
    
    //Then
   // XCTAssertTrue(spy.displayVisitorListCalled, "prsentingVisitorList response should ask the viewController to display thhe result.")
   }
}
