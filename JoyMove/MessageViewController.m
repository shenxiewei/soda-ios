//
//  MessageViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/31.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "MessageCellMode.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UILabel *_messageWaiteLabel;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self initData];
//    [self requstForMessage];
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

#pragma mark - UI 

- (void)initUI {

    self.title = @"最新活动";
    [self setNavBackButtonStyle:BVTagBack];
    [self setNavBackButtonTitle:@""];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor = KBackgroudColor;
    _messageWaiteLabel = [[UILabel alloc]init];
    _messageWaiteLabel.frame = CGRectMake(0, 0, kScreenWidth, 50);
    _messageWaiteLabel.tag = 111;
    _messageWaiteLabel.text = @"暂无更多消息";
    _messageWaiteLabel.textColor = UIColorFromRGB(200, 200, 200);
    _messageWaiteLabel.textAlignment = NSTextAlignmentCenter;
    _messageWaiteLabel.font = UIFontFromSize(14);
    [backgroundView addSubview:_messageWaiteLabel];
    _tableView.backgroundView = backgroundView;
}

#pragma mark - initData

- (void)initData {

    _dataArray = [[NSMutableArray alloc] init];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray ? _dataArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [[MessageCell alloc] init];
    cell.message = [[_dataArray objectAtIndex:indexPath.section] message];
    return cell.height+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellName";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MessageCellMode *messageMode = [_dataArray objectAtIndex:indexPath.section];
    cell.message = messageMode.message;
    cell.date = messageMode.date;
    [cell updateMessageCells];
    return cell;
}

#pragma mark - requst

- (void)requstForMessage {

    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlToObtainMessage) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (10000 == result)
            {
                for (NSDictionary *dic in response[@"messages"]) {
                
                    MessageCellMode *cellMode = [[MessageCellMode alloc] initWithDitionary:dic];
                    [_dataArray addObject:cellMode];
                }
                if ([_dataArray count]) {
                    
                    _messageWaiteLabel.text = @"";
                }else {
                
                    _messageWaiteLabel.text = @"暂无更多消息";
                }
                [_tableView reloadData];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
            
                _messageWaiteLabel.text = response[@"errMsg"];
            }
        }else {
        
            _messageWaiteLabel.text = JMMessageNetworkError;
        }
    }];
}

//假数据
- (void)loadDataArray {

    for (int i=0; i<1; i++) {
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        NSDictionary *dic = @{@"type":@"0",@"messageDate":@(timeInterval),@"content":@"欢迎使用苏打出行。苏打科技与诸多新能源汽车厂商合作，打造为共享而生的智能汽车，缓解城市拥堵，满足短线即时出行需求。这是一款杀手级的移动应用，按分钟计费，实现都市内的自由移动。"};
        MessageCellMode *cellMode = [[MessageCellMode alloc] initWithDitionary:dic];
        [_dataArray addObject:cellMode];
        _messageWaiteLabel.text = @"";
    }
    [_tableView reloadData];
}

@end
