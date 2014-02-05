//
//  V2EXAbstractModel+HTML.h
//  V2EX
//
//  Created by WildCat on 2/5/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel.h"

@interface V2EXAbstractModel (HTML)

- (void)getHtmlData:(NSString *)uri parameters:(NSDictionary *)parameter;
- (void)postData:(NSString *)uri parameters:(NSDictionary *)parameter;

@end
