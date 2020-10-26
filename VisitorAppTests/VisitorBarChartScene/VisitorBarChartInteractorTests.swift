

@testable import VisitorApp
import XCTest

class VisitorBarChartInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorBarChartInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorBarChartInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorBarChartInteractor()
  {
    sut = VisitorBarChartInteractor()
  }
  
  // MARK: Test doubles
  
  class VisitorBarChartPresentationLogicSpy: VisitorBarChartPresentationLogic
  {
   
    var presentChartDataCalled = false
    
    func presentVisitorBarChartData(response: VisitorBarChart.VisitorBarChartData.Response) {
        presentChartDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testBarChartData()
  {
    // Given
    let spy = VisitorBarChartPresentationLogicSpy()
    sut.presenter = spy
    let request = VisitorBarChart.VisitorBarChartData.Request()
    
    // When
    sut.visitorBarChartData(request: request)
    
    // Then
    XCTAssertTrue(spy.presentChartDataCalled, "VisitorBarChartData(request:) should ask the presenter to format the result")
  }
}
