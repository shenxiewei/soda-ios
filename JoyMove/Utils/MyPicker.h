//
//  MyPicker.h
//  JoyMove
//
//  Created by 刘欣 on 15/6/15.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol MyPickerDelegate <NSObject>

- (void)captureStillImageDidFinish:(UIImage *)image;

@end

@interface MyPicker : UIViewController

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic,strong) AVCaptureSession *session;

//AVCaptureDeviceInput对象是输入流
@property (nonatomic,strong) AVCaptureDeviceInput *videoInput;

//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了
@property (nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;

//预览图层，来显示照相机拍摄到的画面
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

//展示图片
@property (nonatomic,strong) UIImageView *showImage;

//拍照按钮
@property (nonatomic,strong) UIButton *shutterButton;

//放置预览图层的View
@property (nonatomic,strong) UIView *cameraShowView;

//闪光灯按钮
@property (nonatomic,strong) UIButton *torchButton;

@property(nonatomic,assign)id <MyPickerDelegate> myPickerDelegate;

@end
