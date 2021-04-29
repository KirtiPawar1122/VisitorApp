
@testable import VisitorApp
import XCTest

class VisitorChartPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorChartPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupVisitorChartPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorChartPresenter()
  {
    sut = VisitorChartPresenter()
  }
  
  // MARK: Test doubles
  
  class VisitorChartDisplayLogicSpy: VisitorChartDisplayLogic
  {
   
    func displayPercenatageDataOnChart(viewModel: VisitorChart.FetchVisitorPurposeType.ViewModel) {
        print(viewModel)
    }
    
    var visit : [Visit] = []
    var displayChartDataCalled = false

    func displayChart(viewModel: VisitorChart.VisitorChartData.ViewModel) {
        displayChartDataCalled = true
    }
    
    func displayVisitorChartData(viewModel: VisitorChart.DisplayVisitorData.viewModel) {
        displayChartDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testPresentChartData()
  {
    // Given
    let spy = VisitorChartDisplayLogicSpy()
    sut.viewObj = spy
    let response = VisitorChart.DisplayVisitorData.Response(visitorData: [])
    // When
    //sut.prsentChartData(response: response)
    sut.presentVisitorChartData(response: response)
    
    // Then
    XCTAssertTrue(spy.displayChartDataCalled, "presentChartData(response:) should ask the view controller to display the result")
  }
}
