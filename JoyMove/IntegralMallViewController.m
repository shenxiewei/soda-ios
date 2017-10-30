//
//  IntegralMallViewController.m
//  JoyMove
//
//  Created by cty on 15/12/15.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "IntegralMallViewController.h"
#import "IntegralMallCell.h"
#import "IntegralMallCellModel.h"
#import "LXRequest.h"
#import "UtilsMacro.h"

@interface IntegralMallViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIButton *_leftButton;
    NSMutableArray *_dataArray;
    NSArray *_backImageArray;
    //总积分label
    UILabel *_aggregateScoreLabel;
    UILabel *_loadLabel;
    UILabel *_lineLabel;
    //总分后面的图
    UIImageView *_integralImage;
    //积分总分
    NSNumber *_totalIntegral;
    //商品id
    NSString *_productId;
    //小菊花
    UIActivityIndicatorView *_loadActivityIndicator;
    //底部白色背景
    UIView *_backWhiteView;
    //加锁（防止用户多次点击，再一次点击回来之前再次点击不起作用）
    BOOL _isSuccess;
}
@end

@implementation IntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isSuccess=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    _dataArray=[[NSMutableArray alloc]init];
    _backImageArray=@[@"CommodityIntegralFirst",@"CommodityIntegralSecond",@"CommodityIntegralThird",@"CommodityIntegralFourth"];
    
    [self initNavigationItem];
    [self initUI];
    [self requestURL];
   
}

#pragma mark - UI

- (void)initNavigationItem {
    
    self.title = NSLocalizedString(@"Points Mall", nil);
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -15;
    
    _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _leftButton];
    self.navigationItem.leftBarButtonItems = @[leftSpacer, leftButtonItem];
}

-(void)initUI
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    _backWhiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-104)];
    _backWhiteView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backWhiteView];
    
    _loadLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.0/375*kScreenWidth, 64+15, kScreenWidth/2.0, 12.5)];
    _loadLabel.text=NSLocalizedString(@"Loading...", nil);
    _loadLabel.textColor=[UIColor colorWithRed:0.525f green:0.525f blue:0.533f alpha:1.00f];
    _loadLabel.hidden=NO;
    _loadLabel.font=[UIFont systemFontOfSize:15];
    _loadLabel.textColor=[UIColor blackColor];
    _loadLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:_loadLabel];
    
    _loadActivityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadActivityIndicator.center=CGPointMake(kScreenWidth/2.0+22.0/375*kScreenWidth, _loadLabel.frame.origin.y+6);
    [_loadActivityIndicator startAnimating];
    [self.view addSubview:_loadActivityIndicator];
    
    _aggregateScoreLabel=[[UILabel alloc]init];
    _aggregateScoreLabel.font=[UIFont systemFontOfSize:15];
    _aggregateScoreLabel.textColor=[UIColor blackColor];
    _aggregateScoreLabel.numberOfLines=0;
    _aggregateScoreLabel.hidden=YES;
    [self.view addSubview:_aggregateScoreLabel];
    
    _lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 64+41, kScreenWidth, 1)];
    _lineLabel.backgroundColor=UIColorFromSixteenRGB(0xd5d5d5);
    _lineLabel.hidden=YES;
    [self.view addSubview:_lineLabel];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+41+1, kScreenWidth, kScreenHeight-64-41-1)];
    _tableView.hidden=YES;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
}

#pragma mark - UPDateUI
-(void)refreshUI
{
    _backWhiteView.hidden=YES;
    _tableView.hidden=NO;
    NSString *isNil=[NSString stringWithFormat:@"%@",_totalIntegral];
    if (isNil.length>0 && ![isNil isEqualToString:@"<null>"])
    {
        _loadLabel.hidden=YES;
        _loadActivityIndicator.hidden=YES;
        
        _aggregateScoreLabel.text=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"You currently have" , nil), _totalIntegral];
        CGFloat textW = [_aggregateScoreLabel.text sizeWithAttributes:@{NSFontAttributeName : _aggregateScoreLabel.font}].width;
        _aggregateScoreLabel.hidden=NO;
        [_aggregateScoreLabel setFrame:CGRectMake(17, 64+15, textW, 12.5)];
        
        _integralImage=[[UIImageView alloc]initWithFrame:CGRectMake(_aggregateScoreLabel.frame.origin.x+_aggregateScoreLabel.frame.size.width+7, _aggregateScoreLabel.frame.origin.y, 11, 13)];
        _integralImage.image=[UIImage imageNamed:@"CommodityIntegralTitleImage"];
        _integralImage.hidden=NO;
        [self.view addSubview:_integralImage];
    }
    [_tableView reloadData];
}

