//
//  TimeLineView.m
//  TimeLine
//
//  Created by Soda on 2017/3/14.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import "TimeLineView.h"


#define kTLDefaultHeight 80.0

@interface  TimeLineView()


@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UIScrollView *scrollContainer;
@property(nonatomic, strong) UIView *timeViewContainer;
@property(nonatomic, strong) UIView *progressDescriptionViewContainer;

@end

@implementation TimeLineView

- (UIScrollView *)scrollContainer
{
    if (!_scrollContainer) {
        _scrollContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width,self.frame.size.height)];
        [self addSubview:_scrollContainer];
    }
    return _scrollContainer;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        //进度条的创建
        _progressView =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.layer.anchorPoint = CGPointMake(0.0, 0.5);
        _progressView.frame=CGRectMake(9.0, 20, 300, 20);
        _progressView.progressTintColor=[UIColor colorWithRed:226.0/255.0 green:123.0/255.0 blue:105.0/255.0 alpha:1.0];
        _progressView.trackTintColor =[UIColor grayColor];
        _progressView.progress= 1.0;
        //_progressView.transform =  CGAffineTransformMakeRotation(90*M_PI/180);
        [self.scrollContainer addSubview:_progressView];
    }
    return _progressView;
}

- (id)initWithStatusArray:(NSArray *)status DescriptionArray:(NSArray *)descriptions TimeArray:(NSArray *)times Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *defaultColor =  [UIColor colorWithRed:226.0/255.0 green:123.0/255.0 blue:105.0/255.0 alpha:1.0];
        float offY = 20.0;
        float totalProgrssHeight = 0.0;
        for (int i = 0; i < status.count; i++) {
            //圆点
            CAShapeLayer *solidLine =  [CAShapeLayer layer];
            CGMutablePathRef solidPath =  CGPathCreateMutable();
            solidLine.lineWidth = 2.0f ;
            solidLine.strokeColor = defaultColor.CGColor;
            solidLine.fillColor = defaultColor.CGColor;
            CGPathAddEllipseInRect(solidPath, nil, CGRectMake(7.0, offY, 4.0f, 4.0));
            solidLine.path = solidPath;
            CGPathRelease(solidPath);
            [self.scrollContainer.layer addSublayer:solidLine];
            
            //状态 文字
            UILabel *statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(40.0, offY-4.0, 180.0, 0.0)];
            statusLbl.font = [UIFont systemFontOfSize:13.0];
            statusLbl.text = status[i];
            statusLbl.numberOfLines = 0;
            statusLbl.backgroundColor = [UIColor clearColor];
            statusLbl.textColor = [UIColor colorWithRed:226.0/255.0 green:123.0/255.0 blue:105.0/255.0 alpha:1.0];
            [self.scrollContainer addSubview:statusLbl];
            
            CGFloat statusLblHeight = [self getHeightByWidth:statusLbl.frame.size.width title:statusLbl.text font:statusLbl.font];
            statusLbl.frame = CGRectMake(statusLbl.frame.origin.x, statusLbl.frame.origin.y, statusLbl.frame.size.width, statusLblHeight);
            
            //时间
            UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(statusLbl.frame.origin.x+statusLbl.frame.size.width+10.0, offY-4.0,self.frame.size.width-50.0-statusLbl.frame.size.width , 0.0)];
            timeLbl.font = [UIFont systemFontOfSize:11.0];
            timeLbl.textColor = [UIColor lightGrayColor];
            timeLbl.backgroundColor = [UIColor clearColor];
            timeLbl.textAlignment = NSTextAlignmentRight;
            timeLbl.text = times[i];
            timeLbl.numberOfLines = 0;
            [self.scrollContainer addSubview:timeLbl];
            
            CGFloat timeLblHeight = [self getHeightByWidth:timeLbl.frame.size.width title:timeLbl.text font:timeLbl.font];
            timeLbl.frame = CGRectMake(timeLbl.frame.origin.x, timeLbl.frame.origin.y, timeLbl.frame.size.width, timeLblHeight);
            
            //描述文字
            UILabel *desLbl = [[UILabel alloc] initWithFrame:CGRectMake(40.0, statusLbl.frame.origin.y+statusLblHeight+10.0, self.frame.size.width-30.0-150.0, 0.0)];
            desLbl.font = [UIFont systemFontOfSize:12.0];
            desLbl.textColor = [UIColor lightGrayColor];
            desLbl.text = descriptions[i];
            desLbl.numberOfLines = 0;
            desLbl.backgroundColor = [UIColor clearColor];
            [self.scrollContainer addSubview:desLbl];
            
            CGFloat desLblHeight = [self getHeightByWidth:desLbl.frame.size.width title:desLbl.text font:desLbl.font];
            desLbl.frame = CGRectMake(desLbl.frame.origin.x, desLbl.frame.origin.y, desLbl.frame.size.width, desLblHeight);
            
            //计算下一个的偏移量
            float temp = statusLblHeight+10.0+desLblHeight+10.0 > kTLDefaultHeight?statusLblHeight+10.0+desLblHeight+10.0:kTLDefaultHeight;
            
            if (i != times.count -1) {
                totalProgrssHeight = totalProgrssHeight+temp;
            }else
            {
                //绘制自定义图片
                [solidLine removeFromSuperlayer];
                
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeLineOk"]];
                imgView.frame = CGRectMake(0.0, offY, imgView.frame.size.width, imgView.frame.size.height);
                [self.scrollContainer addSubview:imgView];
            }
            
            offY = offY+temp;
        }
        
        //修改完高度之后，旋转角度
        self.progressView.frame = CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, totalProgrssHeight, self.progressView.frame.size.height);
        self.progressView.transform =  CGAffineTransformMakeRotation(90*M_PI/180);
        
        self.scrollContainer.frame = CGRectMake(self.scrollContainer.frame.origin.x, self.scrollContainer.frame.origin.y, self.frame.size.width, self.frame.size.height);
        self.scrollContainer.contentSize = CGSizeMake(self.scrollContainer.frame.size.width, totalProgrssHeight);
    }
    return self;
}

- (void)addTimeDescriptionLabels:(NSArray *)timeDescriptions andTime:(NSArray *)time currentStatus:(int)currentStatus
{
    
}

#pragma mark - 根据内容获取宽高
- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
@end
