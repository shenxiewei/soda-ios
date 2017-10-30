

#import <UIKit/UIKit.h>

typedef enum {
    
    VerticalAlignmentTop        = 0,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface Label : UILabel {
    
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

