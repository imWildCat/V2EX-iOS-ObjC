//
//  V2EXNormalModel.h
//  V2EX
//
//  Created by WildCat on 2/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel.h"

@interface V2EXNormalModel : V2EXAbstractModel

// API
- (void)getIndex;
- (void)getTopicsList:(NSString *)URI;
//- (void)getTopicWithLinkURI:(NSString *)URI;
- (void)getTopicWithID:(NSUInteger)ID;

// User
- (void)getUserInfo:(NSString *)username;

// JSON API
- (void)getAllNodes;
- (void)getLatestTopics;

// Topic
- (void)replyTopic:(NSUInteger)topicID andOnce:(NSUInteger)onceCode andContent:(NSString *)content;
- (void)getNewTopicPage:(NSString *)uri;
- (void)newTopic:(NSString *)uri andTitle:(NSString *)title andContent:(NSString *)content andOnce:(NSUInteger)once;

@end
