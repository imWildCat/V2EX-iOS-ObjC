//
//  V2EXAppDelegate.m
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAppDelegate.h"
#import <FMDatabase.h>
#import <FMDatabaseAdditions.h>
#import "V2EXStringUtil.h"

@implementation V2EXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.cache = [V2EXGlobalCache cache];
    [self prepareForLaunching];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)prepareForLaunching {
    [self prepareForNodeList];
    [self prepareForAllControllers];
}

- (void)prepareForNodeList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileMgr = [NSFileManager new];
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    [fileMgr createDirectoryAtPath:[documentDirectory stringByAppendingString:@"/db"] withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"db/v2ex_normal.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    int nodesCount = [db intForQuery:@"SELECT COUNT(*) FROM nodes"];
    
    if (nodesCount > 700) {
        NSLog(@"nodes > 700");
    } else {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS nodes (id integer NOT NULL PRIMARY KEY UNIQUE,name text NOT NULL,title text NOT NULL,uri text NOT NULL,topics integer NOT NULL,header text,footer text,created text NOT NULL)"];
        
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"NodesAll" ofType:@"json"];
        NSData   *jsonData = [NSData dataWithContentsOfFile:plistPath];
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *row in json) {
            NSString *header, *footer;
            if ([row objectForKey:@"header"] != [NSNull null]) {
                header = [V2EXStringUtil stringByStrippingHTML:[row objectForKey:@"header"]];
            } else {
                header = nil;
            }
            if ([row objectForKey:@"footer"] != [NSNull null]) {
                footer = [V2EXStringUtil stringByStrippingHTML:[row objectForKey:@"footer"]];
            } else {
                footer = nil;
            }
            
            [db executeUpdate:@"INSERT OR REPLACE INTO nodes (id, name, title, uri, topics, header, footer, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
             [row objectForKey:@"id"],
             [row objectForKey:@"name"],
             [row objectForKey:@"title"],
             [[row objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"http://www.v2ex.com/go/" withString:@""],
             [row objectForKey:@"topics"],
             header,
             footer,
             [row objectForKey:@"created"]
             ];
        }
    }
    //    V2EXJSONModel *nodesListModel = [[V2EXJSONModel alloc] initWithDelegate:self];
    //    [nodesListModel getAllNodes];
}

- (void)prepareForAllControllers {
    _sharedLatestTopicsViewController = [V2EXLatestTopicsViewController sharedController];
    _sharedNodesListViewController = [V2EXNodesListViewController sharedController];
}



//- (void)requestDataSuccess:(id)dataObject {
//    _dictAllNodes = dataObject;
//}

@end
