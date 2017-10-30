//
//  PromptView.m
//  JoyMove
//
//  Created by 刘欣 on 15/8/14.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "PromptView.h"
#import "Macro.h"
#import "LXRequest.h"

@interface PromptView ()<UIScrollViewDelegate> {
    
    PromptViewStyle style;  //为什么要存它？因为delegate回调时候要传回去……
    //还车失败页面下面的button
    UIButton *_showAllButton;
    //一键租车失败页面的Button
    UIButton *_AKeyRentCarButton;
    //催我建站按钮
    UIButton *_UrgeSiteButton;
}
@end

@implementation PromptView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithPromptViewStyle:(PromptViewStyle)promptViewStyle {

    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.userInteractionEnabled = YES;
        [self initUIWithPromptViewStyle:promptViewStyle];
    }
    return self;
}

- (void)initUIWithPromptViewStyle:(PromptViewStyle)promptViewStyle {

    style = promptViewStyle;
    if (ValidDatePromptViewTag == promptViewStyle) {
        
        UIImage *ValidDateImg;
        if (kScreenWidth > 375) {
            
            ValidDateImg = [UIImage imageNamed:@"validDateSpecification_6p"];
        }else {
        
            ValidDateImg = [UIImage imageNamed:@"validDateSpecification"];
        }
        [self initUIForCreditCardBindingWithBackgroudImage:ValidDateImg];
    }else if (CVV2PromptViewTag == promptViewStyle) {
    
        UIImage *CVV2Img;
        if (kScreenWidth > 375) {
            
            CVV2Img = [UIImage imageNamed:@"CVV2Specification_6p"];
        }else {
        
            CVV2Img = [UIImage imageNamed:@"CVV2Specification"];
        }
        [self initUIForCreditCardBindingWithBackgroudImage:CVV2Img];
    }else if (RentSuccessPromptViewTag == promptViewStyle) {
        self.hidden=YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.hidden=YES;
            // 耗时的操作
            self.carID=[OrderData orderData].carId;
            NSDictionary *postDic = @{@"vin":[NSString stringWithFormat:@"%@",self.carID]};//sodacartestQ10004
            [LXRequest requestWithJsonDic:postDic andUrl:kURL(KUrlGetGuidePage) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                if (success) {
                    if (result == JMCodeSuccess)
                    {
                        NSMutableArray *array=[[NSMutableArray alloc]init];
                        for (NSDictionary *dic in response[@"icons"])
                        {
                            if (dic[@"url"] != [NSNull null]) {
                                [array addObject:dic[@"url"]];
                            }
//                            if ([dic[@"key"]  isEqual: @"IMG_GUIDE_PRE"])
//                            {
//                                self.icon_td_nor = dic[@"url"] != [NSNull null] ? dic[@"url"] : @"";
//                            }
//                            else if([dic[@"key"]  isEqual: @"IMG_GUIDE_NEXT"])
//                            {
//                                self.icon_td_pre = dic[@"url"] != [NSNull null] ? dic[@"url"] : @"";
//                            }else if ([dic[@"key"] isEqual: @"028_RENT_TIPS"])
//                            {
//                                self.icon_td_tips = dic[@"url"] != [NSNull null] ? dic[@"url"] : @"";
//                            }
                        }
                        if (array.count == 0) {
                            self.hidden = YES;
                        }else
                        {
                            [self requestAndInitRentCarSuccessView:array];
                        }
//                        if (self.icon_td_nor.length>0 && self.icon_td_pre.length>0)
//                        {
//                            NSMutableArray *array=[[NSMutableArray alloc]init];
//                            array= [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",self.icon_td_nor],[NSString stringWithFormat:@"%@",self.icon_td_pre], nil];
//                            if (self.icon_td_tips.length >0) {
//                                [array addObject:[NSString stringWithFormat:@"%@",self.icon_td_tips]];
//                            }
//                            [self requestAndInitRentCarSuccessView:array];
//                        }
//                        else
//                        {
//                            self.hidden=YES;
//                        }
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
                        NSString *message = response[@"errMsg"];
                        message = message&&message.length?message:JMMessageNoErrMsg;
                    }
                }else{
                    self.hidden=YES;
                }
                
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
//                self.hidden=NO;
            });
        });
        
    }else if (TerminateRentPromptViewTag == promptViewStyle) {
    
        NSArray *array;
        if (kScreenWidth>=414) {
            
            array = @[[UIImage imageNamed:@"terminateRentPrompt_6p"]];
        }else if (kScreenWidth>=375) {
            
            array = @[[UIImage imageNamed:@"terminateRentPrompt_6"]];
        }else {
            
            array = @[[UIImage imageNamed:@"terminateRentPrompt_5"]];
        }
        
        [self initUIForRentCarWithImages:array];
    }
    //还车失败
    else if (ReturnCarFailureTag==promptViewStyle)
    {
        [self returnCarFailurePicture];
    }
    //一键租车失败
    else if(AKeyRentCarFailureTag==promptViewStyle)
    {
        [self AKeyRentCarFailureView];
    }
    else
    {
        ;
    }
}

