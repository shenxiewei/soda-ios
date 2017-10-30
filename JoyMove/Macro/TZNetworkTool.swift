//
//  TZNetworkTool.swift
//  JoyMove
//
//  Created by 赵霆 on 16/8/18.
//  Copyright © 2016年 ting.zhao. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class TZNetworkTool: NSObject {
    // 单例
    static let shareNetworkTool = TZNetworkTool()
    
    // 活动列表
    func loadActivityData( _ finished:@escaping (_ activityItems: [ActivityModel]) -> () ) {
        
        var cityCode = Tool.getCache("firstLocalCityCode") as! String
        if cityCode.isEmpty {
            cityCode = ""
        }
        
        let params: Parameters = ["mobileNo" : UserData.share().mobileNo,
                      "authToken": UserData.share().authToken,
                      "cityCode" : cityCode]
        
        Alamofire
            .request( KURL(kUrlActivity), method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) in
            
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: NSLocalizedString("加载失败...", comment: ""))
                return
            }

                if let value = response.result.value {
                
                let dict = JSON(value)
                let code = dict["result"].intValue
                let message = dict["errMsg"].stringValue
                guard code == 10000 else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                //  字典转成模型
                if let items = dict["promotions"].arrayObject {
                    var activityItems = [ActivityModel]()
                    for item in items {
                        let activityItem = ActivityModel(dict: item as! [String: AnyObject])
                        activityItems.append(activityItem)
                    }
                    
                    finished(activityItems)
                }
            }
            
        })

    }
    
    // 获取验证码
    func getVerificationCode(mobileNo: String, finished:@escaping (_ results: Bool) -> ()) {
        
        let params: Parameters = ["mobileNo" : mobileNo]
        
        Alamofire
            .request(KURL(kUrlDynamicPwsGen), method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: NSLocalizedString("发送失败...", comment: ""))
                    return
                }
                if let value = response.result.value {
                    
                    let dict = JSON(value)
                    let code = dict["result"].intValue
                    let message = dict["errMsg"].stringValue
                    
                    guard code == 10000 else {
                        SVProgressHUD.showInfo(withStatus: message)
                        finished(false)
                        return
                    }
                    SVProgressHUD.showSuccess(withStatus: NSLocalizedString("验证码已发送...", comment: ""))
                    finished(true)
                }
        }
    }
    
    // 微信绑定手机号
    func mobileNoBindindToWeChat(mobile: String, sessionId: String,deviceId: String, seccode: String, finished:@escaping (_ results: Bool, _ code:Int) -> ()) {
        
        let params: Parameters = ["mobile" : mobile,
                                  "sessionId": sessionId,
                                  "deviceId":deviceId,
                                  "seccode" : seccode]
        
        Alamofire
            .request(KURL(KUrlWeChatBinding), method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: NSLocalizedString("绑定失败...", comment: ""))
                    return
                }
                if let value = response.result.value {
                    
                    let dict = JSON(value)
                    let code = dict["result"].intValue
                    let message = dict["errMsg"].stringValue
                    
                    guard code == 10014 else {
                        finished(false,10014)
                        return
                    }
                    
                    let mobile = dict["mobile"].stringValue
                    let authToken = dict["mobile"].stringValue
                    
                    UserData.share().mobileNo = mobile
                    UserData.share().authToken = authToken
                    UserData.savaData()
                    MiPushSDK.setAccount(UserData.share().mobileNo)
                    
                    guard code == 10000 else {
                        SVProgressHUD.showInfo(withStatus: message)
                        finished(false,code)
                        return
                    }
                    SVProgressHUD.showSuccess(withStatus: NSLocalizedString("绑定成功", comment: ""))
                    finished(true,code)
                }
        }
    }
    
    
    
    
    
    
}
