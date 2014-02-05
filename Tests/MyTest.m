//
//  MyTest.m
//
#import <GHUnit/GHUnit.h>
#import <Foundation/Foundation.h>
#import <TFHpple.h>
#import <AFNetworking.h>
#import "V2EXLastestTopicsModel.h"
#import "V2EXRequestDataDelegate.h"

@interface MyTest : GHTestCase <V2EXRequestDataDelegate>
@end

@implementation MyTest

- (void)testDataModel {
    V2EXLastestTopicsModel *lastestTopicsM = [[V2EXLastestTopicsModel alloc]initWithDelegate:self];
    [lastestTopicsM get];
}

- (void)requestDataSuccess:(NSDictionary *)dataObject {
    NSLog(@"%@",dataObject);
}

@end
