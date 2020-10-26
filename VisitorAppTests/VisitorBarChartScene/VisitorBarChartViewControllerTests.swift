
@testable import VisitorApp
import XCTest

class VisitorBarChartViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorBarChartViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupVisitorBarChartViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorBarChartViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "VisitorChartViewController") as? VisitorBarChartViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class VisitorBarChartBusinessLogicSpy: VisitorBarChartBusinessLogic
  {
   
    var displayDataCalled = false
    
    func visitorBarChartData(request: VisitorBarChart.VisitorBarChartData.Request) {
        displayDataCalled = true
    }
       
  }
  
  // MARK: Tests
  func testShouldGetVistorDataWhenViewIsLoaded()
  {
    // Given
    let spy = VisitorBarChartBusinessLogicSpy()
    sut.barChartInteractor = spy
    
    // When
    loadView()
    sut.getBarChartData()
    
    // Then
    XCTAssertTrue(spy.displayDataCalled, "viewDidLoad() should ask the interactor to do something")
  }
  
  func testForDisplayVisitorDataOnBarChart()
  {
    // Given
    let viewModel = VisitorBarChart.VisitorBarChartData.ViewModel(visitData: [])
    
    // When
    loadView()
    sut.displayVisitorBarChartData(viewModel: viewModel)
    
    // Then
    //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
  }
}
