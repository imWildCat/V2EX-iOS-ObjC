//
//  V2EXAfterTopicActionDelegate
//  V2EX
//
//  Created by WildCat on 3/6/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol V2EXAfterTopicActionDelegate <NSObject>

@optional

- (void)afterCreateTopic:(NSData *)data;
- (void)afterReplyTopic:(NSData *)data;

@end
