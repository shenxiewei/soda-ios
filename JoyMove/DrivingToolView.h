//
//  DrivingToolView.h
//  JoyMove
//
//  Created by ethen on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrivingToolViewTag) {
    
    CTVTagLock = 100,       /**< 锁车 */
    CTVTagUnlock,           /**< 开锁 */
    CTVTagTerminate,        /**< 还车 */
    CTVTagNavigation,       /**< 导航 */
    CTVTagMore,             /**< 更多 */
};

typedef NS_ENUM(NSInteger, DrivingToolStatus) {
    
    DrivingToolStatusLock = 100,       /**< 锁车 */
    DrivingToolStatusUnlock,           /**< 开锁 */
};

@protocol DrivingToolViewDelegate <NSObject>

- (void)clickedDrivingToolButtonAtIndex:(DrivingToolViewTag)tag;

@end

@interface DrivingToolView : UIView

@property (assign, nonatomic) id<DrivingToolViewDelegate> delegate;

- (void)initUI;
//- (void)setStatus:(DrivingToolStatus)status;
+ (CGSize)size;
- (BOOL)isShow;
- (void)show;
- (void)hide;

@end
