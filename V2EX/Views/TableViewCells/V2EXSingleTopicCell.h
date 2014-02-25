//
//  V2EXSingleTopicCell.h
//  V2EX
//
//  Created by WildCat on 2/24/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V2EXSingleTopicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *replyTime;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *content;


@end
