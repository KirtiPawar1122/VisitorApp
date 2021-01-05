//
//  VisitorPrintViewModel.swift
//  VisitorApp
//
//  Created by Mayur Kamthe on 20/11/20.
//  Copyright © 2020 Mayur Kamthe. All rights reserved.

import Foundation

enum VisitorPrint {

   enum VisitorPrintData {
    
      struct Request  {
        //var email: String?
        var phoneNo: String?
       }
    
       struct Response {
           var visitData: Visit?
       }
    
       struct ViewModel {
           var visitData: Visit?
        }
    }
}
