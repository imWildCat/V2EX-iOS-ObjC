//
//  V2EXRequestDataDelegate.h
//  V2EX
//
//  Created by WildCat on 2/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol V2EXRequestDataDelegate <NSObject>

@required

- (void)requestDataSuccess:(id)dataObject;

@optional
- (void)requestDataFailure:(NSString *)errorMessage;
- (void)requestTopicsList:(NSString *)URI;

@end
