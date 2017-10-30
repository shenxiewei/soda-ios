//
//  AboutUsViewController.m
//  JoyMove
//
//  Created by ethen on 15/4/23.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "AboutUsViewController.h"
#import "OfflineMapViewController.h"
#import "OrderData.h"
#import "Config.h"

@interface AboutUsViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *_tableView;
    
    NSArray *_titleArray;
    NSArray *_contentArray;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //获取Version和Build
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *versionAndBuild = [NSString stringWithFormat:@"%@", appVersion];

    _titleArray =       @[@"官方微博", @"微信公众号", @"官方网址", @"客服热线", @"客服邮箱", @"当前版本"];
    _contentArray =     @[@"苏打出行", @"Soda苏打出行", @"http://sodacar.com", serviceTelephone, @"service@sodacar.com", versionAndBuild];
    
    [self initUI];
    [self initNavigationItem];
}

#pragma mark - UI

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIImage *headerImage = UIImageName(@"aboutHeader");
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+30, headerImage.size.width, 64+30+headerImage.size.height)];
    headerImageView.image = headerImage;
    headerImageView.contentMode = UIViewContentModeCenter;
    _tableView.tableHeaderView = headerImageView;
    headerImageView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    label.text = @"苏打（北京）交通网络科技有限公司";
    label.textColor = UIColorFromRGB(165, 164, 164);
    label.font = UIFontFromSize(14);
    label.textAlignment = NSTextAlignmentCenter;
    _tableView.tableFooterView = label;
}

- (void)initNavigationItem {
    
    self.title = NSLocalizedString(@"关于我们", nil);
    [self setNavBackButtonStyle:BVTagBack];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titleArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 40;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = UIFontFromSize(14);
        cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.font = UIFontFromSize(14);
        cell.detailTextLabel.textColor = UIColorFromRGB(120, 120, 120);
    }
    
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.detailTextLabel.text = _contentArray[indexPath.row];
    
    return cell;
}

@end
