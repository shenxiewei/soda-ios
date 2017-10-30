//
//  DepBillDetailViewController.m
//  JoyMove
//
//  Created by Soda on 2017/3/9.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "DepBillDetailViewController.h"
#import "TradeDetailTableViewCell.h"

@interface DepBillDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *amoutLbl;
@property (weak, nonatomic) IBOutlet UILabel *tradeLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@end

@implementation DepBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.baseView removeFromSuperview];
    self.title = @"账单详情";
    [self setNavBackButtonStyle:BVTagBack];
    
    TradeModel *model = [TradeModel groupWithDict:self.params];
    self.amoutLbl.text = [NSString stringWithFormat:@"%.2f 元",model.amount];
    self.tradeLbl.text = model.typeString;
    
    
    
//    NSString *detailString = self.params[@"detail"];
//    NSData *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    self.refundID = tempDict[@"refundId"];
//    NSData *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.descriptionLbl.text = self.params[@"description"];
//    self.tradeNoLbl.text = tempDict[@"transactionId"];
    self.timeLbl.text = [NSString stringWithFormat:@"创建时间 %@",model.timeString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
