//
//  RankingViewController.m
//  JoyMove
//
//  Created by 赵霆 on 16/6/8.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "RankingViewController.h"
#import "RankingModel.h"
#import "FDSlideBar.h"
#import "RankingCell.h"

@interface RankingViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) FDSlideBar *slideBar;
@property (strong, nonatomic) UITableView *tableViewFirst;
@property (strong, nonatomic) UITableView *tableViewSecond;
@property (strong, nonatomic) UIScrollView *scrollView;
// 当前选中页数
@property (assign, nonatomic) NSInteger currentPage;
// 日数据和周数据
@property (strong, nonatomic) NSMutableArray *dayRankingArray;
@property (strong, nonatomic) NSMutableArray *weekRankingArray;
// 底部view数据model
@property (strong, nonatomic) RankingModel *personalDay;
@property (strong, nonatomic) RankingModel *personalWeek;
@property (strong, nonatomic) UIImageView *personalImg;
@property (strong, nonatomic) UILabel *rankingLabel;
// 两个tableView数据页数
@property (assign, nonatomic) NSInteger pageCountFirst;
@property (assign, nonatomic) NSInteger pageCountSecond;
// 底部查看更多
@property (strong, nonatomic) UIButton *loadMoreBtn;
@property (strong, nonatomic) UIActivityIndicatorView *juhua;
@property (strong, nonatomic) UIButton *loadMoreBtnSec;
@property (strong, nonatomic) UIActivityIndicatorView *juhuaSec;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"用车排行榜", nil);
    [self setNavBackButtonStyle:BVTagBack];

    self.currentPage = 0;
    // 默认点击加载第1页
    self.pageCountFirst = 1;
    self.pageCountSecond = 1;
    
    [self setupSlideBar];
    [self setupScrollView];
    [self setupTableView];
    [self setupBottomView];
    [self requestRankingWithDic:@{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 懒加载数据数组
- (NSMutableArray *)dayRankingArray
{
    if (!_dayRankingArray) {
        _dayRankingArray = [[NSMutableArray alloc] init];
    }
    return _dayRankingArray;
}
- (NSMutableArray *)weekRankingArray
{
    if (!_weekRankingArray) {
        _weekRankingArray = [[NSMutableArray alloc] init];
    }
    return _weekRankingArray;
}

#pragma mark - Private
- (void)setupSlideBar {
    FDSlideBar *sliderBar = [[FDSlideBar alloc] init];
    sliderBar.backgroundColor = [UIColor whiteColor];
    
    sliderBar.itemsTitle = @[NSLocalizedString(@"Today", nil), NSLocalizedString(@"This week", nil)];
    
    sliderBar.itemColor = [UIColor blackColor];
    sliderBar.itemSelectedColor = [UIColor colorWithRed:246 / 255.0 green:105 / 255.0 blue:77 / 255.0 alpha:1.0];
    sliderBar.sliderColor = [UIColor colorWithRed:246 / 255.0 green:105 / 255.0 blue:77 / 255.0 alpha:1.0];
    
    [sliderBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        
        self.currentPage = idx;
        [self.scrollView setContentOffset:CGPointMake(idx * kScreenWidth, 0) animated:NO];
        [self updateBottomView];

    }];
    [self.view addSubview:sliderBar];
    _slideBar = sliderBar;
    
}

- (void)setupTableView {
    // 今日和本周
    self.tableViewFirst = [[UITableView alloc] init];
    self.tableViewFirst.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - CGRectGetMaxY(self.slideBar.frame));
    self.tableViewFirst.delegate = self;
    self.tableViewFirst.dataSource = self;
    [self.scrollView addSubview:self.tableViewFirst];
    
    self.tableViewSecond = [[UITableView alloc] init];
    self.tableViewSecond.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - CGRectGetMaxY(self.slideBar.frame));
    self.tableViewSecond.delegate = self;
    self.tableViewSecond.dataSource = self;
    [self.scrollView addSubview:self.tableViewSecond];

    // 查看更多
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    self.loadMoreBtn = [[UIButton alloc] init];
    self.loadMoreBtn.frame = CGRectMake(0, 10, kScreenWidth, 20);
    [self.loadMoreBtn setTitle:NSLocalizedString(@"Read more", nil) forState:UIControlStateNormal];
    [self.loadMoreBtn setTitleColor:UIColorFromSixteenRGB(0x868686) forState:UIControlStateNormal];
    self.loadMoreBtn.titleLabel.font = UIFontFromSize(14);
    [self.loadMoreBtn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.loadMoreBtn];
    // 转菊花
    self.juhua = [[UIActivityIndicatorView alloc] init];
    self.juhua.frame = CGRectMake(kScreenWidth * 0.5 - 5, 15, 10, 10);
    self.juhua.hidesWhenStopped = YES;
    self.juhua.hidden = YES;
    [footerView addSubview:self.juhua];
    
    UIView *footerViewSec = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    self.loadMoreBtnSec = [[UIButton alloc] init];
    self.loadMoreBtnSec.frame = CGRectMake(0, 10, kScreenWidth, 20);
    [self.loadMoreBtnSec setTitle:NSLocalizedString(@"Read more", nil) forState:UIControlStateNormal];
    [self.loadMoreBtnSec setTitleColor:UIColorFromSixteenRGB(0x868686) forState:UIControlStateNormal];
    self.loadMoreBtnSec.titleLabel.font = UIFontFromSize(14);
    [self.loadMoreBtnSec addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    [footerViewSec addSubview:self.loadMoreBtnSec];
    // 转菊花
    self.juhuaSec = [[UIActivityIndicatorView alloc] init];
    self.juhuaSec.frame = CGRectMake(kScreenWidth * 0.5 - 5, 15, 10, 10);
    self.juhuaSec.hidesWhenStopped = YES;
    self.juhuaSec.hidden = YES;
    [footerViewSec addSubview:self.juhuaSec];
    
    self.tableViewFirst.tableFooterView = footerView;
    self.tableViewSecond.tableFooterView = footerViewSec;

}

