//
//  ActivityModel.swift
//  JoyMove
//
//  Created by 赵霆 on 16/8/17.
//  Copyright © 2016年 ting.zhao. All rights reserved.
//

import Foundation

class ActivityModel: NSObject {
    
    var promotionName: String?
    var promotionTitle: String?
    var promotionContent: String?
    
    init(dict: [String: AnyObject]) {
        
        super.init()
        
        promotionName = dict["promotionName"] as? String
        promotionTitle = dict["promotionTitle"] as? String
        promotionContent = dict["promotionContent"] as? String
        
    }
}