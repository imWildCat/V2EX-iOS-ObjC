//
//  V2EXAbstractModel+HTML.m
//  V2EX
//
//  Created by WildCat on 2/5/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel+HTML.h"

@implementation V2EXAbstractModel (HTML)

- (void)getHtmlData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:NO parameters:parameter];
}

- (void)postData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:NO isJsonApi:NO parameters:parameter];
}

@end
