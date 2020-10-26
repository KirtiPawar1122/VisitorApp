
@testable import VisitorApp
import XCTest

class VisitorBarChartPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorBarChartPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorBarChartPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorBarChartPresenter()
  {
    sut = VisitorBarChartPresenter()
  }
  
  // MARK: Test doubles
  
  class VisitorBarChartDisplayLogicSpy: VisitorBarChartDisplayLogic
  {
   
    var displayChartDataCalled = false
    func displayVisitorBarChartData(viewModel: VisitorBarChart.VisitorBarChartData.ViewModel) {
        displayChartDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testPresentBarChartData()
  {
    // Given
    let spy = VisitorBarChartDisplayLogicSpy()
    sut.viewObject = spy
    let response = VisitorBarChart.VisitorBarChartData.Response(visitData: [])
    
    // When
    sut.presentVisitorBarChartData(response: response)
    
    // Then
    XCTAssertTrue(spy.displayChartDataCalled, "presentVisitorBarChartData(response:) should ask the view controller to display the result")
  }
}
