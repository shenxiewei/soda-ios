//
//  AddPicTBCell.m
//  JoyMove
//
//  Created by Soda on 2017/9/8.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "AddPicTBCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "ShowPictureViewController.h"

#import "UIWindow+Visible.h"

@interface AddPicTBCell()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topDesLbl;

@end

@implementation AddPicTBCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"AddPicTBCell";
    AddPicTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddPicTBCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints
{
    [super updateConstraints];
}

#pragma mark - UIPickerDelegate
// 保存图片后到相册后，调用的相关方法，查看是否保存成功
// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的原数据
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self addPhoto:theImage];
    [picker  dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event response
- (IBAction)takePhotoAction:(id)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [controller setMediaTypes:arrMediaTypes];
    [controller setAllowsEditing:NO];
    // 设置代理
    [controller setDelegate:self];
    [[[UIApplication sharedApplication].keyWindow visibleViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)checkBigImage:(UIButton *)button
{
    ShowPictureViewController *showPic = [[ShowPictureViewController alloc] init];
    showPic.isFromFront = YES;
    showPic.isShowFullScreen = YES;
    showPic.isShowDelete = YES;
    
    JMWeakSelf(self);
    showPic.deletePhotoBlcok = ^()
    {
        [weakself.allPhotos removeObject:button];
        [button removeFromSuperview];
        
        if (weakself.allPhotos.count > 0) {
            for (int i = 0; i < self.allPhotos.count; i++) {
                UIButton *temp = self.allPhotos[i];
                temp.frame = CGRectMake(20.0+i*(temp.frame.size.width+10.0), self.takePhotoBtn.frame.origin.y, self.takePhotoBtn.frame.size.width, self.takePhotoBtn.frame.size.height);
            }
            
            UIButton *lastBtn = [weakself.allPhotos lastObject];
            self.takePhotoBtn.frame = CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10.0, self.takePhotoBtn.frame.origin.y, self.takePhotoBtn.frame.size.width, self.takePhotoBtn.frame.size.height);
            self.takePhotoBtn.hidden = NO;
        }else
        {
            self.takePhotoBtn.frame = CGRectMake(20.0, self.takePhotoBtn.frame.origin.y, self.takePhotoBtn.frame.size.width, self.takePhotoBtn.frame.size.height);
        }
    };
    [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:showPic animated:YES];
    showPic.image = [button imageForState:UIControlStateNormal];
}

#pragma mark - priavte
- (void)addPhoto:(UIImage *)img{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImage:img forState:UIControlStateNormal];
    btn.frame = self.takePhotoBtn.frame;
    [btn addTarget:self action:@selector(checkBigImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    //[self.allPhotos addObject:btn];
    NSMutableArray *allPhotos = [self mutableArrayValueForKey:@keypath(self, allPhotos)];
    [allPhotos addObject:btn];
    
    self.takePhotoBtn.frame = CGRectMake(btn.frame.origin.x+btn.frame.size.width+10.0, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
    if (self.allPhotos.count >= 3) {
        self.takePhotoBtn.hidden = YES;
    }
}
#pragma mark - lazyLoad
- (NSMutableArray *)allPhotos
{
    if (!_allPhotos) {
        _allPhotos = [[NSMutableArray alloc] init];
    }
    return _allPhotos;
}
@end
