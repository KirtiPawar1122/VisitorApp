

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
    func displayAllVisitors(viewModel: VisitorList.fetchVisitorRecordByName.ViewModel) {
        print(viewModel)
    }
    var displayVisit : [Visit] = []
    var displayVisitorListCalled = false
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel) {
        displayVisitorListCalled = true
        let viewModelList = viewModel.visit
        displayVisit = viewModelList!
    }
    var displayData : [DisplayData] = []
    func displayVisitorsReccord(viewModel: VisitorList.fetchAllVisitorsList.ViewModel) {
        print(viewModel)
        displayVisitorListCalled = true
        let visitorList = viewModel.visitorList
        displayData = visitorList
    }
  }
  
  // MARK: Tests
    
    func testPresentVisitorList(){
        let spy = VisitorListDisplayLogicSpy()
        sut.viewDataObject = spy
        let response = VisitorList.fetchAllVisitorsList.Response(visitorList: [])
        sut.presentVisitorsList(response: response)
        
        XCTAssertTrue(spy.displayVisitorListCalled, "prsentingVisitorList response should ask the viewController to display thhe result.")
    }
    
}
