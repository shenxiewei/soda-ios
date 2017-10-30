//
//  MyPicker.m
//  JoyMove
//
//  Created by 刘欣 on 15/6/15.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "MyPicker.h"
//#import "UIImage+Size.h"

#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)

@interface MyPicker () {
    
    UIView *_bottomView;
    BOOL _isTorch;
    UIButton *_quitButton;
    float currentSize;
    BOOL sizeOrientation;
    NSTimer *_timer;
}
@end

//const float imageSizeWidth      = 200;
//const float imageSizeHeight     = 200;

@implementation MyPicker

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //detecting device orientation
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    //requst for nearby cars list
    [self setUpCameraLayer];
    
    //创建计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(imageBorderChanging) userInfo:nil repeats:YES];
    currentSize = 1.0f;
    sizeOrientation = YES;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    //启动session
    if (self.session) {
        
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //remove detecting of device's orientation
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //关闭session
    if (self.session) {
        
        [self.session stopRunning];
    }
    [_timer invalidate];
}

- (instancetype)init{

    self = [super init];
    if (self) {
        
        self.session = [[AVCaptureSession alloc] init];
        
        if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            
            self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        }
        self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self whichCamera] error:nil];
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSetting = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSetting];
        if ([self.session canAddInput:self.videoInput]) {
            
            [self.session addInput:self.videoInput];
        }
        if ([self.session canAddOutput:self.stillImageOutput]) {
            
            [self.session addOutput:self.stillImageOutput];
        }
        [self initCameraUI];
    }
    return self;
}

#pragma mark - 初始化cameraShowView

- (void)initCameraUI {

    float idScale = 8.5/5.4; //身份证宽／长比例
    
    self.cameraShowView = [[UIView alloc] init];
    self.cameraShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 90);
    [self.view addSubview:self.cameraShowView];
    
    //图片边框
    UIImage *image = [UIImage imageNamed:@"imageBorder"];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    image = [image stretchableImageWithLeftCapWidth:width/2 topCapHeight:height/2];
    self.showImage = [[UIImageView alloc] init];
    self.showImage.frame = CGRectMake(10, 10, kScreenWidth-20, (kScreenWidth-20)*idScale);
    self.showImage.image = image;
    [self.view addSubview:self.showImage];
    
    //横屏拍照提示
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(-40, (kScreenHeight-90-20)/2, 200, 40);
    promptLabel.backgroundColor = [UIColor colorWithRed:229.f/255 green:38.f/255 blue:22.f/255 alpha:0.5];
    promptLabel.layer.cornerRadius = 4;
    promptLabel.layer.masksToBounds = YES;
    promptLabel.text = @"请避免反光\n保证有效文字和数字清晰";
    promptLabel.numberOfLines = 2;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor colorWithRed:200.f/255 green:200.f/255 blue:200.f/255 alpha:1];
    [promptLabel setTransform:CGAffineTransformRotate(self.view.transform, 90.0f*M_PI/180)];
    [self.view addSubview:promptLabel];
    
    //底部按钮区
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, kScreenHeight-90, kScreenWidth, 90);
    bottomView.backgroundColor = [UIColor colorWithRed:0.878f green:0.424f blue:0.341f alpha:1.00f];
    [self.view addSubview:bottomView];
    
    //闪光灯
    UIImage *torchImage = [UIImage imageNamed:@"torch"];
    self.torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.torchButton.frame = CGRectMake(kScreenWidth-torchImage.size.width-25, (bottomView.bounds.size.height-torchImage.size.height)/2, torchImage.size.width, torchImage.size.height);
    [self.torchButton setImage:torchImage forState:UIControlStateNormal];
    _isTorch = NO;
    [self.torchButton addTarget:self action:@selector(onTorch) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.torchButton];
    
    //拍照
    UIImage *buttonImage = [UIImage imageNamed:@"captureButton"];
    CGFloat buttonWidth = buttonImage.size.width;
    CGFloat buttonHeight = buttonImage.size.height;
    self.shutterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shutterButton.frame = CGRectMake((kScreenWidth-buttonWidth)/2, (90-buttonHeight)/2, buttonWidth, buttonHeight);
    [self.shutterButton setImage:buttonImage forState:UIControlStateNormal];
    [self.shutterButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.shutterButton];
    
    //退出按钮
    UIImage *quitImage = [UIImage imageNamed:@"quitButton"];
    _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _quitButton.frame = CGRectMake(25, (bottomView.bounds.size.height-quitImage.size.height)/2, quitImage.size.width, quitImage.size.height);
    [_quitButton setImage:quitImage forState:UIControlStateNormal];
    [_quitButton addTarget:self action:@selector(quitMyPicker) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_quitButton];
    
}

