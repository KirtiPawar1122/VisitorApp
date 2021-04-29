

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
    func fetchVisitorDataWithLimit(fetchOffset: Int, request: VisitorList.fetchVisitorList.Request) {
        print(fetchOffset)
    }
    
    func fetchVisitorsListByName(request: VisitorList.fetchVisitorRecordByName.Request) {
        print(request)
    }
    
    func fetchVisitorsListByNameNNN() {
   
    }
    
    var visits : [Visit]?
    var fetchDataCalled = false
    func fetchVisitorData(request: VisitorList.fetchVisitorList.Request) {
        fetchDataCalled = true
        //print(request)
    }
    
    var visitorData = [DisplayData]()
    func fetchVisitorList(request: VisitorList.fetchAllVisitorsList.Request) {
        fetchDataCalled = true
    }
  }

    class VisitorTableViewSpy : UITableView{
        var reloadDataCalled = false
        override func reloadData() {
            reloadDataCalled = true
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
  
  func testDisplayFetchedData()
  {
    // Given
    let tableviewSpy = VisitorTableViewSpy()
    sut.tableview = tableviewSpy

    let viewModel = VisitorList.fetchVisitorList.ViewModel(visit: [])
    
    // When
    loadView()
    sut.displayVisitorList(viewModel: viewModel)
    
    // Then
    //XCTAssert(tableviewSpy.reloadDataCalled, "Displaying fecthed results in visitors table")
  }
}
