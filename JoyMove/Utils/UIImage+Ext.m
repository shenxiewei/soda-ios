//
//  UIImage+Ext.m
//  PetBar
//
//  Created by zhangYuan on 14-6-4.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import "UIImage+Ext.h"

@implementation UIImage (Ext)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    
    UIImage *newimage;
    
    double originHeight = image.size.height;
    double originWidth  = image.size.width;
    double wantHeight    = asize.height;
    double wantWidth    = asize.width;
    
    if (nil==image) {
        
        newimage = nil;
    }else {
        
        CGSize oldsize = image.size;
        
        if (oldsize.height<=asize.height&&oldsize.width<asize.width) {
            
            return image;
        }
        CGRect rect;
        
        double targetWidth;
        double targetHeight;
        if (wantWidth/wantHeight > originWidth/originHeight) {
            
            targetWidth = (double)wantHeight*originWidth/originHeight;
            targetHeight = (double)wantHeight;
        }else {
            
            targetWidth = (double)wantWidth;
            targetHeight = (double)wantWidth*originHeight/originWidth;
        }
        int outputHeight = ceil(targetHeight);
        int outputWidth  = ceil(targetWidth);
        
        rect = CGRectMake(0, 0, outputWidth,outputHeight);
        
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, wantWidth, wantHeight));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return newimage;
}

+ (UIImage *)thumbnailWithImageFitForMinSide:(UIImage *)image size:(CGSize)asize {

    UIImage *newimage;

    double originHeight = image.size.height;
    double originWidth  = image.size.width;
    double wantHeight   = asize.height;
    double wantWidth    = asize.width;

    if (nil==image) {

        newimage = nil;
    }else {

        CGSize oldsize = image.size;

        if (oldsize.height<=asize.height&&oldsize.width<asize.width) {
            
            return image;
        }
        CGRect rect;

        double targetWidth;
        double targetHeight;
        if (wantWidth/wantHeight < originWidth/originHeight) {

            targetWidth = (double)wantHeight*originWidth/originHeight;
            targetHeight = (double)wantHeight;
        }else {

            targetWidth = (double)wantWidth;
            targetHeight = (double)wantWidth*originHeight/originWidth;
        }
        int outputHeight = ceil(targetHeight);
        int outputWidth  = ceil(targetWidth);

        rect = CGRectMake(0, 0, outputWidth,outputHeight);

        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, wantWidth, wantHeight));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
    }

    return newimage;
}

+ (UIImage *)compressImageWith:(UIImage *)image size:(CGSize)asize {
    
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = asize.width;
    float height = asize.height;
    float widthScale = imageWidth/width;
    float heightScale = imageHeight/height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (widthScale>heightScale) {
        
        [image drawInRect:CGRectMake(0, 0, imageWidth/heightScale, height)];
    }else {
        
        [image drawInRect:CGRectMake(0, 0, width, imageHeight/widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片，创建一个重绘图片的上下文。
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageFromView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
