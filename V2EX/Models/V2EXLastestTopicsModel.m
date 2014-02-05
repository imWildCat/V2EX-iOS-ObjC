//
//  V2EXLastestTopicsModel.m
//  V2EX
//
//  Created by WildCat on 2/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXLastestTopicsModel.h"
#import "V2EXApiUri.h"

@implementation V2EXLastestTopicsModel

- (void)get {
    [self getJsonData:TOPICS_LATEST parameters:nil];
}

@end
