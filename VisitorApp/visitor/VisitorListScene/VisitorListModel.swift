//
//  VisitorListModel.swift
//  VisitorApp
//
//  Created by Mayur Kamthe on 08/10/20.
//  Copyright © 2020 Mayur Kamthe. All rights reserved.
//

import Foundation

enum VisitorList {
    
    enum fetchVisitorList{
        struct Request {
            
        }
        struct Response {
            var visit : [Visit]
        }
        struct ViewModel {
            var visit : [Visit]
        }
    }
}
