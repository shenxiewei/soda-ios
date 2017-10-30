//
//  OfflineMapViewController.m
//  JoyMove
//
//  Created by ethen on 15/4/27.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "OfflineMapViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "Reachability.h"
#import "AFNetworking.h"

@interface OfflineMapViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>{
    
    UITableView *_tableView;
    UIButton *_rightButton;
    
    NSIndexPath *_selectIndexPath;
    double _progass;
    // 检测是否Wi-Fi链接
    Reachability *_hostReachability;
    Reachability *_internetReachability;
    Reachability *_wifiReachability;
    
}

@end

typedef NS_ENUM(NSInteger, OfflineMapSheetTag) {
    
    OfflineMapSheetTagDeleteAll = 100,      /**< 全部删除 */
    OfflineMapSheetTagDown,                 /**< 下载 */
};

@implementation OfflineMapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    [self initNavigationItem];
    
}

#pragma mark - UI

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (void)initNavigationItem {
    
    self.title = @"离线地图";
    [self setNavBackButtonStyle:BVTagBack];
    
    _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 60, 44);
    [_rightButton setTitle:@"全部删除" forState:UIControlStateNormal];
    [_rightButton setTitleColor:UIColorFromRGB(120, 120, 120) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = UIFontFromSize(12);
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_rightButton];
}

// Reachability 检测网络情况
- (void)downloadCities{
    
    NSArray *array;
    array = [MAOfflineMap sharedOfflineMap].cities;
    MAOfflineItem *itemBJ = array[0];
    [self download:itemBJ];
    
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否要删除全部离线地图？" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"全部删除" otherButtonTitles:nil, nil];
    sheet.tag = OfflineMapSheetTagDeleteAll;
    [sheet showInView:self.navigationController.view];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!section) {
        
        return 1;
    }else {
        
        return [MAOfflineMap sharedOfflineMap].cities.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = UIFontFromSize(15);
        cell.detailTextLabel.font = UIFontFromSize(12);
    }
    
    NSArray *array;
    if (!indexPath.section) {
        
        array = @[[MAOfflineMap sharedOfflineMap].nationWide];
    }else {
        
        array = [MAOfflineMap sharedOfflineMap].cities;
    }
    MAOfflineProvince *item = array[indexPath.row];
    cell.textLabel.text = item.name;
    
    if (item.itemStatus == MAOfflineItemStatusNone) {
        
        cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"下载(%.1fm)", item.size/1024.f/1024.f];
    }else if (item.itemStatus == MAOfflineItemStatusInstalled) {
        
        cell.textLabel.textColor = UIColorFromRGB(200, 200, 200);
        cell.detailTextLabel.textColor = UIColorFromRGB(200, 200, 200);
        cell.detailTextLabel.text = @"已安装";
    }else if (item.itemStatus == MAOfflineItemStatusExpired) {
        
        cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.text = @"有更新";
    }else if (item.itemStatus == MAOfflineItemStatusCached) {
        
        cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"下载(%.1fm)", item.size/1024.f/1024.f];
    }else {
        
        ;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndexPath = indexPath;

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否下载地图？" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"开始下载" otherButtonTitles:nil, nil];
    sheet.tag = OfflineMapSheetTagDown;
    [sheet showInView:self.navigationController.view];
}

/*
 - (MAOfflineItem *)itemForIndexPath:(NSIndexPath *)indexPath {
 
 MAOfflineItem *item = nil;
 switch (indexPath.section) {
 
 case 0:
 
 item = [MAOfflineMap sharedOfflineMap].nationWide;//全国概要图
 break;
 
 case 1:
 
 item = _municipalities[indexPath.row];//直辖市
 break;
 
 case 2:
 
 item = nil;
 break;
 
 default:
 
 item = nil;
 //            MAOfflineProvince *pro = _provinces[indexPath.section - _sectionTitles.count];
 //            if (!indexPath.row) {
 //
 //                item = pro; //整个省
 //            }
 //            else {
 //
 //                item = pro.cities[indexPath.row - 1]; //市
 //            }
 //            break;
 //  }
 }
 return item;
 }
 */

- (void)download:(MAOfflineItem *)item {
    
    if (!item || item.itemStatus==MAOfflineItemStatusInstalled) {
        
        return;
    }
    
    NSLog(@"download :%@", item.name);
    //记得替换
    
//    [[MAOfflineMap sharedOfflineMap] downloadItem:item shouldContinueWhenAppEntersBackground:YES downloadBlock:^(MAOfflineMapDownloadStatus downloadStatus, id info) {
//
//        /* Manipulations to your application’s user interface must occur on the main thread. */
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            NSLog(@"%@", info);
//
//            if (downloadStatus == MAOfflineMapDownloadStatusWaiting)
//            {
//                NSLog(@"状态为: %@", @"等待下载");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusStart)
//            {
//                NSLog(@"状态为: %@", @"开始下载");
//
//                _progass = 0;
////                [self showProgress:_progass text:@"正在下载"];
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusProgress)
//            {
//                NSLog(@"状态为: %@", @"正在下载");
//
//                if (info) {
//
//                    double expectedSize = kDoubleFormObject(info[@"MAOfflineMapDownloadExpectedSizeKey"]);
//                    double receivedSize = kDoubleFormObject(info[@"MAOfflineMapDownloadReceivedSizeKey"]);
//                    double progass = receivedSize/expectedSize;
//
//                    if (progass-_progass>0.01f||1==progass) {    //和上次update比较，小于0.01忽略
//
//                        _progass = progass;
////                        [self showProgress:progass text:@"正在下载"];
//                    }
//                }
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusCancelled) {
//
//                NSLog(@"状态为: %@", @"取消下载");
//
//                _progass = 0;
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusCompleted) {
//
//                NSLog(@"状态为: %@", @"下载完成");
//
//                _progass = 0;
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusUnzip) {
//
//                NSLog(@"状态为: %@", @"下载完成，正在解压缩");
//
//                _progass = 0;
////                [self showIndeterminate:@"正在解压"];
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusError) {
//
//                NSLog(@"状态为: %@", @"下载错误");
//
//                _progass = 0;
////                [self showError:@"下载失败"];
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusFinished) {
//
//                NSLog(@"状态为: %@", @"全部完成");
//
//                _progass = 0;
////                [self showSuccess:@"安装完成"];
//
//                [_tableView reloadData];
//                PostNotification(@"reloadMap");
//            }
//        });
//    }];
}

- (void)pause:(MAOfflineItem *)item
{
    NSLog(@"pause :%@", item.name);
    
    [[MAOfflineMap sharedOfflineMap] pauseItem:item];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (!buttonIndex) {
        
        if (OfflineMapSheetTagDown==actionSheet.tag) {
            
            NSArray *array;
            if (!_selectIndexPath.section) {
                
                array = @[[MAOfflineMap sharedOfflineMap].nationWide];
            }else {
                
                array = [MAOfflineMap sharedOfflineMap].cities;
            }
            MAOfflineItem *item = array[_selectIndexPath.row];
            [self download:item];
        }else {
            
            [[MAOfflineMap sharedOfflineMap] clearDisk];
            [_tableView reloadData];
            PostNotification(@"reloadMap");
        }
    }
}

@end
