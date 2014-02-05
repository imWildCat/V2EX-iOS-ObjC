//
//  V2EXTopicsListCell.h
//  V2EX
//
//  Created by WildCat on 2/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V2EXTopicsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *nodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *replies;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end