#pragma mark - 获取前后摄像头的方法

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {

    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        
        if ([device position] == position) {
            
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)whichCamera{

        return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark - 加载预览图层

- (void)setUpCameraLayer {

    if (self.previewLayer == nil) {
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView *view = self.cameraShowView;
        CALayer *viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    }
}

#pragma mark - Actions

//拍照事件
- (void)shutterCamera {
    
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == NULL) {
            
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        [self captureStillImage:image];
    }];
}

//退出相机
- (void)quitMyPicker {

    [self dismissViewControllerAnimated:YES completion:nil];
}

//开关闪光灯
- (void)onTorch {

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的设备不支持闪光灯" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        
        [device lockForConfiguration:nil];
        if (!_isTorch) {
            
            [device setTorchMode: AVCaptureTorchModeOn];
            _isTorch = YES;
        }else {
            
            [device setTorchMode: AVCaptureTorchModeOff];
            _isTorch = NO;
        }
        
        [device unlockForConfiguration];
    }
}

//选中图片
- (void)captureStillImage:(UIImage *)image {
    
    
////    UIImage *compressImage = [self compressImageWithImage:image];
//    cv::Mat matImage = [self cvMatFromUIImage:image];
//    cv::Mat resultImage = findCard(matImage);
//    
//    UIImage *finalImage = [self UIImageFromCVMat:resultImage];
//    
//    [self.myPickerDelegate captureStillImageDidFinish:finalImage];
    
    
    [self.myPickerDelegate captureStillImageDidFinish:image];
    [self quitMyPicker];
}

- (void)imageBorderChanging {
    
    if (sizeOrientation) {
        
        self.showImage.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeScale(currentSize, currentSize));
        currentSize += 0.001f;
        if (currentSize >= 1.02f) {
            
            sizeOrientation = NO;
        }
    }else {
        
        self.showImage.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeScale(currentSize, currentSize));
        currentSize -= 0.001f;
        if (currentSize <= 0.98f) {
            
            sizeOrientation = YES;
        }
    }
}

//检测到屏幕方向发生变化
- (void)orientationChanged:(NSNotification *)notification {

    [self adjustViewsForOrientation:[[UIDevice currentDevice] orientation]];
}

//屏幕方向发生变化相应处理
- (void) adjustViewsForOrientation:(UIDeviceOrientation) orientation {
    
    switch (orientation){
            
        case UIDeviceOrientationLandscapeLeft:{
            
            //load the portrait view
            [UIView animateWithDuration:0.25f delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.autoresizesSubviews = NO;
                [_quitButton setTransform:CGAffineTransformRotate(self.view.transform, 90.0f*M_PI/180)];
                [self.shutterButton setTransform:CGAffineTransformRotate(self.view.transform, 90.0f*M_PI/180)];
                [self.torchButton setTransform:CGAffineTransformRotate(self.view.transform, 90.0f*M_PI/180)];
            } completion:nil];
        }
            
            break;
        case UIDeviceOrientationPortrait:{
            
            //load the landscape view
            [UIView animateWithDuration:0.25f delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.autoresizesSubviews = NO;
                [_quitButton setTransform:CGAffineTransformRotate(self.view.transform, 0.0f)];
                [self.shutterButton setTransform:CGAffineTransformRotate(self.view.transform, 0.0f)];
                [self.torchButton setTransform:CGAffineTransformRotate(self.view.transform, 0.0f)];
            } completion:nil];
        }
            break;
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationUnknown:
            break;
    }
}

//图片压缩 （未用）
//- (UIImage *)compressImageWithImage:(UIImage *)image {
//
//    UIImageOrientation imgOrientation = image.imageOrientation;;
//    
//    UIImage *img = [[UIImage alloc] initWithCGImage:image.CGImage  scale:1.0 orientation:imgOrientation];
//    if (img.size.height > imageSizeHeight) {
//        
//        float width = img.size.width*(imageSizeHeight/img.size.height);
//        img = [UIImage imageWithImage:img scaledToSize:CGSizeMake(width, imageSizeHeight)];
//    }else if (img.size.width > imageSizeWidth) {
//        
//        float height = img.size.height*(imageSizeWidth/img.size.width);
//        img = [UIImage imageWithImage:img scaledToSize:CGSizeMake(imageSizeWidth, height)];
//    }else {
//        
//        ;
//    }
//    return img;
//}

@end
