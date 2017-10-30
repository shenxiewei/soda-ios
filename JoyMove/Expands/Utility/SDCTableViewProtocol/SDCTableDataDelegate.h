//
//  SDCTableDataDelegate.h
//  SDBaseCompents
//
//  Created by Soda on 2017/4/6.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UITableViewCell+Extension.h"

typedef void    (^TableViewCellConfigureBlock)(NSIndexPath *indexPath, id item, UITableViewCell *cell) ;
typedef CGFloat (^CellHeightBlock)(NSIndexPath *indexPath, id item) ;
typedef void    (^DidSelectCellBlock)(NSIndexPath *indexPath, id item) ;

@interface SDCTableDataDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>


- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    cellHeightBlock:(CellHeightBlock)aHeightBlock
     didSelectBlock:(DidSelectCellBlock)didselectBlock ;

- (void)handleTableViewDatasourceAndDelegate:(UITableView *)table ;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath ;

@end
