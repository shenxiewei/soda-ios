//
//  ViewControllerServant.m
//  JoyMove
//
//  Created by ethen on 15/6/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.

#import "ViewControllerServant.h"
#import "Macro.h"

@implementation ViewControllerServant

#pragma mark - Tool

//获取用户与目标车的距离
+ (CLLocationDistance)distance: (CLLocationCoordinate2D)coorA fromCoor:(CLLocationCoordinate2D)coorB {
    
    if (!coorA.latitude||!coorA.longitude||!coorB.latitude||!coorB.longitude) {
        
        return 0.f;
    }
    
    CLLocationDistance kilometers = [ViewControllerServant distanceFromA:coorA toB:coorB];
    
    return kilometers;
}

//计算两个坐标之间的距离
+ (double)distanceFromA:(CLLocationCoordinate2D)coorA toB:(CLLocationCoordinate2D)coorB {
    
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:coorA.latitude longitude:coorA.longitude];
    CLLocation *dist = [[CLLocation alloc] initWithLatitude:coorB.latitude longitude:coorB.longitude];
    CLLocationDistance kilometers = [orig distanceFromLocation:dist];
    
    return kilometers;
}

//用户当前位置上方的头像
+ (UIImageView *)userImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.f, 2, 36, 36)];
    imageView.backgroundColor = UIColorFromRGB(200, 200, 200);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    [imageView sd_setImageWithURL:[NSURL URLWithString:kUrlHeader] placeholderImage:[UIImage imageNamed:@"header"]];
    imageView.userInteractionEnabled = NO;
    
    UIImage *image = [UIImage imageNamed:@"bubbles"];
    UIImageView *bubbles = [[UIImageView alloc] initWithImage:image];
    bubbles.frame = CGRectMake(.5f, -40, 45, 45);
    [bubbles addSubview:imageView];
    bubbles.userInteractionEnabled = NO;
    
    return bubbles;
}

//途经点上方的头像
+ (UIImageView *)stopImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.f, 2, 36, 36)];
    imageView.backgroundColor = UIColorFromRGB(200, 200, 200);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.image = [UIImage imageNamed:@"stopBubbles"];
    imageView.userInteractionEnabled = NO;
    
    UIImage *image = [UIImage imageNamed:@"bubbles"];
    UIImageView *bubbles = [[UIImageView alloc] initWithImage:image];
    bubbles.frame = CGRectMake(.5f, -40, 45, 45);
    [bubbles addSubview:imageView];
    bubbles.userInteractionEnabled = NO;
    
    return bubbles;
}

//终点上方的头像
+ (UIImageView *)destinationImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.f, 2, 36, 36)];
    imageView.backgroundColor = UIColorFromRGB(200, 200, 200);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.image = [UIImage imageNamed:@"destinationBubbles"];
    imageView.userInteractionEnabled = NO;
    
    UIImage *image = [UIImage imageNamed:@"bubbles"];
    UIImageView *bubbles = [[UIImageView alloc] initWithImage:image];
    bubbles.frame = CGRectMake(.5f, -40, 45, 45);
    [bubbles addSubview:imageView];
    bubbles.userInteractionEnabled = NO;
    
    return bubbles;
}

@end
