//
//  PickerViewController.m
//  ResignView
//
//  Created by 刘欣 on 15/2/10.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import "PickerViewController.h"
#import "UIImage+Size.h"
#import "Macro.h"

@interface PickerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *_overlayView;
}
@end

const float imageSizeWidth      = 200;
const float imageSizeHeight     = 200;
const float navigationHeight    = 44;

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)initUIWithStyle:(PickerStyle)style {
    
    UIImagePickerControllerSourceType sourceType = self.source;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.delegate = self;
    self.sourceType = sourceType;
    self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    if (self.isShowAlert) {
        
        NSString *message = @"请清晰拍摄本人头像，此照片和身份证信息一同作为身份验证的依据";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    /*
    if (sourceType==UIImagePickerControllerSourceTypeCamera) {
        
        float proportion;
        if (PickerStyleIdCard==style) {
            
            proportion = 3.f/4.f;
        }else if (PickerStyleDriverLicense==style) {
            
            proportion = 3.f/4.f;
        }else {
            
            proportion = 3.f/4.f;   //测试
        }
        float cameraHeight  = kScreenWidth * 4.f / 3.f;
        //镜头高度
        UIImage *pickerImg = [UIImage imageNamed:@"pickerView"];
        pickerImg = [pickerImg stretchableImageWithLeftCapWidth:100 topCapHeight:100];
        UIImageView *pickerView = [[UIImageView alloc] init];
        pickerView.frame = CGRectMake(5, 44, kScreenWidth-10, cameraHeight);
        pickerView.image = pickerImg;
        _overlayView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]]; // 覆盖在相机取景框上的图层
        [_overlayView setBackgroundColor: [UIColor clearColor]];
        
        [_overlayView addSubview:pickerView];
        _overlayView.userInteractionEnabled = NO;
        self.cameraOverlayView = _overlayView;
    }
     */
}
 
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
//
//    [_overlayView removeFromSuperview];
//}

//相机代理——确定
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [_overlayView removeFromSuperview];
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageOrientation imgOrientation = image.imageOrientation;;
    UIImage *img = [[UIImage alloc] initWithCGImage:image.CGImage  scale:1.0 orientation:imgOrientation];
    
//        float width = img.size.width*(imageSizeHeight/img.size.height);
//        img = [UIImage imageWithImage:img scaledToSize:CGSizeMake(width, imageSizeHeight)];
    // 压缩
    float height = img.size.height*(kScreenWidth/img.size.width);
    img = [UIImage imageWithImage:img scaledToSize:CGSizeMake(kScreenWidth, height)];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(didSelectedImage:)]) {
        
        [self.pickerDelegate didSelectedImage:img];
    }
}

//代理——取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
