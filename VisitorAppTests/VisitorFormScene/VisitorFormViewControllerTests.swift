
@testable import VisitorApp
import XCTest

class VisitorFormViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorViewController!
  var window: UIWindow!
  var visitModel = Visit()
  
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
    
    sut.loadViewIfNeeded()
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
    
    var saveVisitorRecordCalled = false
    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request) {
        saveVisitorRecordCalled = true
        print(request)
    }
  }
  
  // MARK: Tests
    
  func testForFetchVisitorsData(){
    
    let spy = VisitorFormBusinessLogicSpy()
    sut.interactor = spy
    loadView()
    sut.fetchData(email: "k@ggmail.com", phoneNo: "8411912075")
    
    XCTAssert(spy.fetchRecordCalled,"record fetched successfully")
    
  }
    
  func testEmailIdTextfield_properties() throws {
        let emailTextfield = try XCTUnwrap(sut.emailTextField, "Email address textfeild is not connected")
        XCTAssertEqual(emailTextfield.keyboardType, UIKeyboardType.emailAddress, "email address key pad is not set")
        XCTAssertEqual(emailTextfield.textContentType, UITextContentType.emailAddress, "Email address content type is not set")
  }
    
  func testPhoneTextFeild_KeyoardType() throws {
        let phoneTextfeild = try XCTUnwrap(sut.phoneTextField, "phone textfield is not connected")
        XCTAssertEqual(phoneTextfeild.keyboardType, UIKeyboardType.numberPad, "number keypad is not set" )
  }
   
  func testValidateData(){
    
       let phoneNo = "8411912075"
       let email = "k@gmail.com"
       let name = "Kirti"
       let companyName = "Wurth IT pvt ltd"
       let purpose = "Meeting"
       let visitingPerson = "HR"
        
    
       let valdiateEmail = email.isValidEmail(mail: email)
       XCTAssertTrue(valdiateEmail, "Error in validate email")
       //XCTAssert(valdiateEmail, "validate Email")
    
       let validatePhone = phoneNo.isphoneValidate(phone: phoneNo)
       XCTAssertTrue(validatePhone, "Error in validat phone number")
    
       let validateName = !name.isEmpty
       XCTAssertTrue(validateName, "Error in validate name" )
       
       let validateCompany = !companyName.isEmpty
       XCTAssertTrue(validateCompany,"Error in validate company Name")
       
       let validatepurpose = !purpose.isEmpty
       XCTAssertTrue(validatepurpose,"Error in validate purpose")
      
       let validateVisitingPerson = !visitingPerson.isEmpty
       XCTAssertTrue(validateVisitingPerson, "Error in validate visiting person name")
    
    
      let spy = VisitorFormBusinessLogicSpy()
      sut.interactor = spy
    
      loadView()
      sut.saveVisitorData(request: VisitorForm.saveVisitorRecord.Request(name: name, email: email, phoneNo: phoneNo, visitPurpose: purpose, visitingName: visitingPerson, companyName: companyName, profileImage: Data(), currentDate: Date()))
    
      XCTAssert(spy.saveVisitorRecordCalled, "record Saved Successfully")

    }
    
  func testForDisplayVisitorRecord()
  {
    // Given
    // let viewModel = VisitorForm.fetchVisitorRecord.ViewModel(visit: visitModel)
    // When
    // loadView()
    // sut.displayVisitorData(viewModel: viewModel)
    // print(viewModel)
    
    // Then
    // XCTAssert(true)
    // XCTAssertEqual(sut.emailTextField.text, "k@gmail.com", "display email in emailtextfeild")
  }
}
