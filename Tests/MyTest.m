//
//  MyTest.m
//
#import <GHUnit/GHUnit.h>
#import <Foundation/Foundation.h>
#import <TFHpple.h>
#import <AFNetworking.h>
#import "V2EXNormalModel.h"
#import "V2EXRequestDataDelegate.h"

@interface MyTest : GHTestCase <V2EXRequestDataDelegate>
@end

@implementation MyTest

- (void)testHelloWorld {
    NSLog(@"Hello World!");
}

@end
