//
//  MessageCell.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/31.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "MessageCell.h"
#import "Macro.h"

typedef NS_ENUM(NSInteger, MessageContensViewTag) {

    MessageTitleTag = 200,
    MessageTag,
    MessageDateTag,
    MessageImageViewTag
};

@implementation MessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = KBackgroudColor;
        [self initMessageCell];
    }
    return  self;
}

- (void)initMessageCell {
    
    //背景图片
    UIImageView *messageImageView = [[UIImageView alloc] init];
    messageImageView.tag = MessageImageViewTag;
    [self.contentView addSubview:messageImageView];
    
    UILabel *message = [[UILabel alloc]init];
    message.tag = MessageTag;
    message.font = UIFontFromSize(14);
    message.textColor = UIColorFromRGB(121, 120, 120);
    [messageImageView addSubview:message];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = UIFontFromSize(12);
    dateLabel.tag = MessageDateTag;
    dateLabel.textColor = UIColorFromRGB(121, 120, 120);
    dateLabel.textAlignment = NSTextAlignmentRight;
    [messageImageView addSubview:dateLabel];
}

- (void)updateMessageCells {
    
    UIImage *messageImage;
    if (320 == kScreenWidth) {
        
        messageImage = [UIImage imageNamed:@"messageImageView5"];
    }else if (375 == kScreenWidth) {
        
        messageImage = [UIImage imageNamed:@"messageImageView6"];
    }else {
        
        messageImage = [UIImage imageNamed:@"messageImageView6p"];
    }
    CGFloat imageWidth = messageImage.size.width;
    messageImage = [messageImage stretchableImageWithLeftCapWidth:messageImage.size.width/2 topCapHeight:messageImage.size.height/2];
    CGSize size = [self.message sizeWithFont:UIFontFromSize(14) constrainedToSize:CGSizeMake(imageWidth-20, 400.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    //消息背景图片高度重绘
    UIImageView *messageImageView = (UIImageView *)[self.contentView viewWithTag:MessageImageViewTag];
    messageImageView.frame = CGRectMake((kScreenWidth-imageWidth)/2, 10, imageWidth, 30+size.height+20+10);
    messageImageView.image = messageImage;
    
    //消息内容
    UILabel *messageLabel = (UILabel *)[self.contentView viewWithTag:MessageTag];
    messageLabel.frame = CGRectMake(10, 30, imageWidth-20, size.height);
    messageLabel.numberOfLines = 0;
    messageLabel.text = self.message;
    
    //消息时间
    UILabel *messageDateLabel = (UILabel *)[self.contentView viewWithTag:MessageDateTag];
    messageDateLabel.frame = CGRectMake(0, size.height+30, imageWidth-20, 20);
    messageDateLabel.text = self.date;
}

- (float)height {
    
    CGSize size = [self.message sizeWithFont:UIFontFromSize(14) constrainedToSize:CGSizeMake(kScreenWidth-20-20, 400.0f) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+30+20+10;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
