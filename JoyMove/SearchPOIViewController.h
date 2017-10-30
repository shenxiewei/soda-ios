//
//  SearchPOIViewController.h
//  JoyMove
//
//  Created by ethen on 15/3/23.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "SearchModel.h"

typedef NS_ENUM(NSInteger, SearchPOIType) {
    
    SPTypeNavi = 100,
    SPTypeAddressHome,
    SPTypeAddressCompany,
};

@protocol SearchPOIDelegate <NSObject>

- (void)didSelectedPOI:(SearchModel *)model type:(SearchPOIType)type;

@end


@interface SearchPOIViewController : BaseViewController

@property (assign, nonatomic) id<SearchPOIDelegate> delegate;
@property (assign, nonatomic) SearchPOIType type;

@end
