//
//  V2EXAbstractModel.m
//  V2EX
//
//  Created by WildCat on 2/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel.h"

@implementation V2EXAbstractModel

- (id)initWithDelegate:(id)delegate {
    self = [self init];
    if(self){
        _delegate = delegate;
        self.apiClient = [V2EXApiClient sharedClient];
    }
    return self;
}

- (void)loadData:(NSString *)uri isGetMethod:(BOOL)isGetMethod isJsonApi:(BOOL)isJsonApi parameters:(NSDictionary *)parameters {
    [self.apiClient managerRequestData:uri isGetMethod:isGetMethod isJsonApi:isJsonApi parameters:parameters success:^(id dataObject) {
        [self loadDataSuccess:[self parseData:dataObject]];
    } failure:^(NSError *error) {
        [self loadDataFailure:error];
    }];
}

- (NSDictionary *) parseData:(id)dataObject {
    //Optional to be overwritten.
    return dataObject;
}

- (void)loadDataSuccess:(id)dataObject {
    [_delegate requestDataSuccess:dataObject];
}

- (void)loadDataFailure:(NSError *)error {
    //TODO: To show user-friendly message.
    [_delegate requestDataFailure:[error description]];
}

@end
