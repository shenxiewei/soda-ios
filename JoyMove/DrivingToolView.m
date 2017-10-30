//
//  DrivingToolView.m
//  JoyMove
//
//  Created by ethen on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "DrivingToolView.h"
#import "Macro.h"

@implementation DrivingToolView

const float drivingToolViewHeight = 50.f;
const float drivingToolViewAlpha = 1.f;

- (void)initUI {
    
    self.alpha = drivingToolViewAlpha;
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    
    NSArray *textArray = @[@"Unlock", @"Lock", @"Return", @"More"];
    NSArray *imageNameArray = @[@"drivingTool_unlock", @"drivingTool_lock", @"drivingTool_terminate", @"drivingTool_more"];
    NSArray *tagArray = @[@(CTVTagUnlock), @(CTVTagLock), @(CTVTagTerminate), @(CTVTagMore)];
    float buttonWidth = kScreenWidth/tagArray.count;
    
    for (NSInteger i=0; i<imageNameArray.count; i++) {
        
        NSString *imageName = imageNameArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, drivingToolViewHeight);
        button.tag = [tagArray[i] integerValue];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, buttonWidth, 15)];
        label.tag = 10;
        NSString *localStr = textArray[i];
        label.text = NSLocalizedString(localStr, nil);
        label.textColor = UIColorFromSixteenRGB(0x737373);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = UIFontFromSize(12);
        [button addSubview:label];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, .5f)];
    line.backgroundColor = UIColorFromRGB(220, 220, 220);
    [self addSubview:line];
}

//- (void)setStatus:(DrivingToolStatus)status {
//    
//    if (CTVTagUnlock==status) {
//        
//        UIButton *button = (UIButton *)[self viewWithTag:CTVTagLock];
//        UILabel *label = (UILabel *)[button viewWithTag:10];
//
//        [button setImage:[UIImage imageNamed:@"drivingTool_unlock"] forState:UIControlStateNormal];
//        button.tag = status;
//        label.text = @"开锁";
//    }else {
//        
//        UIButton *button = (UIButton *)[self viewWithTag:CTVTagUnlock];
//        UILabel *label = (UILabel *)[button viewWithTag:10];
//        
//        [button setImage:[UIImage imageNamed:@"drivingTool_lock"] forState:UIControlStateNormal];
//        button.tag = status;
//        label.text = @"锁车";
//    }
//}

+ (CGSize)size {
    
    return CGSizeMake(kScreenWidth, drivingToolViewHeight);
}

- (BOOL)isShow {
    
    return (drivingToolViewAlpha == self.alpha) ? YES : NO;
}

- (void)show {
    
    if (![self isShow]) {
        [UIView animateWithDuration:.4f animations:^{
            
            self.alpha = drivingToolViewAlpha;
            self.frame = CGRectMake(0, kScreenHeight-[DrivingToolView size].height, [DrivingToolView size].width, [DrivingToolView size].height);
        } completion:^(BOOL finished) {
            
            ;
        }];
    }
}

- (void)hide {
    
    if ([self isShow]) {
        [UIView animateWithDuration:.4f animations:^{
            
            self.alpha = 0;
            self.frame = CGRectMake(0, kScreenHeight, [DrivingToolView size].width, [DrivingToolView size].height);
        } completion:^(BOOL finished) {
            
            ;
        }];
    }
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedDrivingToolButtonAtIndex:)]) {
        
        [self.delegate clickedDrivingToolButtonAtIndex:button.tag];
    }
}

@end
