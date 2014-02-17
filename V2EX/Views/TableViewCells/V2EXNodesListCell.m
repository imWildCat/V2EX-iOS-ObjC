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
    [self addGestureRecognizer:tap];
    // Add responder for click event.
}

- (void)cellClick {
    // TODO: This is very bad implementation to respond click event in UITableViewCell as a result of using UITableView in UIScrollView. Need to improve. The page view(DRPaginatedScrollView) in V2EXNodesListController should be replaced by one doesn't inherit form UIScrollView.
    [self.delegate requestTopicsList:self.nodeURI];
}

@end
