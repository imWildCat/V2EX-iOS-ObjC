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
#import "V2EXApiClient.h"
#import "DRPaginatedScrollView.h"


@interface V2EXNodesListViewController : UIViewController <UIScrollViewDelegate>
{
    CGFloat _segmentedControlX;
}

@property (strong, nonatomic) DRPaginatedScrollView * paginatedScrollView;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

- (IBAction)showMenu:(id)sender;

@end
