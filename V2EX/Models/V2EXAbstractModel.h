//
//  V2EXAbstractModel.h
//  V2EX
//
//  Created by WildCat on 2/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "V2EXApiClient.h"
#import "V2EXRequestDataDelegate.h"

@interface V2EXAbstractModel : NSObject
{
    id <V2EXRequestDataDelegate> _delegate;
};


@property (nonatomic, assign) V2EXApiClient *apiClient;

- (id) initWithDelegate:(id)delegate;
- (NSDictionary *) parseData:(id)dataObject;
- (void)loadDataSuccess:(id)dataObject;
- (void)loadDataFailure:(NSError *)error;
// Need to support request start and terminate request. For example, - (void)startLoadData & - (void)terminateLoading;
// If not, 


//- (void)loadData:(NSString *)uri isGetMethod:(BOOL)isGetMethod isJsonApi:(BOOL)isJsonApi parameters:(NSDictionary *)parameters;
// Base Data
- (void)getJSONData:(NSString *)uri parameters:(NSDictionary *)parameter;

// HTML Data
- (void)getHTMLData:(NSString *)uri parameters:(NSDictionary *)parameter;

- (void)postData:(NSString *)uri parameters:(NSDictionary *)parameter;

@end
