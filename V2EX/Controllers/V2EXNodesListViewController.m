//
//  V2EXNodesListViewController.m
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNodesListViewController.h"
#import <Masonry.h>
#import "UIView+FrameMethods.h"


@interface V2EXNodesListViewController ()

@end

@implementation V2EXNodesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if (!self.navigationBar) {
//        self.navigationBar = [UINavigationBar new];
//        NSLog(@"init");
//    }
    if (!self.paginatedScrollView) {
        self.paginatedScrollView = [DRPaginatedScrollView new];
        NSLog(@"init");
    }
    
   
    CGFloat yDelta = 0.0f;
//    CGFloat width = [self getWidth];
    
    // Tying up the segmented control to a scroll view
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 65 + yDelta, 320, 50)];
   
    [self setupSegmentedControl];
    [self setupPaginatedScrollView];
    [self setupView];
    [self setupConstraints];

}

- (void)setupSegmentedControl {
    [self.segmentedControl setScrollEnabled:YES];
    [self.segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
    [self.segmentedControl setSectionTitles:@[@"Worldwide", @"Local", @"Headlines",@"Other"]];
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.segmentedControl setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
    [self.segmentedControl setTextColor:[UIColor whiteColor]];
    [self.segmentedControl setSelectedTextColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]];
    [self.segmentedControl setSelectionIndicatorColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1]];
    [self.segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    [self.segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationUp];
    [self.segmentedControl setTag:4];
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.paginatedScrollView jumpToPage:index bounce:0 completion:nil];
    }];
}

- (void)setupPaginatedScrollView {
    [self.paginatedScrollView setJumpDurationPerPage:0.125];
    [self.paginatedScrollView setDelegate:self];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        UILabel * label = [UILabel new];
        [label setText:@"Hi! This is a DRPaginatedScrollView. Every page has been easily implemented entirely by blocks.\n\nIt uses Autolayout. Rotate your device and check it out!\n\nPretty nice, isn't it?"];
        [label setNumberOfLines:100];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [pageView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(pageView);
            make.left.equalTo(@15);
            make.right.equalTo(@-15);
        }];
    }];
    
//    __unsafe_unretained typeof(self) _self = self;
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
      
        UILabel * label = [UILabel new];
        [label setText:@"Oh, and by the way... there's a function to perform jumps to any page you specify. It's really simple to use, and it has a really cool parameter called \"bounce\".\n\nThis parameter... well, tap the button below and you'll see what it is for."];
        [label setNumberOfLines:100];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [pageView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.bottom.equalTo(@0);
            make.left.equalTo(@15);
            make.right.equalTo(@-15);
        }];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        
        UILabel *label = [UILabel new];
        [label setText:@"Thanks for using this demo app of DRPaginatedScrollView. I hope you can give it a chance in any of your future projects.\n\n\nAny feedback you'd like to leave me? I'll gladly read it :)"];
        [label setNumberOfLines:100];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [pageView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        UITableView *tableview = [[UITableView alloc]init];
        [pageView addSubview:tableview];
        [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
    }];
}

- (void)setupView {
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.segmentedControl];
    [self.view insertSubview:self.paginatedScrollView belowSubview:self.segmentedControl];
}

- (void)setupConstraints {
//    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@64);
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//        make.height.equalTo(@64);
//    }];
    
    [self.paginatedScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).with.offset(-10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}


//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}
@end
