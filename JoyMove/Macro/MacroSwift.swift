//
//  MacroSwift.swift
//  JoyMove
//
//  Created by 赵霆 on 16/8/15.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

import Foundation

/// URL
func KURL(_ URL: String) -> String{
    
    return isRelease.boolValue ? kURLRelease(URL) : kURLTest(URL)
}

private func kURLRelease(_ URL: String) -> String{
    
    return "https://sodacar.com:8083/" + URL
}

private func kURLTest(_ URL: String) -> String{
    
    return "http://123.56.234.31:8082/" + URL
}

let kE2EUrlYongHuXieYi            = "joymove/htm/yongHuXieYi.html"      //用户协议
let kE2EUrlChangJianWenTi         = "joymove/htm/changJianWenTi.html"   //常见问题
let kE2EUrlFaLvJieDu              = "joymove/htm/faLvJieDu.html"        //法律解读
let kE2EUrlHuiYuanJiBie           = "joymove/htm/Pricing.html"          //会员级别管理
let kE2EUrlJiFenShuoMing          = "joymove/htm/jiFenShuoMing.html"    //积分说明
let kE2EUrlPingTaiGuiZe           = "joymove/htm/pingTaiGuiZe.html"     //平台规则
let kE2EUrlWeiZhangChuLi          = "joymove/htm/weiZhangChuLi.html"    //违章处理
let kE2EUrlYouHuiQuan             = "joymove/htm/youHuiQuan.html"       //优惠券说明

let kE2EUrlShiMingRenZheng        = "joymove/htm/shiMingRenZheng.html"  //实名认证

let kE2EUrlGetNearByCluster       = "joymove/newcar/getNearByCluster.c"
let kE2EUrlGetNearByAvailableCars = "joymove/newcar/getNearByAvailableCars.c"  //显示附近(或全部)的车
let kE2EUrlGetCarDetailInfo       = "joymove/newcar/getCarDetailInfo.c"        //查看车辆信息
let kE2EUrlRentCarReq             = "joymove/newcar/rentCarReq.c"              //开始租车
let kE2EUrlRentCarAck             = "joymove/newcar/rentCarAck.c"              //租车状态查询(心跳)
let kE2EUrlUpdateDestination      = "joymove/newcar/updateDestination.c"        //修改订单的目的地
let kE2EUrlChangeBatonMode        = "joymove/newcar/changeBatonMode.c"          //修改订单接力棒模式
let kE2EUrlBlow                   = "joymove/newcar/blow.c"                     //鸣笛提示
let kE2EUrlVague                  = "joymove/newcar/vague.c"                    //闪灯提示
let kE2EUrlGetCarLockState        = "joymove/newcar/getCarLockState.c"          //检查车门状态
let kE2EUrlRentCarTerminateReq    = "joymove/newcar/rentCarTerminateReq.c"      //开始还车
let kE2EUrlRentCarTerminateAck    = "joymove/newcar/rentCarTerminateAck.c"      //还车状态查询(心跳)
let kUrlGetNearByPowerBars        = "joymove/rent/getNearByPowerBars.c"          /**< 获取周边的电桩 */
let kUrlGetNearByParks            = "joymove/rent/getNearByParks.c"              /**< 获取周边的停车场 */
let kUrlLock                      = "joymove/newcar/lock.c"                      /**< 关锁 */
let kUrlUnlock                    = "joymove/newcar/unlock.c"                    /**< 开锁 */
let kUrlCheckOrderStatus          = "joymove/rent/checkOrderStatus.c"            /**< 订单状态查询 */
let kUrlGetOrderDetail            = "joymove/rent/getOrderDetail.c"              /**< 查询订单具体信息 */
let kUrlPayOrderReq               = "joymove/rent/payOrderReq.c"                 /**< 支付前确认 */