//还车失败显示图片
-(void)returnCarFailurePicture
{
    //黑色蒙板
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self addSubview:backView];
    
    //白色底版
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(10, 48.0/667*kScreenHeight, kScreenWidth-20, kScreenHeight-96.0/667*kScreenHeight)];
    whiteView.backgroundColor=[UIColor whiteColor];
    whiteView.layer.cornerRadius = 8;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"closeTheCarReturnFailedButton"] forState:UIControlStateNormal];
    closeButton.frame=CGRectMake(whiteView.frame.size.width-50, 0, 50, 50);
//    closeButton.backgroundColor=[UIColor blackColor];
    //这个tag值是在判定当还车失败时，用户点击右上方的关闭按钮
    closeButton.tag=2;
    [closeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeButton];
    
    UIImageView *backImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, closeButton.frame.origin.y+closeButton.frame.size.height+57.0/667*kScreenHeight, whiteView.frame.size.width, 170.0/667*kScreenHeight)];
    backImage.contentMode = UIViewContentModeCenter;
    backImage.image=[UIImage imageNamed:@"returnCarFailure"];
    [whiteView addSubview:backImage];
    
    UILabel *sorryLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backImage.frame.origin.y+backImage.frame.size.height+20.0/667*kScreenHeight, whiteView.frame.size.width, 17.0)];
    sorryLabel.text=NSLocalizedString(@"Sorry", nil);
    sorryLabel.textAlignment=NSTextAlignmentCenter;
    sorryLabel.font=[UIFont systemFontOfSize:18];
    sorryLabel.textColor=[UIColor blackColor];
    [whiteView addSubview:sorryLabel];
    
    UILabel *noParkLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, sorryLabel.frame.origin.y+sorryLabel.frame.size.height+17.0/667*kScreenHeight, whiteView.frame.size.width, 14.0)];
    noParkLabel.text=NSLocalizedString(@"This region is not availabe for return the vehicle", nil);
    noParkLabel.textAlignment=NSTextAlignmentCenter;
    noParkLabel.font=[UIFont systemFontOfSize:15];
    noParkLabel.textColor=UIColorFromSixteenRGB(0xb6b6b6);
    [whiteView addSubview:noParkLabel];
    
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,noParkLabel.frame.size.height+noParkLabel.frame.origin.y+68.0/667*kScreenHeight, whiteView.frame.size.width, 11)];
    promptLabel.textAlignment=NSTextAlignmentCenter;
    promptLabel.text=NSLocalizedString(@"Do not worry, Please check our soda stations", nil);
    promptLabel.font=[UIFont systemFontOfSize:13];
    promptLabel.textColor=UIColorFromSixteenRGB(0xb6b6b6);
    [whiteView addSubview:promptLabel];
    
    _showAllButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _showAllButton.frame=CGRectMake(54.0/375*kScreenWidth, promptLabel.frame.origin.y+promptLabel.frame.size.height+15.0/667*kScreenHeight, whiteView.frame.size.width-108.0/375*kScreenWidth, 46);
    [_showAllButton setTitle:NSLocalizedString(@"Nearby Soda Station", nil) forState:UIControlStateNormal];
    _showAllButton.titleLabel.font=[UIFont systemFontOfSize:15];
    _showAllButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_showAllButton setBackgroundImage:[UIImage imageNamed:@"nearTheCarParkingButton"] forState:UIControlStateNormal];
    [_showAllButton setTitleColor:UIColorFromSixteenRGB(0x7e7e7e) forState:UIControlStateNormal];
    [_showAllButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_showAllButton];
    
}

