//
//  TFHpple+V2EXMethod.h
//  V2EX
//
//  Created by WildCat on 3/6/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "TFHpple.h"
#import "TFHppleElement+V2EXMethod.h"

@interface TFHpple (V2EXMethod)

- (TFHppleElement *)searchFirstElementWithXPathQuery:(NSString *)query;
- (BOOL)checkLogin;

@end
