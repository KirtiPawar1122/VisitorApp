
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
    
    func displayVisitorsData(viewModel: VisitorForm.fetchVisitorsRecord.ViewModel) {
        displayFetchRecordCalled = true
    }
    
  }
  
  // MARK: - Tests cases
  
    func testPresentFetchRecord()
  {
    // Given
    let spy = VisitorFormDisplayLogicSpy()
    sut?.viewObj = spy


    let visitorData = DisplayData(name: "Kirti", email: "k@gmail.com", phoneNo: "8411912075", purspose: "Meeting", date: Date(), companyName: "Wurth It", profileImage: "", contactPerson: "HR")
        
    let response = VisitorForm.fetchVisitorsRecord.Response(visitorData: [visitorData])
  
    // When
    sut?.presentFethcedResults(response: response)
    
    // Then
    XCTAssertTrue(spy.displayFetchRecordCalled, "presentFetchResults(response:) should ask the view controller to display the result")
  }
}
