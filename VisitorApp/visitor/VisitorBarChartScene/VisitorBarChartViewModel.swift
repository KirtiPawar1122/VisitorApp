//
//  VisitorBarChartViewModel.swift
//  VisitorApp
//
//  Created by Mayur Kamthe on 22/10/20.
//  Copyright © 2020 Mayur Kamthe. All rights reserved.


import Foundation

enum VisitorBarChart {
    
    enum VisitorBarChartData{
        
        struct Request {
            
        }
        
        struct Response {
            var visitData : [Visit]
        }
        
        struct ViewModel {
            var visitData : [Visit]
        }
    }
}

