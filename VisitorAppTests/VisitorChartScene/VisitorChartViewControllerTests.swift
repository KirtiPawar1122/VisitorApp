

@testable import VisitorApp
import XCTest

class VisitorChartViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorChartViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupVisitorChartViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorChartViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "ChartViewController") as? VisitorChartViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class VisitorChartBusinessLogicSpy: VisitorChartBusinessLogic
  {
 
    var displayChartDataCalled = false
    func visitorsChartData(request: VisitorChart.VisitorChartData.Request) {
        displayChartDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testShouldGetDataWhenViewIsLoaded()
  {
    // Given
    let spy = VisitorChartBusinessLogicSpy()
    sut.chartInteractor = spy
    
    // When
    loadView()
    sut.getChartData()
    
    // Then
    XCTAssertTrue(spy.displayChartDataCalled, "viewDidLoad() should ask the interactor to do something")
  }
  
  func testForDisplayOverallVisitorData()
  {
    // Given
    let viewModel = VisitorChart.VisitorChartData.ViewModel(visitData: [])
    
    // When
    loadView()
    sut.displayChart(viewModel: viewModel)
    
    // Then
    //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
  }
}
