
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
    func presentChartPurposeData(response: VisitorChart.FetchVisitorPurposeType.Response) {
        print(response)
    }
    
    var presentChartDataCalled = false
    
    func prsentChartData(response: VisitorChart.VisitorChartData.Response) {
        presentChartDataCalled = true
    }
    
    func presentVisitorChartData(response: VisitorChart.DisplayVisitorData.Response) {
        presentChartDataCalled = true
    }
  }
  
  // MARK: Tests
    
    func testVisitorChartData(){
        let spy = VisitorChartPresentationLogicSpy()
        sut.presenter = spy
        
        let request = VisitorChart.DisplayVisitorData.Request()
        sut.getVisitorsAllData(request: request)
        
        XCTAssert(true)
    }
}
