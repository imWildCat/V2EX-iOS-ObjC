//
//  MyTest.m
//
#import <GHUnit/GHUnit.h>
#import <Foundation/Foundation.h>
#import <TFHpple.h>

#import "V2EXNormalModel.h"
#import "V2EXRequestDataDelegate.h"

@interface MyTest : GHTestCase <V2EXRequestDataDelegate>
@end

@implementation MyTest

- (void)test2MakePlist {
    V2EXNormalModel *model = [[V2EXNormalModel alloc] initWithDelegate:self];
    [model getIndex];
    
}

- (void)requestDataSuccess:(id)dataObject {
//    NSLog(@"%@",dataObject);
    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:dataObject];
    NSArray *elements = [doc searchWithXPathQuery:@"/html/body/div[2]/div/div[3]/div[11]/table//a"];
    NSMutableString *string = [NSMutableString new];
    for (TFHppleElement *element in elements) {
        [string appendString:@"<string>"];
        [string appendString:[[element objectForKey:@"href"] stringByReplacingOccurrencesOfString:@"/go/" withString:@""]];
        [string appendString:@"</string>\n"];
    }
    NSLog(string);
}

- (void)requestDataFailure:(NSString *)errorMessage {
    NSLog(@"%@",errorMessage);
}



@end
