//
//  ActivityView.m
//  JoyMove
//
//  Created by cty on 15/11/24.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "ActivityView.h"
#import "Macro.h"
#import "LXRequest.h"
#import "UIButton+WebCache.h"
#import "Tool.h"

@interface ActivityView ()
{
//    UIButton *_pushAcvitityButton;
    
}
@end

@implementation ActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UI

-(void)initUI
{
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0.5;
    [self addSubview:backgroundView];
    
    _pushAcvitityButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_pushAcvitityButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _pushAcvitityButton.frame=CGRectMake(36.0/320*kScreenWidth, (kScreenHeight-4.0/3*(kScreenWidth-72.0/320*kScreenWidth))/2.0, kScreenWidth-72.0/320*kScreenWidth, 4.0/3*(kScreenWidth-72.0/320*kScreenWidth));
    _pushAcvitityButton.backgroundColor=[UIColor clearColor];
    [self addSubview:_pushAcvitityButton];
    
    _backImage=[[UIImageView alloc]initWithFrame:CGRectMake(_pushAcvitityButton.frame.origin.x, _pushAcvitityButton.frame.origin.y, _pushAcvitityButton.frame.size.width, _pushAcvitityButton.frame.size.height)];
    _backImage.contentMode=UIViewContentModeScaleAspectFill;
    _backImage.layer.masksToBounds=YES;
    _backImage.backgroundColor=[UIColor clearColor];
    [self addSubview:_backImage];
    
    self.backgroundColor=[UIColor clearColor];
    
//    UIImageView *closeImage=[[UIImageView alloc]initWithFrame:CGRectMake(36.0/320*kScreenWidth+_pushAcvitityButton.frame.size.width-34, _pushAcvitityButton.frame.origin.y+10,24, 24)];
//    closeImage.image=[UIImage imageNamed:@"activityCloseImage"];
//    [self addSubview:closeImage];
    
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor=[UIColor clearColor];
    [closeButton setImage:[UIImage imageNamed:@"activityCloseImage"] forState:UIControlStateNormal];
    closeButton.imageEdgeInsets=UIEdgeInsetsMake(-10,0,0,-10);
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame=CGRectMake(36.0/320*kScreenWidth+_pushAcvitityButton.frame.size.width-50, _pushAcvitityButton.frame.origin.y, 50, 50);
    [self addSubview:closeButton];
}

-(void)updateUI
{
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
//    [self.pushAcvitityButton setBackgroundImageWithURL:[NSURL URLWithString:self.imageURL] forState:UIControlStateNormal];
}

#pragma mark - Action

-(void)buttonClick:(UIButton *)sender
{
    
    if (sender==_pushAcvitityButton)
    {
        if (self.pushActivityController)
        {
            self.pushActivityController();
        }
    }
    else
    {
        if (self.CloseActivityButtonClick)
        {
            self.CloseActivityButtonClick();
        }
    }
}

#pragma mark - Request

- (void)requestActivityImage:(NSString *)cityCode
{
//    self.uploadLabel.text = @"载入中...";
    self.hidden=YES;
    //天元测试
    NSDictionary *dic = @{@"cityCode":cityCode};
//    NSDictionary *dic = @{@"cityCode":@"020"};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlPushActivityView) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
     {
         if (success)
         {
             if (result==10000)
             {
                 self.hidden=YES;
                 self.imageURL=response[@"promotionTips"];
                 self.html5URL=response[@"promotionContent"];
                 self.detailsTitle=response[@"promotionName"];
                 if (self.imageURL.length>0 && self.html5URL.length>0 && self.detailsTitle.length>0)
                 {
                     [self initUI];
                     [self updateUI];
                     self.hidden=NO;
                 }
                 else
                 {
                     self.hidden=YES;
                 }
                
             }
             else
             {
                 self.hidden=YES;
             }
         }
         else if (result==12000)
         {
             if (self.pushLoginViewController)
             {
                 self.pushLoginViewController();
             }
         }
         else
         {
             self.hidden=YES;
//             [self performSelector:@selector(requestActivityImage) withObject:nil afterDelay:5];
         }
     }];
}



@end
