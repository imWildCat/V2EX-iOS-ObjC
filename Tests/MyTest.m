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

- (void)test4NodeList {
    V2EXNormalModel *model = [[V2EXNormalModel alloc] initWithDelegate:self];
    [model getTopicsList:@"qna"];
}

- (void)requestDataSuccess:(id)dataObject {
//    NSLog(@"%@",dataObject);
#pragma mark - make plist
//    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:dataObject];
//    NSArray *elements = [doc searchWithXPathQuery:@"/html/body/div[2]/div/div[3]/div[11]/table//a"];
//    NSMutableString *string = [NSMutableString new];
//    for (TFHppleElement *element in elements) {
//        [string appendString:@"<string>"];
//        [string appendString:[[element objectForKey:@"href"] stringByReplacingOccurrencesOfString:@"/go/" withString:@""]];
//        [string appendString:@"</string>\n"];
//    }
//    NSLog(string);
    
#pragma mark - for node list
    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:dataObject];
    NSArray *elements = [doc searchWithXPathQuery:@"//body/div[2]/div/div/div[@class='cell']/table[1]"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in elements) {
        TFHppleElement *avatarElement = [[element searchWithXPathQuery:@"//td[1]/a/img"] objectAtIndex:0];
        TFHppleElement *titleElement = [[element searchWithXPathQuery:@"//td[3]/span[@class='item_title']/a"] objectAtIndex:0];
        TFHppleElement *userNameElement = [[element searchWithXPathQuery:@"//td[3]/span[@class='small fade']/strong"] objectAtIndex:0];
        NSArray *replyElements = [element searchWithXPathQuery:@"//td[4]/a"];
        
        NSString *replyCount;
        if ([replyElements count] > 0)
        {
            TFHppleElement *replyElement = [replyElements objectAtIndex:0];
            replyCount = [replyElement text];
        } else {
            replyCount = @"0";
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [avatarElement objectForKey:@"src"], @"avatar",
                                [titleElement text], @"title",
                                [userNameElement text], @"username",
                                replyCount, @"replies", nil
                              ];
        [array addObject:dict];
    }
    
    NSLog(@"%@", array);
    
    
}

- (void)requestDataFailure:(NSString *)errorMessage {
    NSLog(@"%@",errorMessage);
}



@end
