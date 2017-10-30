//
//  MobEventDefine.h
//  JoyMove
//
//  Created by Darker on 2017/10/24.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#ifndef MobEventDefine_h
#define MobEventDefine_h

#import "JSMobEvent.h"

#define SD_MOB_SEND(event,attrs)                       [JSMobEvent sendEvent:event attributes:attrs]
#define SD_BEGIN_LOGN(strs)                                  [JSMobEvent beginLogn:strs]
#define SD_END_LOGN(strs)                                  [JSMobEvent endLogn:strs]

//好评页分享次数
#define SD_MOB_EVENT_GOODEVEALUATESHARENU                          @"SD_MOB_EVENT_GOODEVEALUATESHARENU"
//课堂页面停留时间
#define SD_MOB_EVENT_CLASSSTOPTIME                                 @"SD_MOB_EVENT_CLASSSTOPTIME"
//任务也没停留时间
#define SD_MOB_EVENT_TASKSTOPTIME                                  @"SD_MOB_EVENT_TASKSTOPTIME"
//任务点击次数
#define SD_MOB_EVENT_TASKSTOPCLICKNU                               @"SD_MOB_EVENT_TASKSTOPCLICKNU"
//课堂按钮点击率
#define SD_MOB_EVENT_CLASSBUTCLICKNU                               @"SD_MOB_EVENT_CLASSBUTCLICKNU"


////课堂小白宝典的文章点击频率
//#define SD_MOB_EVENT_CLASSNOOBARTICLECLICKNU                                 @"SD_MOB_EVENT_CLASSNOOBARTICLECLICKNU"
////课堂小白宝典的文章转发次数
//#define SD_MOB_EVENT_CLASSNOOBARTICLETRANSMITNU                                @"SD_MOB_EVENT_CLASSNOOBARTICLETRANSMITNU"
////分享秘诀里面文章点击率
//#define SD_MOB_EVENT_SHARESECRETCLICKNU                                 @"SD_MOB_EVENT_SHARESECRETCLICKNU"
////分享秘诀里面文章转发次数
//#define SD_MOB_EVENT_SHARESECRETTRANSMITNU                                 @"SD_MOB_EVENT_SHARESECRETTRANSMITNU"
////费用垫付点击率
//#define SD_MOB_EVENT_COSTPAYMENTCLICKNU                                 @"SD_MOB_EVENT_COSTPAYMENTCLICKNU"
////费用垫付转发次数
//#define SD_MOB_EVENT_COSTPAYMENTTRANSMITNU                                 @"SD_MOB_EVENT_COSTPAYMENTTRANSMITNU"
////行车护法点击率
//#define SD_MOB_EVENT_DRIVEVEHICLECLICKNU                                 @"SD_MOB_EVENT_DRIVEVEHICLECLICKNU"
////行车护法转发次数
//#define SD_MOB_EVENT_DRIVEVEHICLETRANSMITNU                                 @"SD_MOB_EVENT_DRIVEVEHICLETRANSMITNU"
//
////赚钱币看点击率
//#define SD_MOB_EVENT_MAKEMONEYCLICKNU                                 @"SD_MOB_EVENT_MAKEMONEYCLICKNU"
////赚钱币看点击率
//#define SD_MOB_EVENT_MAKEMONEYTRANSMITNU                                 @"SD_MOB_EVENT_MAKEMONEYTRANSMITNU"
////赚钱币看停留时间
//#define SD_MOB_EVENT_MAKEMONEYSTOPTIME                                 @"SD_MOB_EVENT_MAKEMONEYSTOPTIME"
//
//
////苏打播报点击率
//#define SD_MOB_EVENT_SDBROADCASTCLICKNU                                 @"SD_MOB_EVENT_SDBROADCASTCLICKNU"
////苏打播报点击率
//#define SD_MOB_EVENT_SDBROADCASTCLICKNU                                 @"SD_MOB_EVENT_SDBROADCASTCLICKNU"

//最新活动
#define SD_MOB_EVENT_NEWACTIVITYCLICKNU                            @"SD_MOB_EVENT_NEWACTIVITYCLICKNU"
//邀请有礼点击次数
#define SD_MOB_EVENT_INVITECLICKNU                                 @"SD_MOB_EVENT_INVITECLICKNU"
//积分点击次数
#define SD_MOB_EVENT_INTEGRALCLICKNU                               @"SD_MOB_EVENT_INTEGRALCLICKNU"
//积分使用次数
#define SD_MOB_EVENT_INTEGRALUSENU                                 @"SD_MOB_EVENT_INTEGRALUSENU"
//分享次数
#define SD_MOB_EVENT_SHARESUCCESSNU                                @"SD_MOB_EVENT_SHARESUCCESSNU"
//分享按钮点击次数
#define SD_MOB_EVENT_SHARECLICJNU                                  @"SD_MOB_EVENT_SHARECLICJNU"
//广告图浏览时长
#define SD_MOB_EVENT_ANNIMAGETIME                                  @"SD_MOB_EVENT_ANNIMAGETIME"
//新手大红包点击次数
#define SD_MOB_EVENT_REDPACKETCLICKNU                              @"SD_MOB_EVENT_REDPACKETCLICKNU"
//分享赚钱点击次数
#define SD_MOB_EVENT_SHAREMONEYCLICKNU                             @"SD_MOB_EVENT_SHAREMONEYCLICKNU"


#endif /* MobEventDefine_h */
