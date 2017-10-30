//
//  SDCTBViewCellModel.h
//  SlideMenu
//
//  Created by Soda on 2017/7/26.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import "SDCModel.h"

@interface SDCTBViewCellModel : SDCModel

@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *detailText;
@property(nonatomic, strong) UIImage *headImg;

@end