-(void)refreshTotal
{
    NSString *isNil=[NSString stringWithFormat:@"%@",_totalIntegral];
    if (isNil.length>0 && ![isNil isEqualToString:@"<null>"])
    {
        _aggregateScoreLabel.text=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"You currently have" , nil), _totalIntegral];
        CGFloat textW = [_aggregateScoreLabel.text sizeWithAttributes:@{NSFontAttributeName : _aggregateScoreLabel.font}].width;
        [_aggregateScoreLabel setFrame:CGRectMake(17, 64+15, textW, 12.5)];
        
        if (!_integralImage)
        {
           _integralImage=[[UIImageView alloc]init];
        }
        _integralImage.frame=CGRectMake(_aggregateScoreLabel.frame.origin.x+_aggregateScoreLabel.frame.size.width+7, _aggregateScoreLabel.frame.origin.y, 11, 13);
//        _integralImage=[[UIImageView alloc]initWithFrame:CGRectMake(_aggregateScoreLabel.frame.origin.x+_aggregateScoreLabel.frame.size.width+7, _aggregateScoreLabel.frame.origin.y, 11, 13)];
        _integralImage.image=[UIImage imageNamed:@"CommodityIntegralTitleImage"];
        [self.view addSubview:_integralImage];
    }
}

#pragma mark - Action
-(void)buttonClicked:(UIButton *)sender
{
    if (sender==_leftButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self requestPoints:_productId];
    }
}

#pragma mark - UITableViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"integralMallCell";
    IntegralMallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[IntegralMallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle: NO];
    }
    
    if (indexPath.row<_dataArray.count)
    {
        IntegralMallCellModel *integralMallCellModel = [_dataArray objectAtIndex:indexPath.row];
        cell.moneyLabel.text= integralMallCellModel.name;
        cell.timeLabel.text=integralMallCellModel.desc;
        cell.integralLabel.text=[NSString stringWithFormat:@"%@",integralMallCellModel.points];
    }
    if (indexPath.row<_backImageArray.count)
    {
        cell.backImage.image=[UIImage imageNamed:_backImageArray[indexPath.row]];
    }
    else
    {
        cell.backImage.image=[UIImage imageNamed:_backImageArray[0]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_dataArray.count)
    {
        IntegralMallCellModel *integralMallCellModel = [_dataArray objectAtIndex:indexPath.row];
        _productId=[NSString stringWithFormat:@"%@",integralMallCellModel.goodsId];
        UIAlertView *promptBox = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Are you sure to exchange this?", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Exchange", nil), nil];
        [promptBox show];
    }
    
    
}


#pragma mark - requst

-(void)requestURL
{
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(KUrlConvertibleGoods) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (result == JMCodeSuccess)
            {
                for (NSDictionary *dic in response(@"goods")) {
                    IntegralMallCellModel *model = [[IntegralMallCellModel alloc] initWithDictionary:dic];
                    [_dataArray addObject:model];
                    
                }
                _totalIntegral=response[@"total"];
                [self refreshUI];
              
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
//                NSString *message = response[@"errMsg"];
//                message = message&&message.length?message:JMMessageNoErrMsg;
            }
        }else{
            
        }
    }];
}

-(void)requestPoints:(NSString *)productId
{
    NSDictionary *dic;
    dic = @{
            @"goodsId":productId,
            };
    if (_isSuccess==YES)
    {
        _isSuccess=NO;
        [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlPoints) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
            
            if (success) {
                
                if (result == JMCodeSuccess) {
                    
                    _isSuccess=YES;
                    [self showSuccess:NSLocalizedString(@"Exchange Success", nil)];
                    _totalIntegral=response[@"total"];
                    [self refreshTotal];
                    
                }
                else if (result==12000)
                {
                    [self createNoNetWorkViewWithReloadBlock:^{
                        
                    }];
                }
                else
                {
                    _isSuccess=YES;
                    [self showError:response[@"msg"]];
                }
            }else{
                _isSuccess=YES;
                [self showError:NSLocalizedString(@"Exchange Failed", nil)];
            }
        }];
    }
    
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

@end
