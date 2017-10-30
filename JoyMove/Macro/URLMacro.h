//
//  URLMacro.h
//  ResignView
//
//  Created by ethen on 15/1/21.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#ifndef JoyMove_URLMacro_h
#define JoyMove_URLMacro_h

#define kURL(URL)           isRelease?kURLRelease(URL):kURLTest(URL)
#define kURLRelease(URL)    [NSString stringWithFormat:@"%@%@", kUrlPrefix, URL]
#define kURLTest(URL)       [NSString stringWithFormat:@"%@%@", kUrlPrefixTest, URL]

//#define kUrlPrefix          @"http://share.sodacar.com:8082/"  //生产环境URL
//#define kUrlPrefix            @"http://123.57.151.176:8082/"     //生产环境原来的URL
#define kUrlPrefix          @"https://sodacar.com:8083/"       //生产环境HTTPS

//#define kUrlPrefixTest        @"https://sodacar.com:8447/"     //测试环境https
//#define kUrlPrefixTest      @"http://192.168.88.85:8082/"      //测试环境URL
#define kUrlPrefixTest      @"http://123.56.234.31:8082/"       //吴旭测试环境URL  
//#define kUrlPrefixTest      @"http://123.56.126.171:8082/"     //中进环境URL

//E2E URL  
#define kE2EUrlYongHuXieYi      @"joymove/htm/yongHuXieYi.html"      //用户协议
#define kE2EUrlChangJianWenTi   @"joymove/htm/changJianWenTi.html"   //常见问题
#define kE2EUrlFaLvJieDu        @"joymove/htm/faLvJieDu.html"        //法律解读
#define kE2EUrlHuiYuanJiBie     @"joymove/htm/Pricing.html"          //会员级别管理
#define kE2EUrlJiFenShuoMing    @"joymove/htm/jiFenShuoMing.html"    //积分说明
#define kE2EUrlPingTaiGuiZe     @"joymove/htm/pingTaiGuiZe.html"     //平台规则
#define kE2EUrlWeiZhangChuLi    @"joymove/htm/weiZhangChuLi.html"    //违章处理
#define kE2EUrlYouHuiQuan       @"joymove/htm/youHuiQuan.html"       //优惠券说明
#define kE2EUrlYaJinShuoMing @"http://static.sodacar.com/yaJinShuoMing.html"
#define kkE2EUrlMyCarShuoMing @"" //我的车辆说明

#define kE2EUrlShiMingRenZheng  @"joymove/htm/shiMingRenZheng.html"  //实名认证

#define kE2EUrlGetNearByCluster         @"joymove/newcar/getNearByCluster.c"
#define kE2EUrlGetNearByAvailableCars   @"joymove/newcar/getNearByAvailableCars.c"  //显示附近(或全部)的车
#define kE2EUrlGetCarParkInfo @"joymove/newcar/getParkingInfo.c"
#define kE2EUrlUpdateParkInfo @"joymove/newcar/updateParkingInfo.c"
//#define kE2EUrlGetNearByBusyCars        @"joymove/newcar/getNearByBusyCars.c"
#define kE2EUrlGetCarDetailInfo         @"joymove/newcar/getCarDetailInfo.c"        //查看车辆信息
//#define kE2EUrlCreateReserveOrder       @"joymove/newcar/createReserveOrder.c"
//#define kE2EUrlCancelReserveOrder       @"joymove/newcar/cancelReserveOrder.c"
//#define kE2EUrlGetMyReservedCar         @"joymove/rent/getMyReservedCar.c"
#define kE2EUrlRentCarReq               @"joymove/newcar/rentCarReq.c"              //开始租车
#define kE2EUrlRentCarAck               @"joymove/newcar/rentCarAck.c"              //租车状态查询(心跳)
//#define kE2EUrlCheckOrderStatus         @"joymove/rent/checkOrderStatus.c"           //订单状态查询
#define kE2EUrlUpdateDestination        @"joymove/newcar/updateDestination.c"        //修改订单的目的地
#define kE2EUrlChangeBatonMode          @"joymove/newcar/changeBatonMode.c"          //修改订单接力棒模式
#define kE2EUrlBlow                     @"joymove/newcar/blow.c"                     //鸣笛提示
#define kE2EUrlVague                    @"joymove/newcar/vague.c"                    //闪灯提示
#define kE2EUrlGetCarLockState          @"joymove/newcar/getCarLockState.c"          //检查车门状态
//#define kE2EUrlRentCarTerminate         @"joymove/newcar/rentCarTerminate.c"
#define kE2EUrlRentCarTerminateCheck      @"joymove/newcar/rentCarTerminateCheck.c"      //还车检查围栏
#define kE2EUrlRentCarTerminateReq      @"joymove/newcar/rentCarTerminateReq.c"      //开始还车
#define kE2EUrlRentCarTerminateAck      @"joymove/newcar/rentCarTerminateAck.c"      //还车状态查询(心跳)
//#define kE2EUrlCancle                   @"joymove/tools/order/force/cancle.c"

