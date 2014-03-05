//
//  V2EXSingleTopicViewController.h
//  V2EX
//
//  Created by WildCat on 2/19/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXTableViewController.h"

@interface V2EXSingleTopicViewController : V2EXTableViewController
{
//    NSMutableArray *_cellHeightArray;
    NSUInteger _topicID;
    NSCache *_cellCache;
}

+ (V2EXSingleTopicViewController *)sharedController;

- (void)loadNewTopicWithID:(NSUInteger)ID;
- (void)loadNewTopicWithID:(NSUInteger)ID andData:(NSData *)data;

@end
