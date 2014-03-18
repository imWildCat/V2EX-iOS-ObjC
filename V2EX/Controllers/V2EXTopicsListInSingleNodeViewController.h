//
//  V2EXTopicsListInSingleNodeViewController.h
//  V2EX
//
//  Created by WildCat on 2/16/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMDatabase.h>
#import "V2EXTableViewController.h"
#import "V2EXSingleTopicViewController.h"

@interface V2EXTopicsListInSingleNodeViewController : V2EXTableViewController
{
    BOOL _isLogin;
}

@property (weak, nonatomic) NSMutableString *uri;

//+ (V2EXTopicsListInSingleNodeViewController *)sharedController;
- (void)loadNewNodeWithData:(NSData *)data;

@end
