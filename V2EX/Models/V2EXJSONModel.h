//
//  V2EXJSONModel.h
//  V2EX
//
//  Created by WildCat on 2/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel.h"

@interface V2EXJSONModel : V2EXAbstractModel

- (void)getAllNodes;
- (void)getLatestTopics;

@end
