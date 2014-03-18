//
//  V2EXNodesListCell.h
//  V2EX
//
//  Created by WildCat on 2/16/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V2EXRequestDataDelegate.h"

@interface V2EXNodesListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nodeTitle;
@property (strong, nonatomic) IBOutlet UILabel *nodeHeader;

@property (strong, nonatomic) NSString *nodeURI;
@property(nonatomic, assign) id<V2EXRequestDataDelegate> delegate;

@end
