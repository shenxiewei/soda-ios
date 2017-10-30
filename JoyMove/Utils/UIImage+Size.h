//
//  UIImage+Size.h
//  ResignView
//
//  Created by ethen on 15/2/11.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)

//缩放到指定size
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

//截取指定rect
+ (UIImage *)getPartOfImage:(UIImage *)img rect:(CGRect)partRect;

//修复旋转后的图片的orientation属性
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
