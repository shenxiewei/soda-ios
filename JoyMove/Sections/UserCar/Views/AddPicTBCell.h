//
//  AddPicTBCell.h
//  JoyMove
//
//  Created by Soda on 2017/9/8.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPicTBCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;

@property (nonatomic, strong) NSMutableArray *allPhotos;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
