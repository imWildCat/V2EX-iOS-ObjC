//
//  V2EXMyRepliesViewController.h
//  V2EX
//
//  Created by WildCat on 3/20/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXTableViewController.h"
#import "TFHpple+V2EXMethod.h"

@interface V2EXMyRepliesViewController : V2EXTableViewController
{
    NSCache *_cellCache;
    NSMutableArray *_tid;
    NSString *_cssStyle;
    
    NSMutableArray *_topicLinkArray;
}

@property (strong, nonatomic) TFHpple *doc;

@end
