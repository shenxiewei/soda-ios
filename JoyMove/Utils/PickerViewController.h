//
//  PickerViewController.h
//  ResignView
//
//  Created by 刘欣 on 15/2/10.
//  Copyright (c) 2015年 刘欣. All rights reserved.
// <相机>

#import <UIKit/UIKit.h>

@protocol PickerDelegate <NSObject>

- (void)didSelectedImage:(UIImage *)image;

@end

typedef NS_ENUM(NSUInteger, PickerStyle) {
    
    PickerStyleNone,
    PickerStyleIdCard,
    PickerStyleDriverLicense,
};

@interface PickerViewController : UIImagePickerController

//@property(nonatomic,assign)BOOL isRevolve;
@property(nonatomic,assign)UIImagePickerControllerSourceType source;
@property(nonatomic,assign)BOOL isShowAlert;
@property(nonatomic,assign)id <PickerDelegate> pickerDelegate;

- (void)initUIWithStyle:(PickerStyle)style;

@end
