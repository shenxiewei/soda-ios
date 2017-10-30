//
//

#import "AddressPickView.h"
#import "Macro.h"
#import "UIViewExt.h"


#define navigationViewHeight 44.0f
#define pickViewViewHeight 200.0f
#define buttonWidth 60.0f

@interface AddressPickView ()


{
    BOOL _isFirst;
}

@property(nonatomic,strong)NSDictionary *pickerDic;
@property(nonatomic,strong)NSArray *provinceArray;
@property(nonatomic,strong)NSArray *selectedArray;
@property(nonatomic,strong)NSArray *cityArray;
@property(nonatomic,strong)NSArray *townArray;
@property(nonatomic,strong)UIView *bottomView;//包括导航视图和地址选择视图
@property(nonatomic,strong)UIPickerView *pickView;//地址选择视图
@property(nonatomic,strong)UIView *navigationView;//上面的导航视图

#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

@end

@implementation AddressPickView
+ (instancetype)shareInstance
{
    
    static AddressPickView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AddressPickView alloc] init];
    });
    
    [shareInstance showBottomView];
    
    
    return shareInstance;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self _addTapGestureRecognizerToSelf];
        [self _getPickerData];
        [self _createView];
    }
    
    _isFirst=YES;
    
    return self;
  
}
#pragma mark - get data
- (void)_getPickerData
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
-(void)_addTapGestureRecognizerToSelf
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}
-(void)_createView
{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight)];
    [self addSubview:_bottomView];
    //导航视图
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, navigationViewHeight)];
    _navigationView.backgroundColor = UIColorFromSixteenRGB(0xf0f0f0);
    [_bottomView addSubview:_navigationView];
    //这里添加空手势不然点击navigationView也会隐藏,
    UITapGestureRecognizer *tapNavigationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_navigationView addGestureRecognizer:tapNavigationView];
//    NSArray *buttonTitleArray = @[@"取消",@"确定"];
    NSArray *buttonTitleArray = @[@"完成"];
    for (int i = 0; i <buttonTitleArray.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i*(kScreenWidth-buttonWidth), 0, buttonWidth, navigationViewHeight);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_navigationView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, navigationViewHeight, kScreenWidth, pickViewViewHeight)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.dataSource = self;
    _pickView.delegate =self;
    [_bottomView addSubview:_pickView];
    
    
    
    
    
    
}
-(void)tapButton:(UIButton*)button
{
    //点击确定回调block
//    if (button.tag == 1) {
//        
//        NSString *province = [self.provinceArray objectAtIndex:[_pickView selectedRowInComponent:0]];
//        NSString *city = [self.cityArray objectAtIndex:[_pickView selectedRowInComponent:1]];
//        NSString *town = [self.townArray objectAtIndex:[_pickView selectedRowInComponent:2]];
//        
//        _block(province,city,town);
//    }
    
    [self hiddenBottomView];

    
}
-(void)showBottomView
{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottomView.top = kScreenHeight-navigationViewHeight-pickViewViewHeight;
        
        
        
        self.backgroundColor = windowColor;
    } completion:^(BOOL finished) {

    }];
}
-(void)hiddenBottomView
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.top = kScreenHeight;
        
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}


#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray.count;
    } else if (component == 1) {
        return _cityArray.count;
    } else {
        return _townArray.count;
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lable=[[UILabel alloc]init];
    
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:16.0f];
    
    if (component == 0) {
        lable.text=[self.provinceArray objectAtIndex:row];
        
    } else if (component == 1) {
        lable.text=[self.cityArray objectAtIndex:row];
        lable.adjustsFontSizeToFitWidth=YES;
        
    } else {
        lable.text=[self.townArray objectAtIndex:row];
        lable.adjustsFontSizeToFitWidth=YES;
    }
    
    

    return lable;
    
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat pickViewWidth = kScreenWidth/3;
    
    return pickViewWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
    if (component == 0)
    {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
        
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1)
    {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    if (component==2)
    {
        
    }
    
    [pickerView reloadComponent:2];
    
    NSString *province = [self.provinceArray objectAtIndex:[_pickView selectedRowInComponent:0]];
    NSString *city = [self.cityArray objectAtIndex:[_pickView selectedRowInComponent:1]];
    NSString *town;
    if (self.townArray.count>0 &&  [_pickView selectedRowInComponent:2]<self.townArray.count)
    {
         town = [self.townArray objectAtIndex:[_pickView selectedRowInComponent:2]];
    }
    else
    {
        town=@"";
    }
   
    _block(province,city,town);
    
//    NSString *allString=[NSString stringWithFormat:@"%@  %@  %@",province,city,town];
//    
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:allString,@"textOne", nil];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"pushTextViewText" object:nil userInfo:dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    NSString *province = [self.provinceArray objectAtIndex:[_pickView selectedRowInComponent:0]];
//    NSString *city = [self.cityArray objectAtIndex:[_pickView selectedRowInComponent:1]];
//    NSString *town = [self.townArray objectAtIndex:[_pickView selectedRowInComponent:2]];
//    if (_isFirst==YES)
//    {
//        if(self.isFirstStart)
//        {
//            self.isFirstStart(province,city,town);
//        }
//    }
//    
//    NSString *province1 = [self.provinceArray objectAtIndex:0];
//    NSString *city1 = [self.cityArray objectAtIndex:0];
//    NSString *town1 = [self.townArray objectAtIndex:0];
//    NSString *allString1=[NSString stringWithFormat:@"%@  %@  %@",province1,city1,town1];
//    
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:allString1,@"textOne", nil];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"pushTextViewText" object:nil userInfo:dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


@end
