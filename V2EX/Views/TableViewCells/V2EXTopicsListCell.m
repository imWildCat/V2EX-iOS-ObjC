//
//  V2EXTopicsListCell.m
//  V2EX
//
//  Created by WildCat on 2/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXTopicsListCell.h"

@implementation V2EXTopicsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        //Changes here after init'ing self
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self.replies.layer setCornerRadius:8];
    [self.userAvatar.layer setCornerRadius:self.userAvatar.frame.size.width/5];
    self.userAvatar.layer.masksToBounds = YES;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}




@end
