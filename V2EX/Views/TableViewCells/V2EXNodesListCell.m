//
//  V2EXNodesListCell.m
//  V2EX
//
//  Created by WildCat on 2/16/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNodesListCell.h"

@implementation V2EXNodesListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)awakeFromNib {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick)];
    [self addGestureRecognizer:tap];//添加view的点击事件
}

- (void)cellClick {
    #warning Incomplete method implementation.
    NSLog(self.nodeUri);
}

@end
