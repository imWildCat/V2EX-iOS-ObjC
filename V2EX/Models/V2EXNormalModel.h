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

// JSON API
- (void)getAllNodes;
- (void)getLatestTopics;

@end
