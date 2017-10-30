//
//  SwiftTest.swift
//  JoyMove
//
//  Created by ethen on 16/8/2.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

import Foundation

class SwiftTest: NSObject {
    
    func test(a: String) -> String {
        
        return a+"..."
    }
    
    func request () {
        
        LXRequest.requestWithJsonDic(["1":"2"], andUrl: "http://baidu.com") { (success, response,  result) in
            
            
        }
    }
}