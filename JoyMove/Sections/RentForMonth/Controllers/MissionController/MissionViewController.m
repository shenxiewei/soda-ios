//
//  MissionViewController.m
//  JoyMove
//
//  Created by Soda on 2017/10/20.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MissionViewController.h"

#import "MissionWebViewModel.h"
#import "TabShareViewModel.h"

#import "SVProgressHUD.h"

#import "MyCar.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FMShare.h"

@interface MissionViewController ()<UIWebViewDelegate>

@property(strong, nonatomic) MissionWebViewModel *viewModel;
@property(strong, nonatomic) TabShareViewModel *tabShareViewModel;

@property(strong, nonatomic) NSDictionary *shareMissionParams;
@property(strong, nonatomic) NSString *shareMissionCallback;

@end

@implementation MissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JMWeakSelf(self);
    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
   
    [self loadUrl:@"http://static.sodacar.com/task/pages/task.html"];
    
    [self registerNofification];
    [self sdc_bindViewModel];
    
    //加载数据
    JSContext *context = [self.myWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"getUserTaskList"] = ^(NSString *method)
    {
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",method,[weakself DataTOjsonString:self.missions]];
        [[JSContext currentContext] evaluateScript:jsStr];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sdc_bindViewModel
{

}
#pragma mark - notification
- (void)registerNofification
{
    JMWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kShareCompleteNotification object:nil] subscribeNext:^(id x) {
        NSNotification *lNotification = (NSNotification *)x;
        SSDKResponseState state = [lNotification.object integerValue];
        if (state == SSDKResponseStateSuccess) {
            
            [weakself completeMissionWithParams:self.shareMissionParams callbackName:self.shareMissionCallback];
        }
    }];
}

#pragma mark - private
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - WebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView //html加载完后触发
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
     [self addCustomAction];

}

#pragma mark - private
- (void)shareCar
{
    [FMShare shareRentForMonthActivityURL:[NSString stringWithFormat:@"%@?id=%@&carId=%@",kUrlShareCarHtml,[MyCar shareIntance].retalID,[MyCar shareIntance].vimNum] title:@"免费领车体验劵" content:[NSString stringWithFormat:@"苏打智能共享车(%@)，我“享”你，包险包养，你只负责开，剩下我们来！",[MyCar shareIntance].licenseNum] image:@"http://static.sodacar.com/package/wxShareIcon.jpg#"];
}

- (void)shareInvitation
{
    NSDictionary *json = self.shareMissionParams[@"userTask"][@"detail"];
    [FMShare shareInviteCode:json[@"invitationCode"]];
}

- (void)addCustomAction
{
    JMWeakSelf(self);
    JSContext *context = [self.myWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //获取单个任务更新
    context[@"getOneTaskData"] = ^(NSString *missionID,NSString *method)
    {
        [weakself updateTaskInfo:missionID callbackName:method];
    };
    
    //领取奖励
    context[@"receiveRewardsNative"] = ^(NSString *userTaskId,NSString *method,NSString *taskID) {
        [weakself getMissionRewardUserTaskID:userTaskId callbackName:method taskID:taskID];
    };
    
    //小白课堂
    context[@"showClassroomPage"] = ^(NSDictionary *params,NSString *method)
    {
        [weakself completeMissionWithParams:params callbackName:method];
    };
    
    //微信、QQ分享
    context[@"wechatShare"] = ^(NSDictionary *params,NSString *method)
    {
        self.shareMissionCallback = method;
        self.shareMissionParams = params;
        NSString *code = params[@"code"];
        if ([code isEqualToString:@"shareCar"] ||
            [code isEqualToString:@"daily_shareCar"]) {
            [weakself shareCar];
        }

        if ([code isEqualToString:@"invitation"] ||
           [code isEqualToString:@"daily_invitation"]) {
            [weakself shareInvitation];
        }
    };
    
    //开启分享车辆
    context[@"changeSwitch"] = ^(NSString *missionID,NSInteger status,NSString *method)
    {
        [weakself firstShareCarMission:missionID callbackName:method];
    };
}
#pragma mark - private
//完成分享车辆任务
- (void)firstShareCarMission:(NSString *)missionID callbackName:(NSString *)callbackName
{
 
    if (missionID == nil || callbackName == nil) {
        [SVProgressHUD showErrorWithStatus:@"未知错误" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    @weakify(self)
    [[self.tabShareViewModel.shareCarCommand execute:nil] subscribeNext:^(NSDictionary *response) {
       @strongify(self)
        
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@,%@)",callbackName,[self DataTOjsonString:response],missionID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        });
    } error:^(NSError *error) {
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@,%@)",callbackName,@"0",@"error"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        });
    }];
    

}

//完成任务其他
- (void)completeMissionWithParams:(NSDictionary *)params callbackName:(NSString *)callbackName
{
    if (params == nil || callbackName == nil) {
        [SVProgressHUD showErrorWithStatus:@"未知错误" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    @weakify(self)
    NSDictionary *dict = @{@"taskId":params[@"id"],@"userPackageId":[MyCar shareIntance].retalID};
    [[self.viewModel.completeTaskCommand execute:dict] subscribeNext:^(id x) {
        @strongify(self)
        
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@,%@)",callbackName,@"1",params[@"id"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        });
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([params[@"code"] isEqualToString:@"learn"]) {
                UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"SodaClass" actionName:@"sodaClassViewController" params:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        });
        
        
        
    } error:^(NSError *error) {
        
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@,%@)",callbackName,@"0",@"error"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        });
    }];
}

//领取奖励
- (void)getMissionRewardUserTaskID:(NSString *)userTaskID callbackName:(NSString *)callbackName taskID:(NSString *)taskID
{
    if (userTaskID == nil || callbackName == nil || taskID == nil)  {
        [SVProgressHUD showErrorWithStatus:@"未知错误" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    @weakify(self)
    NSDictionary *dict = @{@"userTaskId":userTaskID,@"userPackageId":[MyCar shareIntance].retalID};
    [[self.viewModel.getRewardCommand execute:dict] subscribeNext:^(NSDictionary *params) {
        @strongify(self)
        
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@,%@,%@)",callbackName,[self DataTOjsonString:params],userTaskID,taskID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        });
    } error:^(NSError *error) {
        
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@,%@)",callbackName,@"0",@"error"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        });
    }];
}

//更新单条任务
- (void)updateTaskInfo:(NSString *)missionID callbackName:(NSString *)callbackName
{
    if (missionID == nil || callbackName == nil) {
        [SVProgressHUD showErrorWithStatus:@"未知错误" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [[self.viewModel.getOneTaskCommand execute:@{@"userPackageId":[MyCar shareIntance].retalID,@"taskId":missionID}] subscribeNext:^(NSDictionary *params) {
        //刷新数据
        
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",callbackName,[self DataTOjsonString:params]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        });
        
    }];
}
#pragma mark - lazyLoad
- (MissionWebViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[MissionWebViewModel alloc] init];
    }
    return _viewModel;
}
- (TabShareViewModel *)tabShareViewModel
{
    if(!_tabShareViewModel)
    {
        _tabShareViewModel = [[TabShareViewModel alloc] init];
    }
    return _tabShareViewModel;
}
@end
