//
//  BalanceDetailTBViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "BalanceDetailTBViewModel.h"
#import "BalanceRecordModel.h"

#import "LXRequest.h"
#import "Macro.h"

@interface BalanceDetailTBViewModel()

@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation BalanceDetailTBViewModel

- (void)sdc_initialize
{
    self.currentPage = 0;
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id data) {
        @strongify(self)
        
        self.currentPage = 0;
        [self.dataArray removeAllObjects];
        [self.dataArray removeAllObjects];
        
        NSArray *tempArray = data[@"records"];
        
        for (NSDictionary *dict in tempArray) {
            BalanceRecordModel *model = [[BalanceRecordModel alloc] initWithParams:dict];
            [self.dataArray addObject:model];
        }
        
        [self.refreshUISubject sendNext:nil];
        if (tempArray.count <= 10 || !tempArray) {
            [self.refreshEndSubject sendNext:@(SDCFooterRefresh_HasNoMoreData)];
        }else
        {
            [self.refreshEndSubject sendNext:@(SDCFooterRefresh_HasMoreData)];
        }
    }];
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id data) {
        @strongify(self)
        
        NSArray *tempArray = data[@"records"];
        for (NSDictionary *dic in tempArray) {
            BalanceRecordModel *model = [[BalanceRecordModel alloc] initWithParams:dic];
            [self.dataArray addObject:model];
        }
        
        [self.refreshUISubject sendNext:nil];
        if (tempArray.count < 10 || !tempArray) {//没有更多数据了
            [self.refreshEndSubject sendNext:@(SDCFooterRefresh_HasNoMoreData)];
        }else
        {
            [self.refreshEndSubject sendNext:@(SDCFooterRefresh_HasMoreData)];
        }
    }];
}

- (RACCommand *)refreshDataCommand
{
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                NSDictionary *params = @{@"skip":@(0),
                                         @"limit":@10};
                [LXRequest requestWithJsonDic:params andUrl:kURL(kUrlBalanceDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (success) {
                        if (result == JMCodeSuccess) {
                            //成功加载数据
                            [subscriber sendNext:response];
                        }
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand
{
    if (!_nextPageCommand) {
        @weakify(self)
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPage ++;
                NSDictionary *params = @{@"skip":@(self.currentPage),
                                         @"limit":@10};
                [LXRequest requestWithJsonDic:params andUrl:kURL(kUrlBalanceDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (success) {
                        if (result == JMCodeSuccess) {
                            //成功加载数据
                            [subscriber sendNext:response];
                        }else
                        {
                             self.currentPage -- ;
                        }
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageCommand;
}

- (RACSubject *)refreshUISubject
{
    if (!_refreshUISubject) {
        _refreshUISubject = [[RACSubject alloc] init];
    }
    return _refreshUISubject;
}

- (RACSubject *)refreshEndSubject
{
    if (!_refreshEndSubject) {
        _refreshEndSubject = [[RACSubject alloc] init];
    }
    return _refreshEndSubject;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
