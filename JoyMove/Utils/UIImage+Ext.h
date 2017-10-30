//
//  UIImage+Ext.h
//  PetBar
//
//  Created by zhangYuan on 14-6-4.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ext)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;  ///等比缩略图
+ (UIImage *)thumbnailWithImageFitForMinSide:(UIImage *)image size:(CGSize)asize;
+ (UIImage *)compressImageWith:(UIImage *)image size:(CGSize)asize;
+ (UIImage *)imageFromView:(UIView *)view;

@end