//一键租车失败显示页面
-(void)AKeyRentCarFailureView
{
    self.backgroundColor=[UIColor whiteColor];
    
    UIButton *popButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [popButton setBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal];
    popButton.frame=CGRectMake(0, 20, 44, 44);
    //这个tag值是在判定当一键租车失败时，用户点击左上方的返回
    popButton.tag=3;
    [popButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:popButton];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 34, kScreenWidth, 15)];
    titleLabel.text=NSLocalizedString(@"Nearby vehicle", nil);
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
//    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=UIColorFromSixteenRGB(0x000000);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 63, kScreenWidth, 0.5)];
    lineLabel.backgroundColor=[UIColor grayColor];
    [self addSubview:lineLabel];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64+45, kScreenWidth, 110)];
    headImage.image=[UIImage imageNamed:@"noCarImage"];
    headImage.contentMode = UIViewContentModeCenter;
    [self addSubview:headImage];
    
    UILabel *sorryLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, headImage.frame.size.height+headImage.frame.origin.y+40, kScreenWidth, 17)];
    sorryLabel.textAlignment=NSTextAlignmentCenter;
    sorryLabel.text=NSLocalizedString(@"Unfortunately", nil);
    sorryLabel.textColor=UIColorFromSixteenRGB(0x515151);
    sorryLabel.font=[UIFont systemFontOfSize:18];
    [self addSubview:sorryLabel];
    
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, sorryLabel.frame.origin.y+sorryLabel.frame.size.height+30, kScreenWidth, 12)];
    promptLabel.text=NSLocalizedString(@"No available vehicle around 1 km", nil);
    promptLabel.textAlignment=NSTextAlignmentCenter;
    promptLabel.font=[UIFont systemFontOfSize:15];
    promptLabel.textColor=UIColorFromSixteenRGB(0xb5b5b5);
    [self addSubview:promptLabel];
    
    //催我建站按钮
    _UrgeSiteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_UrgeSiteButton setTitle:NSLocalizedString(@"urge a station establishment", nil) forState:UIControlStateNormal];
    _UrgeSiteButton.titleLabel.font=[UIFont systemFontOfSize:16];
    _UrgeSiteButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_UrgeSiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_UrgeSiteButton setBackgroundColor:UIColorFromSixteenRGB(0xf37a66)];
    _UrgeSiteButton.frame=CGRectMake(59.0/320*kScreenWidth, promptLabel.frame.origin.y+promptLabel.frame.size.height+40, kScreenWidth-118.0/320*kScreenWidth, 46);
    [_UrgeSiteButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_UrgeSiteButton.layer setMasksToBounds:YES];
    [_UrgeSiteButton.layer setCornerRadius:2.0];
    [self addSubview:_UrgeSiteButton];
    
    _AKeyRentCarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_AKeyRentCarButton setTitle:NSLocalizedString(@"Show all stations", nil) forState:UIControlStateNormal];
    [_AKeyRentCarButton setTitleColor:UIColorFromSixteenRGB(0x9c9c9c) forState:UIControlStateNormal];
    _AKeyRentCarButton.titleLabel.font=[UIFont systemFontOfSize:16];
    _AKeyRentCarButton.frame=CGRectMake(59.0/320*kScreenWidth, _UrgeSiteButton.frame.origin.y+_UrgeSiteButton.frame.size.height+15, kScreenWidth-118.0/320*kScreenWidth, 46);
    [_AKeyRentCarButton setBackgroundImage:[UIImage imageNamed:@"noCarButton"] forState:UIControlStateNormal];
    [_AKeyRentCarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_AKeyRentCarButton];
}

