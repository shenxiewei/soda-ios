//
//  WelcomeViewController.m
//  JoyMove
//
//  Created by ethen on 15/3/18.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Macro.h"
#import "LXRequest.h"

@interface WelcomeViewController ()<UIScrollViewDelegate> {
    
    UIScrollView *_scrollView;
    NSArray *_imageNameArray;
    NSArray *_networkArray;
}
@end

@implementation WelcomeViewController

const float animateDuration = .25f;

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self initData];
    [self initUI];
}

#pragma mark - UI

- (void)initData {
    
    NSString *device = @"";
    if (kIphone4) {
        
        device = @"i4";
    }else if (kIphone5) {
        
        device = @"i5";
    }else if (kIphone6) {
        
        device = @"i6";
    }else if (kIphone6plus) {
        
        device = @"i6p";
    }else {
        
        ;
    }
    
    NSMutableArray *mutableArray = [@[] mutableCopy];
    for (NSInteger i=1; i<3; i++) {
        
        NSString *imgName = [NSString stringWithFormat:@"welcome_%@_%li", device, (long)i];
        [mutableArray addObject:imgName];
    }
    _imageNameArray = mutableArray;
}

- (void)initUI {

    self.view.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"networkBootPage"])
    {
        NSInteger i = 0;
        for (NSString *imageName in _imageNameArray)
        {
            UIImage *image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(self.view.bounds.size.width*(i++), 0, self.view.bounds.size.width, self.view.bounds.size.height);
            [_scrollView addSubview:imageView];
        }
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*_imageNameArray.count, self.view.bounds.size.height);
    }
    else
    {
        if (_networkArray.count>0)
        {
            NSInteger i = 0;
            for (NSString *imageName in _networkArray)
            {
                UIImage *image = [UIImage imageNamed:imageName];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake(self.view.bounds.size.width*(i++), 0, self.view.bounds.size.width, self.view.bounds.size.height);
                [_scrollView addSubview:imageView];
            }
            _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*_imageNameArray.count, self.view.bounds.size.height);
        }
        
    }
    
    UIImageView *btnImgV = [[UIImageView alloc] initWithImage:UIImageName(@"start")];
    btnImgV.frame = CGRectMake((self.view.frame.size.width-btnImgV.frame.size.width)*0.5+self.view.frame.size.width, self.view.frame.size.height-btnImgV.frame.size.height-30.0, btnImgV.frame.size.width, btnImgV.frame.size.height);
    [_scrollView addSubview:btnImgV];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.bounds.size.width*(_imageNameArray.count-1), 0, self.view.bounds.size.width, kScreenHeight);
    [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
}

- (void)showInView:(UIView *)view {
    
    self.view.alpha = 0;
    [view addSubview:self.view];
    
    [UIView animateWithDuration:animateDuration animations:^{
        
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    if (self.loginNilBlock)
    {
        self.loginNilBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    /*
    if (decelerate) {
        
        NSLog(@"%f", scrollView.contentOffset.x);
        NSLog(@"%f", scrollView.contentSize.width);
        if (scrollView.contentOffset.x > (scrollView.frame.size.width*(_imageNameArray.count-1))) {
            
            [self hide];
        }
    }
     */
}

#pragma mark - request
-(void)requestGuidePage
{
    [LXRequest requestWithJsonDic:nil andUrl:kURL(@"") completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success)
        {
            if (result==10000)
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"networkBootPage"];
                [NSUserDefaults standardUserDefaults];
            }
        }
        else
        {
        
        }
    }];
    
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

@end
