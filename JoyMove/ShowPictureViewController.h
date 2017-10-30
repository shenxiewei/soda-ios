//
//  ShowPictureViewController.h
//  JoyMove
//
//  Created by 赵霆 on 16/1/6.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "SDCViewController.h"

@interface ShowPictureViewController : SDCViewController

@property (nonatomic, strong) UIImage *image;
// 是否为前摄像头自拍
@property (nonatomic, assign) BOOL isFromFront;
@property (nonatomic, assign) BOOL isShowDelete;
@property (nonatomic, assign) BOOL isShowFullScreen;

@property (copy, nonatomic) void(^deletePhotoBlcok)();

@end