//信用卡说明图片
- (void)initUIForCreditCardBindingWithBackgroudImage:(UIImage *)backgroudImage {

    //黑色蒙板
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self addSubview:backView];
    
    //说明图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroudImage];
    CGFloat Width = backgroudImage.size.width;
    CGFloat height = backgroudImage.size.height;
    imageView.frame = CGRectMake((kScreenWidth-Width)/2, 200, Width, height);
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    //知道按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, height-50, Width, 50);
    button.tag = 0;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
}

//租车成功提示信息
-(void)requestAndInitRentCarSuccessView:(NSArray *)array
{
    self.hidden=NO;
    //黑色蒙板
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self addSubview:backView];
    
    NSArray *array1;
    if (kScreenWidth>=414) {
        
        array1 = @[[UIImage imageNamed:@"terminateRentPrompt_6p"]];
    }else if (kScreenWidth>=375) {
        
        array1 = @[[UIImage imageNamed:@"terminateRentPrompt_6"]];
    }else {
        
        array1 = @[[UIImage imageNamed:@"terminateRentPrompt_5"]];
    }
    //说明图
    UIImage *image =array1[0];
    CGFloat maxWidth = kScreenWidth-20; //image最大的宽度，为什么-20？因为我想留个边
    CGFloat width = image.size.width>maxWidth?maxWidth:image.size.width;
    CGFloat height = image.size.width>maxWidth?image.size.height*(maxWidth/image.size.width):image.size.height;
    
//    CGFloat width = kScreenWidth-30;
//    CGFloat height = kScreenHeight-110;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake((kScreenWidth-width)/2, (kScreenHeight-height)/2, width, height)];
    scrollerView.tag = 1121;
    scrollerView.delegate = self;
    [scrollerView.layer setCornerRadius:8.0];
    [scrollerView.layer setMasksToBounds:YES];
    scrollerView.contentSize = CGSizeMake(width*array.count, height);
    scrollerView.pagingEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollerView];
    
    NSInteger i = 0;
    for (NSString *imageString in array) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView.layer setCornerRadius:8];
        [imageView.layer setMasksToBounds:YES];
        imageView.backgroundColor=[UIColor grayColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
        imageView.frame = CGRectMake(width*i, 0, width, height);
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [scrollerView addSubview:imageView];
        
        if (array.count-1==i) {
            
            if (RentSuccessPromptViewTag==style) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                //                button.backgroundColor = kThemeColor;
                button.frame = CGRectMake(0, height-58, width, 58);
                button.tag = 0;
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(64, 190, 211) forState:UIControlStateNormal];
                button.titleLabel.font = UIFontFromSize(16);
                [imageView addSubview:button];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x+2, button.frame.origin.y+2, button.frame.size.width-4, 1)];
                line.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
                [imageView addSubview:line];
            }else {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                //button.backgroundColor = kThemeColor;
                button.frame = CGRectMake(0, height-58, width/2, 58);
                button.tag = 0;
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(136, 136, 136) forState:UIControlStateNormal];
                button.titleLabel.font = UIFontFromSize(16);
                [imageView addSubview:button];
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
                //button2.backgroundColor = kThemeColor;
                button2.frame = CGRectMake(width/2, height-58, width/2, 58);
                button2.tag = 1;
                [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button2 setTitle:NSLocalizedString(@"End the trip", nil) forState:UIControlStateNormal];
                [button2 setTitleColor:UIColorFromRGB(64, 190, 211) forState:UIControlStateNormal];
                button2.titleLabel.font = UIFontFromSize(16);
                [imageView addSubview:button2];
            }
        }
        i++;
    }

    
    //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
    UIPageControl *pageConteol = [[UIPageControl alloc] initWithFrame:CGRectMake(140, scrollerView.frame.size.height - 60, 50, 20)];
    pageConteol.tag = 1122;
    pageConteol.userInteractionEnabled = NO;
    pageConteol.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.7, 1.7);
    pageConteol.center = CGPointMake(kScreenWidth*0.5, scrollerView.frame.origin.y+scrollerView.frame.size.height-pageConteol.frame.size.height*0.5-10.0);
    pageConteol.currentPageIndicatorTintColor = [UIColor colorWithRed:234/255.0f green:205/255.0f blue:66/255.0f alpha:1.0f];
    pageConteol.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageConteol.numberOfPages = array.count;//设置pageConteol 的page 和 _scrollView 上的图片一样多
    [self addSubview: pageConteol];
}

