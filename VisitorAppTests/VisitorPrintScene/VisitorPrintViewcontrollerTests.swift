//
//  VisitorPrintViewcontrollerTests.swift
//  VisitorAppTests
//
//  Created by Mayur Kamthe on 29/01/21.
//  Copyright © 2021 Mayur Kamthe. All rights reserved.
//

@testable import VisitorApp
import XCTest

class VisitorPrintViewcontrollerTests: XCTestCase {
    
     var sut: VisitorPrintViewController!
     var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupVisitorBarPrintViewController()
    }

    override func tearDown() {
        super.tearDown()
        window = UIWindow()
       
    }

    func setupVisitorBarPrintViewController()
     {
       let bundle = Bundle.main
       let storyboard = UIStoryboard(name: "Main", bundle: bundle)
       sut = storyboard.instantiateViewController(withIdentifier: "VisitorPrintViewController") as? VisitorPrintViewController
     }
    
    
    class VisitorPrintBusinessLogicSpy: VisitorPrintBusinessLogic
    {
        var visitorPrintData = false
        func fetchVisitorPrintData(request: VisitorPrint.VisitorPrintData.Request) {
            visitorPrintData = true
        }
    }
    
    func testShouldGetVisitorDataWhenViewIsLoaded(){
        let spy = VisitorPrintBusinessLogicSpy()
        sut.printInteractor = spy
    
        sut.getPrintData()
        
        XCTAssert(spy.visitorPrintData, "Data fetched successfully")
        
    }
}