let kUrlLogin                     = "joymove/usermgr/login.c"                    /**< 登录 */
let kUrlDynamicPwsGen             = "joymove/usermgr/dynamicPwsGen.c"            /**< 获取验证码 */
let kUrlRegister                  = "joymove/usermgr/register.c"                 /**< 注册 */
let kUrlBaseInfo                  = "joymove/usermgr/viewBaseInfo.c"             /**< 基本信息 */
let kUrlModifyPwd                 = "joymove/usermgr/updatePwd.c"                /**< 修改密码 */
let kUrlUploadHeader              = "joymove/usermgr/updateIma.c"                /**< 上传头像 */
let kUrlGetHeaderIcon             = "joymove/userImage/getIma.c?mobileNo=%"     /**< 获取头像 */
let kUrlModifyInfo                = "joymove/usermgr/updateInfo.c"               /**< 修改信息 */
let kUrlDriveLicense              = "joymove/usermgr/updateDriverAuthInfo.c"     /**< 驾照上传 */
let kUrlCoupon                    = "joymove/usermgr/viewCoupon1.c"              /**< 优惠券 */
let kUrlCredit                    = "joymove/usermgr/viewJifen.c"                /**< 积分 */
let kUrlCheckMobileNo             = "joymove/usermgr/checkUserMobileNo.c"        /**< 检查手机号是否已经注册过 */
let kUrlListHistoryOrder          = "joymove/ordermgr/listHistoryOrder.c"        /**< 订单历史 */
let kUrlCheckUserState            = "joymove/usermgr/checkUserState.c"           /**< 4认证状态 */
let kUrlGetBioLogicalinfo         = "joymove/usermgr/getBioLogicalInfo.c"        /**< 获取生物特征注册状态 */

let kUrlResetPwd                  = "joymove/usermgr/resetPwd.c"                 /**< 重置密码*/
let kUrlGetCommonDestination      = "joymove/usermgr/getCommonDestination.c"     /**< 获取常用目的地 */
let kUrlupdateCommonDestination   = "joymove/usermgr/updateCommonDestination.c"  /**< 更新常用目的地 */
let kUrlToObtainMessage           = "joymove/toObtain/message.c"                 /**< 消息推送 */
let kUrlDepositRecharge           = "joymove/usermgr/depositRecharge.c"          /**< 押金充值*/
let kUrlRecommendRoute            = "joymove/rent/getInterestPOI.c"              /**< 推荐路线*/
let kUrlIDCard                    = "joymove/usermgr/updateIdAuthInfo.c"         /**< 实名认证*/
let kUrlExchangeCoupon            = "joymove/seed/exchangeCoupon.c"              /**< 添加优惠券*/
let kUrlOCR                       = "joymove/usermgr/idOCR.c"                    /**< OCR */
let kUrlCreditCard                = "joymove/creditcard/binding.c"               /**< 信用卡绑定>*/

let kUrlShareImage                = "joymove/pic/getPosters.c"                   /**< 分享的海报图片>*/
let kUrlInviteCode                = "joymove/usermgr/getInvitationCode.c"        /**< 邀请码>*/

let kUrlActivity                  = "joymove/promotion/getPromotions.c"          /** 活动列表信息 */
let kUrlPushActivityView          = "joymove/promotion/getTipsPromotion.c"       /** 获取弹出活动信息 */
let kUrlCarIcon                   = "joymove/icon/load.c"                        /** 动态获取carIcon */
let KUrlGetGuidePage              = "joymove/newcar/getGuidePage.c"              /** 动态获取租车成功的引导页 */

let kUrlPonusPoint                = "joymove/bonusPoint/view.c"                  /** 积分数字 */
let KUrlConvertibleGoods          = "joymove/bonusPoint/viewGoods.c"             /**<获取可兑换商品>**/
let KUrlPoints                    = "joymove/bonusPoint/exchange.c"              /**<积分兑换商品>**/
let KUrlAccessConfiguration       = "joymove/config/getSysConfigs.c"             /**<获取启动页，车辆配置页，版本号>**/
let KUrlPushWebsite               = "joymove/station/build.c"                    /**<催我建站>**/

let KUrlUserFeeling               = "joymove/felling.c"                           /**<评论信息上传>**/
let KUrlUserFeelingLabels         = "joymove/felling/labels.c"                    /**<评论标签获取>**/

let KUrlInvoiceList               = "joymove/invoice/order/list.c"                /**<可开具发票的订单>**/
let KUrlIssuedInvoicing           = "joymove/invoice/apply.c"                     //申请开据发票
let KUrlInvoiceHistory            = "joymove/invoice/history.c"                   /**<发票历史>**/
let KUrlUserRank                  = "joymove/usermgr/rank.c"                      /**<用户排行榜>**/
let KUrlFence                     = "joymove/fence/list.c"                        /**行驶区域**/

let KUrlWeChatBinding             = "joymove/usermgr/wechat/binding.c"            //微信绑定电话

// MARK: - 全局常用属性
let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let ScreenBounds: CGRect = UIScreen.main.bounds

/// RGBA的颜色设置
func ColorWithRGB(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}




