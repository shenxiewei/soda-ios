//
//  ThankYouViewController.h
//  JoyMove
//
//  Created by ethen on 15/3/26.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BaseViewController.h"

@interface ThankYouViewController : BaseViewController

//分享图片的数组
@property (nonatomic,strong) NSArray *shareImageArray;
//背景海报
@property (nonatomic,strong) UIImageView *backImageView;
//图片加载中的label
@property (nonatomic,strong) UILabel *uploadLabel;

@end
