//
//  V2EXNodesListViewController.h
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>
#import <HMSegmentedControl.h>
#import "DRPaginatedScrollView.h"
#import "V2EXNodesListModel.h"
#import "V2EXRequestDataDelegate.h"
#import "UIViewController+MBProgressHUD.h"
#import "V2EXNormalModel.h"


@interface V2EXNodesListViewController : UIViewController <UIScrollViewDelegate, V2EXRequestDataDelegate>
{
    CGFloat _segmentedControlX;
    V2EXNormalModel *_normalModel;
    
    NSMutableString *_uriClicked;
}

@property (strong, nonatomic) DRPaginatedScrollView * paginatedScrollView;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

@property (nonatomic, retain) V2EXNodesListModel *nodesListModel0;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel1;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel2;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel3;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel4;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel5;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel6;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel7;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel8;
@property (nonatomic, retain) V2EXNodesListModel *nodesListModel9;

+ (V2EXNodesListViewController *)sharedController;
- (IBAction)showMenu:(id)sender;

@end
