//
//  ShowPictureViewController.m
//  JoyMove
//
//  Created by 赵霆 on 16/1/6.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "ShowPictureViewController.h"

@implementation ShowPictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    JMWeakSelf(self);
    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.isShowDelete) {
        [self customRightNav:@"pic_delete" touchUpInsideBlock:^{
            if (weakself.deletePhotoBlcok) {
                weakself.deletePhotoBlcok();
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    self.title = NSLocalizedString(@"View the photo", nil);
    self.view.backgroundColor = [UIColor blackColor];
    
    if (_isFromFront) {
        
        [self showTheImageForFront];
    }else{
        
        [self showTheImageForBack];
    }
}

- (void)showTheImageForBack
{
    UIImage *newImage = [UIImage imageWithCGImage:self.image.CGImage scale:1 orientation:UIImageOrientationRight];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    imageView.image = newImage;
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
}

- (void)showTheImageForFront
{
    if (self.isShowFullScreen) {
        UIImageView *imageView = [[UIImageView alloc] init];
        float scale = MIN(kScreenWidth/self.image.size.width, (kScreenHeight-64)/self.image.size.height);
        CGSize size = CGSizeMake(self.image.size.width*scale, self.image.size.height*scale);
        imageView.frame = CGRectMake((kScreenWidth-size.width)*0.5, (kScreenHeight-64.0-size.height)*0.5+64.0, size.width, size.height);
        imageView.image = self.image;
        //    imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imageView];
    }else
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.frame = CGRectMake(0, (kScreenHeight - self.image.size.height) * 0.5, self.image.size.width, self.image.size.height);
        imageView.image = self.image;
        //    imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imageView];
    }
}
@end
