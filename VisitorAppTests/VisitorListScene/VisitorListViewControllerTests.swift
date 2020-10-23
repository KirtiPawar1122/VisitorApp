

@testable import VisitorApp
import XCTest

class VisitorListViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorListViewController!
  var window: UIWindow!

  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupVisitorListViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorListViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "VisitorDataViewController") as? VisitorListViewController

  }

  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class VisitorListBusinessLogicSpy: VisitorListBusinessLogic
  {
    var visits : [Visit]?
    var fetchDataCalled = false
    func fetchVisitorData(request: VisitorList.fetchVisitorList.Request) {
        fetchDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testShouldFetchListWhenViewIsLoaded()
  {
    let spy = VisitorListBusinessLogicSpy()
    sut.listInteractor = spy
    loadView()
    sut.fetchVisitorList()
    
    XCTAssertTrue(spy.fetchDataCalled, "request from viewcontroller is called after viewWillAppear")
  }
  
  func testDisplaySomething()
  {
    // Given
    let viewModel = VisitorList.fetchVisitorList.ViewModel(visit: [])
    
    // When
    loadView()
    sut.displayVisitorList(viewModel: viewModel)
    
    // Then
    //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
  }
}
