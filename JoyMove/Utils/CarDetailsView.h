//
//  CarDetailsView.h
//  JoyMove
//
//  Created by ethen on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIModel.h"
#import "POIDefine.h"

typedef NS_ENUM(NSInteger, CarDetailsViewTag) {
    
    CDVTagWalking = 100,    /**< 步行导航 */
    CDVTagUnlock,           /**< 租用 */
    CDVTagGo,               /**< 前往 */
    CDVTagRule,             /**< 计费规则 */
};

@protocol CarDetailsDelegate <NSObject>

- (void)clickedCarDetailsButtonAtIndex:(CarDetailsViewTag)tag;

@end


@interface CarDetailsView : UIView

@property (assign, nonatomic) id<CarDetailsDelegate> delegate;
@property (nonatomic, strong) POIModel *poiModel;
@property (assign, nonatomic) double distance;
// 是否为通话或链接热点状态
@property (assign, nonatomic) BOOL isMoreUp;

- (void)initUI;
- (void)updateUI;
+ (CGSize)size;
- (BOOL)isShow;
- (void)show;
- (void)hide;

@end
