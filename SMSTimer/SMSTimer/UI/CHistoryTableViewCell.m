//
//  CHistoryTableViewCell.m
//  SMSTimer
//
//  Created by GaoAng on 14-4-24.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CHistoryTableViewCell.h"
#import "RFUtility.h"
@implementation CHistoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.senderLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.sendertime];
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
}

-(UILabel*)senderLabel{
    if (!_senderLabel) {
        _senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 320-30, 15)];
        [_senderLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
//        [_senderLabel setTextColor:[RFUtility ColorWithR:57 G:155 B:231 A:0.5f]];
        [_senderLabel setTextColor:[UIColor blackColor]];
        [_senderLabel setTextColor:[RFUtility ColorWithR:190 G:190 B:190 A:1.0f]];
    }
    return _senderLabel;
}


-(UILabel*)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.senderLabel.frame),
                                                                  CGRectGetMaxY(self.senderLabel.frame)+5, 320-30, 15)];
        [_contentLabel setFont:[UIFont systemFontOfSize:16.0f]];
//        [_contentLabel setTextColor:[RFUtility ColorWithR:57 G:155 B:321 A:1.0f]];
        [_contentLabel setTextColor:[UIColor blackColor]];
    }
    return _contentLabel;
}


-(UILabel*)sendertime{
    if (!_sendertime) {
        _sendertime = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.contentLabel.frame)+ 5, 320-30, 15)];
        [_sendertime setFont:[UIFont systemFontOfSize:13.0f]];
        [_sendertime setTextAlignment:NSTextAlignmentRight];
        [_sendertime setTextColor:[RFUtility ColorWithR:190 G:190 B:190 A:1.0f]];
    }
    return _sendertime;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loardDataWith:(CSMSData*)data{
    if (!data) {
        return;
    }
    self.senderLabel.text = data.recUserNumber;
    
    //
    self.contentLabel.text = data.sendMsg;
    
    CGSize size = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.contentLabel.frame.size.width, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:self.contentLabel.font}
                                                      context:nil].size;

    
    [self.contentLabel setFrame:CGRectMake(CGRectGetMinX(self.contentLabel.frame),
                                           CGRectGetMinY(self.contentLabel.frame),
                                           CGRectGetWidth(self.contentLabel.frame),
                                           size.height)];
    self.contentLabel.numberOfLines = ceilf(size.height/self.contentLabel.font.lineHeight);
    if (data.sendTime.length >= 16) {
        self.sendertime.text = [data.sendTime substringToIndex:16];
    }
    else{
        self.sendertime.text = data.sendTime;
    }
    
    [self.sendertime setFrame:CGRectMake(CGRectGetMinX(self.sendertime.frame),
                                         CGRectGetMaxY(self.contentLabel.frame)+5,
                                         CGRectGetWidth(self.sendertime.frame),
                                         CGRectGetHeight(self.sendertime.frame))];
}

+(CGFloat)cellForData:(NSString*)content{
    CGFloat cellHeight = 30 + 15 + 10;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    cellHeight += size.height;
    return cellHeight;
}

@end