- (void)loadMore
{
    // 点击查看更多发送对应请求
    if(self.currentPage == 0){
        
        self.juhua.hidden = NO;
        [self.juhua startAnimating];
        self.loadMoreBtn.hidden = YES;
        
        self.pageCountFirst = self.pageCountFirst + 1;
        [self requestRankingWithDic:@{@"page": @(self.pageCountFirst)}];
    }else{
        
        self.juhuaSec.hidden = NO;
        [self.juhuaSec startAnimating];
        self.loadMoreBtnSec.hidden = YES;
        
        self.pageCountSecond = self.pageCountSecond + 1;
        [self requestRankingWithDic:@{@"type": @"week", @"page": @(self.pageCountSecond)}];
    }
    
}

- (void)setupScrollView{
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.slideBar.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.slideBar.frame));
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - CGRectGetMaxY(self.slideBar.frame));
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.slideBar.frame), kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [self.view addSubview:lineView];
    
}

- (void)setupBottomView{
    
    CGRect frame = CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64);
    UIView *bottomView = [[UIView alloc] initWithFrame:frame];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [bottomView addSubview:lineView];
    
    self.personalImg = [[UIImageView alloc] init];
    self.personalImg.frame = CGRectMake(25, 9, 44, 44);
    self.personalImg.layer.cornerRadius = 22;
    self.personalImg.layer.masksToBounds = YES;
    [bottomView addSubview:self.personalImg ];
    
    self.rankingLabel = [[UILabel alloc] init];
    self.rankingLabel.frame = CGRectMake(CGRectGetMaxX(self.personalImg.frame) + 14, 0, 100, 64);
    self.rankingLabel.font = [UIFont systemFontOfSize:15];
    self.rankingLabel.adjustsFontSizeToFitWidth = YES;
    [bottomView addSubview:self.rankingLabel];
    
    UIButton *praiseBtn = [[UIButton alloc] init];
    praiseBtn.frame = CGRectMake(kScreenWidth - 106, 15, 88, 35);
    [praiseBtn setImage:[UIImage imageNamed:@"praiseBtn"] forState:UIControlStateNormal];
    [bottomView addSubview:praiseBtn];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableViewFirst) {

        return self.dayRankingArray.count;
    }else{

        return self.weekRankingArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *UITableViewCellIdentifier = @"cell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        
        cell = [[RankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
        [cell.contentView addSubview:lineView];
    }
    
    if (tableView == self.tableViewFirst) {
        cell.rankingModel = self.dayRankingArray[indexPath.row];
        return cell;
    }else{
        cell.rankingModel = self.weekRankingArray[indexPath.row];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Height retrun the width of screen
    return 69;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 跳转对应选项卡
    NSUInteger indexPath = self.scrollView.contentOffset.x / kScreenWidth;
    [self.slideBar selectSlideBarItemAtIndex:indexPath];
    self.currentPage = indexPath;
    [self updateBottomView];
}

// 切换是更新底部个人数据
- (void)updateBottomView
{
    
    NSString *ranking = @"";
    NSUInteger rankingLength = 0;
    if (_currentPage == 0) {
        
        [self.personalImg sd_setImageWithURL:[NSURL URLWithString:self.personalDay.photo] placeholderImage:[UIImage imageNamed:@"headerPlaceholder"]];
        ranking = self.personalDay.rank;
        rankingLength =  self.personalDay.rank.length;
    }else{
        [self.personalImg sd_setImageWithURL:[NSURL URLWithString:self.personalWeek.photo] placeholderImage:[UIImage imageNamed:@"headerPlaceholder"]];
        ranking = self.personalWeek.rank;
        rankingLength =  self.personalWeek.rank.length;
    }

    if ([ranking isEqualToString:@"0"]) {
        self.rankingLabel.text = NSLocalizedString(@"No trips", nil);
    }else{
        // 富文本修改颜色
        NSString *rankingString = [NSString stringWithFormat:@"我获得第%@名", ranking];
        NSMutableAttributedString *rankingColor = [[NSMutableAttributedString alloc] initWithString:rankingString];
        [rankingColor addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(246, 105, 77) range:NSMakeRange(4, rankingLength)];
        [rankingColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19]range:NSMakeRange(4, rankingLength)];
        self.rankingLabel.attributedText = rankingColor;
//        [self.rankingLabel sizeToFit];
    }
}

- (void)requestRankingWithDic:(NSDictionary *)dic
{
    // 周排行需要传type week，所以嵌套一次请求
    [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlUserRank) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            
            if (result == JMCodeSuccess) {
                
//                NSLog(@"11111-----%@", response);
                NSDictionary *personDic = response[@"own"];
                NSArray *RankArray = [[NSArray alloc] init];
                RankArray = response[@"ranks"];
                if ([dic[@"type"] isEqualToString:@"week"]) {
                    // 周排名数据及周个人数据
                    self.personalWeek = [[RankingModel alloc] initWithDictionary:personDic];
                    for (NSDictionary *dic in RankArray) {
                        RankingModel *rankingModel = [[RankingModel alloc] initWithDictionary:dic];
                        [self.weekRankingArray addObject:rankingModel];
                    }
                    // 小于20条不显示查看更多
                    if (RankArray.count < 20) {
                        self.loadMoreBtnSec.hidden = YES;
                    }else{
                        self.loadMoreBtnSec.hidden = NO;
                    }
                }else{
                    // 日排名数据及日个人数据
                    self.personalDay = [[RankingModel alloc] initWithDictionary:personDic];
                    for (NSDictionary *dic in RankArray) {
                        RankingModel *rankingModel = [[RankingModel alloc] initWithDictionary:dic];
                        [self.dayRankingArray addObject:rankingModel];
                    }
                    // 小于20条不显示查看更多
                    if (RankArray.count < 20) {
                        self.loadMoreBtn.hidden = YES;
                    }else{
                        self.loadMoreBtn.hidden = NO;
                    }
                    // 加载更多时不要请求周数据，只有第一次请求
                    if (self.pageCountFirst < 2) {
                        
                        [self requestRankingWithDic:@{@"type": @"week"}];
                    }
                    
                }
                
                [self.juhua stopAnimating];
                self.juhua.hidden = YES;
                [self.juhuaSec stopAnimating];
                self.juhuaSec.hidden = YES;
                
                // 刷新数据
                [self updateBottomView];
                [self.tableViewFirst reloadData];
                [self.tableViewSecond reloadData];
                
            }else if (result == JMCodeNeedLogin)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }else {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

@end

