//
//  CodeMacro.h
//  ResignView
//
//  Created by ethen on 15/2/9.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#ifndef JoyMove_CodeMacro_h
#define JoyMove_CodeMacro_h

typedef NS_ENUM(NSUInteger, JMErrorCode) {

    JMCodeWaitingResponse      = -1,            /**< 请求未返回  */
    JMCodeSuccess              = 10000,         /**< 请求成功    */
    JMCodeFail                 = 10001,         /**< 请求失败    */
    JMCodeNoData               = 10002,         /**< 请求成功,但无数据    */
    JMCodeNoCertification      = 10004,         /**< 请求成功,但用户没有通过全部认证    */
    JMCodeNoReady              = 10005,         /**< no ready车辆正在进入租用状态    */
    JMCodeReturnCarFailure     = 10006,         /**< 未能在指定地点还车，还车失败     */
    JMCodeInsufficientDeposit = 10008,             /**< 押金不足 */
    JMCodeHasBeenPaid          = 10010,         /**< 订单已支付,无需重复支付    */
    JMCodeLowVersion           = 15000,         /** 版本过低 */
    JMCodeNeedLogin            = 12000,         /** 重复登录 */
};

typedef NS_ENUM(NSUInteger, AlipayErrorCode) {
    
    AlipayCodePaySuccess           = 9000,         /**< 订单支付成功    */
    AlipayCodeDealing              = 8000,         /**< 正在处理中  */
    AlipayCodePayFail              = 4000,         /**< 订单支付失败    */
    AlipayCodeUserCancel           = 6001,         /**< 用户中途取消    */
    AlipayCodeFail                 = 6002,         /**< 网络连接错误    */
};

#define JMMessageNetworkError   @"网络异常，请稍候再试"
#define JMMessageNoErrMsg       @"未知错误，请稍候再试"

#endif
