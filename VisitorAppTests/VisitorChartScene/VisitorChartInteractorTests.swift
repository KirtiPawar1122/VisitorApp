
@testable import VisitorApp
import XCTest

class VisitorChartInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorChartInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorChartInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorChartInteractor()
  {
    sut = VisitorChartInteractor()
  }
  
  // MARK: Test doubles
  
  class VisitorChartPresentationLogicSpy: VisitorChartPresentationLogic
  {
   
    
    var presentChartDataCalled = false
    
    func prsentChartData(response: VisitorChart.VisitorChartData.Response) {
        presentChartDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testChartData()
  {
    // Given
    let spy = VisitorChartPresentationLogicSpy()
    sut.presenter = spy
    let request = VisitorChart.VisitorChartData.Request()
    
    // When
    sut.visitorsChartData(request: request)
    
    // Then
    XCTAssertTrue(spy.presentChartDataCalled, "visitorChartData(request:) should ask the presenter to format the result")
  }
}
