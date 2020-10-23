
@testable import VisitorApp
import XCTest

class VisitorFormViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupVisitorFormViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupVisitorFormViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "VisitorViewController") as? VisitorViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class VisitorFormBusinessLogicSpy: VisitorFormBusinessLogic
  {
   
    var fetchRecordCalled = false
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request) {
        fetchRecordCalled = true
    }
    
    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request) {
        fetchRecordCalled = true
        print(request)
    }
  }
  
  // MARK: Tests
    
  func testForFetchVisitorsData(){
    
    let spy = VisitorFormBusinessLogicSpy()
    sut.interactor = spy
    loadView()
    sut.fetchData()
    
    XCTAssert(spy.fetchRecordCalled,"record fetched successfully")
    
  }
  
  func testForDisplayVisitorRecord()
  {
    // Given
    
   // let viewModel = VisitorForm.fetchVisitorRecord.ViewModel(visit: v)
    // When
   // loadView()
  //  sut.displayVisitorData(viewModel: viewModel)
  //  print(viewModel)
    
   // Then
   // XCTAssert(true)
    //XCTAssertEqual(sut.emailTextField.text, "k@gmail.com", "display email in emailtextfeild")
  }
}
