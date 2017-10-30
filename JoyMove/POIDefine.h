//
//  POIDefine.h
//  JoyMove
//
//  Created by ethen on 15/3/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#ifndef JoyMove_POIDefine_h
#define JoyMove_POIDefine_h

typedef NS_ENUM(NSInteger, POIType) {
    
    POITypeCar = 100,       /**< 空闲的车 */
    POITypeParks,           /**< 停车场 */
    POITypePowerBars,       /**< 充电桩 */
    POITypeStop,            /**< 导航的途径点和终点 */
    POITypeMe,              /**< 用户当前位置 */
    POITypeGroup,           /**< 分组 */
    POITypeDriving,         /**< 驾驶中的车 */
};

const float ackHeartbeatDelay               = 3.f;      //ack心跳的间隔
const float poiHeartbeatDelay               = 60.f;     //update cars心跳的间隔
const float poiFocusHeartbeatDelay          = 120.f;    //update cars心跳的间隔(选中某个poi时)

#endif