//租车和还车提示信息
- (void)initUIForRentCarWithImages:(NSArray *)array {
    
    //黑色蒙板
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self addSubview:backView];
    
    //说明图
    UIImage *image = array[0];
    CGFloat maxWidth = kScreenWidth-20; //image最大的宽度，为什么-20？因为我想留个边
    CGFloat width = image.size.width>maxWidth?maxWidth:image.size.width;
    CGFloat height = image.size.width>maxWidth?image.size.height*(maxWidth/image.size.width):image.size.height;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake((kScreenWidth-width)/2, (kScreenHeight-height)/2, width, height)];
    scrollerView.contentSize = CGSizeMake(width*array.count, height);
    scrollerView.pagingEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollerView];
    
    NSInteger i = 0;
    for (UIImage *image in array) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(width*i, 0, width, height);
        [scrollerView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        if (array.count-1==i) {
 
            if (RentSuccessPromptViewTag==style) {
               
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                button.backgroundColor = kThemeColor;
                button.frame = CGRectMake(0, height-58, width, 58);
                button.tag = 0;
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(64, 190, 211) forState:UIControlStateNormal];
                button.titleLabel.font = UIFontFromSize(16);
                [imageView addSubview:button];
            }else {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                //button.backgroundColor = kThemeColor;
                button.frame = CGRectMake(0, height-58, width/2, 58);
                button.tag = 0;
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(136, 136, 136) forState:UIControlStateNormal];
                button.titleLabel.font = UIFontFromSize(16);
                [imageView addSubview:button];
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
                //button2.backgroundColor = kThemeColor;
                button2.frame = CGRectMake(width/2, height-58, width/2, 58);
                button2.tag = 1;
                [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button2 setTitle:NSLocalizedString(@"End the trip", nil) forState:UIControlStateNormal];
                [button2 setTitleColor:UIColorFromRGB(64, 190, 211) forState:UIControlStateNormal];
                button2.titleLabel.font = UIFontFromSize(16);
                [imageView addSubview:button2];
            }
        }
        i++;
    }
}

- (void)buttonClicked:(UIButton *)button {
    if (button==_showAllButton)
    {
        if (self.pushController)
        {
            self.pushController();
        }
    }
    else if (button==_AKeyRentCarButton)
    {
        if (self.pushAllCarController)
        {
            self.pushAllCarController();
        }
    }
    else if (button==_UrgeSiteButton)
    {
        if (self.UrgeSiteButtonClick)
        {
            self.UrgeSiteButtonClick();
        }
    }
    else
    {
        [self.promptViewDelegate promptView:style clicked:button.tag];
    }
}

#pragma mark - Scrollview Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1121) {
        //首先通过tag值得到pageControl
        UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:1122];
        //page的计算方法为scrollView的偏移量除以屏幕的宽度即为第几页。
        int page = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        pageControl.currentPage = page;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1121) {
        UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:1122];
        if (scrollView.contentOffset.x > CGRectGetMaxX(scrollView.frame)) {
            pageControl.hidden = YES;
        }else
        {
            pageControl.hidden = NO;
        }
    }
}
@end