//#define kUrlGetNearByAvailableCars      @"joymove/rent/getNearByAvailableCars.c"      /**< 获取周边的车 */
//#define kUrlGetNearByBusyCars           @"joymove/rent/getNearByBusyCars.c"           /**< 获取周边的幻影车 */
#define kUrlGetNearByPowerBars          @"joymove/rent/getNearByPowerBars.c"          /**< 获取周边的电桩 */
#define kUrlGetNearByParks              @"joymove/rent/getNearByParks.c"              /**< 获取周边的停车场 */
//#define kUrlPingCar                     @"joymove/rent/pingCar.c"                     /**< 鸣笛闪灯 */
#define kUrlLock                        @"joymove/newcar/lock.c"                      /**< 关锁 */
#define kUrlUnlock                      @"joymove/newcar/unlock.c"                    /**< 开锁 */
//#define kUrlCreateReserveOrder          @"joymove/reserve/createReserveOrder.c"       /**< 预订 */
//#define kUrlGetMyReservedCar            @"joymove/rent/getMyReservedCar.c"            /**< 预订查询 */
//#define kUrlCancelReserveOrder          @"joymove/reserve/cancelReserveOrder.c"       /**< 取消预订 */
//#define kUrlGetMyReservedCar            @"joymove/rent/getMyReservedCar.c"            /**< 查看预订 */
//#define kUrlRentCarReq                  @"joymove/rent/rentCarReq.c"                  /**< 租车 */
//#define kUrlRentCarAck                  @"joymove/rent/rentCarAck.c"                  /**< 租车状态查询(心跳) */
//#define kUrlTerminateMyOrder            @"joymove/rent/terminateMyOrder.c"            /**< 终止订单 */
#define kUrlCheckOrderStatus            @"joymove/rent/checkOrderStatus.c"            /**< 订单状态查询 */
//#define kUrlUpdateDestination           @"joymove/rent/updateDestination.c"           /**< 修改订单目的地 */
//#define kUrlChangeBatonMode             @"joymove/rent/changeBatonMode.c"             /**< 修改订单接力棒模式 */
#define kUrlGetOrderDetail              @"joymove/rent/getOrderDetail.c"              /**< 查询订单具体信息 */
#define kUrlPayOrderReq                 @"joymove/rent/payOrderReq.c"                 /**< 支付前确认 */

#define kUrlLogin                       @"joymove/usermgr/login.c"                    /**< 登录 */
#define kUrlDynamicPwsGen               @"joymove/usermgr/dynamicPwsGen.c"            /**< 获取验证码 */
#define kUrlRegister                    @"joymove/usermgr/register.c"                 /**< 注册 */
#define kUrlBaseInfo                    @"joymove/usermgr/viewBaseInfo.c"             /**< 基本信息 */
#define kUrlModifyPwd                   @"joymove/usermgr/updatePwd.c"                /**< 修改密码 */
#define kUrlUploadHeader                @"joymove/usermgr/updateIma.c"                /**< 上传头像 */
#define kUrlGetHeaderIcon               @"joymove/userImage/getIma.c?mobileNo=%@"     /**< 获取头像 */
#define kUrlModifyInfo                  @"joymove/usermgr/updateInfo.c"               /**< 修改信息 */
#define kUrlDriveLicense                @"joymove/usermgr/updateDriverAuthInfo.c"     /**< 驾照上传 */
#define kUrlCoupon                      @"joymove/usermgr/viewCoupon1.c"              /**< 优惠券 */
#define kUrlCredit                      @"joymove/usermgr/viewJifen.c"                /**< 积分 */
#define kUrlCheckMobileNo               @"joymove/usermgr/checkUserMobileNo.c"        /**< 检查手机号是否已经注册过 */
#define kUrlListHistoryOrder            @"joymove/ordermgr/listHistoryOrder.c"        /**< 订单历史 */
#define kUrlCheckUserState              @"joymove/usermgr/checkUserState.c"           /**< 4认证状态 */
//#define kUrlUpdateBioLogicalinfo        @"joymove/usermgr/updateBiologicalInfo.c"     /**< 修改生物特征注册状态 */
#define kUrlGetBioLogicalinfo           @"joymove/usermgr/getBioLogicalInfo.c"        /**< 获取生物特征注册状态 */

