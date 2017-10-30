//
//

#import <UIKit/UIKit.h>
typedef void(^AdressBlock) (NSString *province,NSString *city,NSString *town);

@interface AddressPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,copy)AdressBlock block;

//@property (copy,nonatomic) void (^isFirstStart)(NSString *province,NSString *city,NSString *town);


+ (instancetype)shareInstance;


@end
