//
//  V2EXUserTopicsListCell.h
//  V2EX
//
//  Created by WildCat on 3/23/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V2EXUserTopicsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *nodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *replies;
@property (weak, nonatomic) IBOutlet UILabel *lastReplyUsername;

@end