#define kUrlResetPwd                    @"joymove/usermgr/resetPwd.c"                 /**< 重置密码*/
#define kUrlGetCommonDestination        @"joymove/usermgr/getCommonDestination.c"     /**< 获取常用目的地 */
#define kUrlupdateCommonDestination     @"joymove/usermgr/updateCommonDestination.c"  /**< 更新常用目的地 */
#define kUrlToObtainMessage             @"joymove/toObtain/message.c"                 /**< 消息推送 */
#define kUrlDepositRecharge             @"joymove/usermgr/depositRecharge.c"          /**< 押金充值*/
#define kUrlRecommendRoute              @"joymove/rent/getInterestPOI.c"              /**< 推荐路线*/
#define kUrlIDCard                      @"joymove/usermgr/updateIdAuthInfo.c"         /**< 实名认证*/
#define kUrlExchangeCoupon              @"joymove/seed/exchangeCoupon.c"              /**< 添加优惠券*/
#define kUrlOCR                         @"joymove/usermgr/idOCR.c"                    /**< OCR */
#define kUrlCreditCard                  @"joymove/creditcard/binding.c"               /**< 信用卡绑定>*/

#define kUrlShareImage                  @"joymove/pic/getPosters.c"                   /**< 分享的海报图片>*/
#define kUrlInviteCode                  @"joymove/usermgr/getInvitationCode.c"        /**< 邀请码>*/

#define kUrlActivity                    @"joymove/promotion/getPromotions.c"          /** 活动列表信息 */
#define kUrlPushActivityView            @"joymove/promotion/getTipsPromotion.c"       /** 获取弹出活动信息 */
#define kUrlCarIcon                     @"joymove/icon/load.c"                        /** 动态获取carIcon */
#define KUrlGetGuidePage                @"joymove/newcar/getGuidePage.c"              /** 动态获取租车成功的引导页 */

#define kUrlPonusPoint                  @"joymove/bonusPoint/view.c"                  /** 积分数字 */
#define KUrlConvertibleGoods            @"joymove/bonusPoint/viewGoods.c"             /**<获取可兑换商品>**/
#define KUrlPoints                      @"joymove/bonusPoint/exchange.c"              /**<积分兑换商品>**/
#define KUrlAccessConfiguration         @"joymove/config/getSysConfigs.c"             /**<获取启动页，车辆配置页，版本号>**/
#define KUrlPushWebsite                 @"joymove/station/build.c"                    /**<催我建站>**/

#define KUrlUserFeeling                 @"joymove/felling.c"                           /**<评论信息上传>**/
#define KUrlUserFeelingLabels           @"joymove/felling/labels.c"                    /**<评论标签获取>**/

#define KUrlInvoiceList                 @"joymove/invoice/order/list.c"                /**<可开具发票的订单>**/
#define KUrlIssuedInvoicing             @"joymove/invoice/apply.c"                     //申请开据发票
#define KUrlInvoiceHistory              @"joymove/invoice/history.c"                   /**<发票历史>**/
#define KUrlUserRank                    @"joymove/usermgr/rank.c"                      /**<用户排行榜>**/
#define KUrlFence                       @"joymove/fence/list.c"                        /**行驶区域**/

#define KUrlWeChatLogin                 @"joymove/usermgr/login/wechat.c"                      /**微信登陆**/

/***********包月套餐**************/
#define kUrlBannerImage @"http://static.sodacar.com/package/banner.jpeg"
#define kUrlRetalPackageHtml @"http://static.sodacar.com/package/main.html"
#define kUrlShareCarHtml @"http://static.sodacar.com/package/share.html"
#define kUrlRetalPackageUseHelpHtml @"http://static.sodacar.com/package/help.html"
#define kUrlRentalPackageCheck @"joymove/rentalPackage/find.c"   /**当前存在套餐查询**/
#define kUrlUserPackageCheck @"joymove/userPackage/find.c"   /**查询当前用户套餐**/
#define kUrlShareSetting @"joymove/userPackage/setShare.c"   /**分享设置**/
#define kUrlPurchasePackage @"joymove/userPackage/buy.c"     /**购买或者续订套餐**/
#define kUrlAccountCheck @"joymove/account/view.c"      /**余额查询**/
#define kUrlPayPackage @"joymove/userPackage/buy.c"   /**购买、续费套餐**/
#define kUrlBalanceDetail @"joymove/account/detail.c"      /**余额详情**/

#define kUrlAllMission @"joymove/userTask/find.c"     /**所有任务**/
#define kUrlRewardHistory @"joymove/userTask/awardHistory.c"   /**获奖历史**/
#define kUrlCompleteTask @"joymove//userTask/complete.c"    /**完成任务**/
#define kUrlGetReward @"joymove/userTask/award.c"    /**领取奖励**/




/**********押金*************/
#define KUrlDepositStatus @"joymove/deposit/view.c"   /**押金状态**/
#define kUrlRealDepositReCharge @"joymove/deposit/recharge.c" /**押金充值**/
#define kUrlDepositDetail @"joymove/deposit/detail.c"  /**押金明细**/
#define kUrlRefund @"joymove/deposit/refund.c"  /**押金退款**/
#define kUrlRefundRecords @"joymove/deposit/refundRecords.c"  /**押金退款状态**/


/************包月活动*************/
#define kUrlMonthRentInstruction @""
#endif
