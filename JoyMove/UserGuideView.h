//
//  UserGuideView.h
//  JoyMove
//
//  Created by ethen on 15/7/15.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserGuideType) {
    
    UGTypeNotRent               = 100,    /**< 不能租用（未通过全部认证） */
    UGTypeAllCertification      = 101,    /**< 各种认证的介绍 */
};

@protocol UserGuideDelegate <NSObject>

- (void)userGuideButtonClicked;

@end

@interface UserGuideView : UIView

@property (assign, nonatomic) id<UserGuideDelegate> delegate;

- (void)initUIWithType:(UserGuideType)type;
- (void)show;
- (void)hide;

@end
