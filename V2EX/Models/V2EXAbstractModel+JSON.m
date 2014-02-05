//
//  V2EXAbstractModel+JSON.m
//  V2EX
//
//  Created by WildCat on 2/5/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel+JSON.h"

@implementation V2EXAbstractModel (JSON)

- (void)getJsonData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:YES parameters:parameter];
}

@end
