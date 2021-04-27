
@testable import VisitorApp
import XCTest

class VisitorFormViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: VisitorViewController!
  var window: UIWindow!
  var visitModel = Visit()
    let phoneNo = "8411912075"
    let email = "k@gmail.com"
    let visitorname = "Kirti"
    let companyName = "Wurth IT pvt ltd"
    let purpose = "Meeting"
    let visitingPerson = "HR"
   
    
  // MARK: - Test lifecycle
  
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
  
  // MARK: - Test setup
  
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
  
  // MARK: - Test doubles
  
  class VisitorFormBusinessLogicSpy: VisitorFormBusinessLogic
  {
    var fetchRecordCalled = false
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request) {
        fetchRecordCalled = true
    }
    func fetchVisitorsReccord(request: VisitorForm.fetchVisitorsRecord.Request) {
        fetchRecordCalled = true
    }
    var saveVisitorRecordCalled = false
    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request) {
        saveVisitorRecordCalled = true
        print(request)
    }
    func saveVisitorsRecord(request: VisitorForm.saveVisitorsRecord.Request) {
        saveVisitorRecordCalled = true
        print(request)
    }
  }
  
  // MARK: - Tests
    
  func testForFetchVisitorsData(){
    
    let spy = VisitorFormBusinessLogicSpy()
    sut.interactor = spy
    loadView()
    
    sut.fetchVisitorRecord(phoneNo: "8411912075")

    XCTAssert(spy.fetchRecordCalled, "record fetched Successfully")
    
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
   
  func testValidateData() -> Bool {
    
       let validateEmail = email.isValidEmail(mail: email)
       XCTAssertTrue(validateEmail, "Error in validate email")
    
       let validatePhone = phoneNo.isphoneValidate(phone: phoneNo)
       XCTAssertTrue(validatePhone, "Error in validat phone number")
    
       let validateName = !visitorname.isBlank
       XCTAssertTrue(validateName, "Error in validate name" )
       
       let validateCompany = !companyName.isBlank
       XCTAssertTrue(validateCompany,"Error in validate company Name")
       
       let validatePurpose = !purpose.isBlank
       XCTAssertTrue(validatePurpose,"Error in validate purpose")
      
       let validateVisitingPerson = !visitingPerson.isBlank
       XCTAssertTrue(validateVisitingPerson, "Error in validate visiting person name")

      return true
    }
    
    
    func testSaveData(){
        let visitData = VisitModel(date: Date(), company: companyName, purpose: purpose, contactPersonName: visitingPerson, profileVisitImage: "")
        let visitorData = VisitorModel(email: email, name: visitorname, phoneNo: phoneNo, profileImage: "", visitData: [visitData.dictionary],visits: [visitData])
        
        let spy = VisitorFormBusinessLogicSpy()
        sut.interactor = spy
        
        if testValidateData(){
            sut.saveVisitorsData(visitor: visitorData)
        }
        
        XCTAssert(spy.saveVisitorRecordCalled , "Record saved successfully")
    }
    
}

