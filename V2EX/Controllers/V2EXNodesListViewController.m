//
//  V2EXNodesListViewController.m
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNodesListViewController.h"
#import <Masonry.h>
#import "V2EXNodesListModel.h"
#import "V2EXTopicsListInSingleNodeViewController.h"

@interface V2EXNodesListViewController ()

@end

@implementation V2EXNodesListViewController

+ (V2EXNodesListViewController *)sharedController
{
    static V2EXNodesListViewController *_sharedNodesListViewControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedNodesListViewControllerInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"nodesListController"];
    });
    
    return _sharedNodesListViewControllerInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _topicsListInSingleNodeViewController = [V2EXTopicsListInSingleNodeViewController sharedController];
    
//    if (!self.navigationBar) {
//        self.navigationBar = [UINavigationBar new];
//        NSLog(@"init");
//    }
    if (!self.paginatedScrollView) {
        self.paginatedScrollView = [DRPaginatedScrollView new];
        _normalModel = [[V2EXNormalModel alloc]initWithDelegate:self];
        
        _nodesListModel0 = [[V2EXNodesListModel alloc] initWithIndex:0];
        _nodesListModel0.delegate = self;
        
        _nodesListModel1 = [[V2EXNodesListModel alloc] initWithIndex:1];
        _nodesListModel1.delegate = self;
        
        _nodesListModel2 = [[V2EXNodesListModel alloc] initWithIndex:2];
        _nodesListModel2.delegate = self;
        
        _nodesListModel3 = [[V2EXNodesListModel alloc] initWithIndex:3];
        _nodesListModel3.delegate = self;
        
        _nodesListModel4 = [[V2EXNodesListModel alloc] initWithIndex:4];
        _nodesListModel4.delegate = self;
        
        _nodesListModel5 = [[V2EXNodesListModel alloc] initWithIndex:5];
        _nodesListModel5.delegate = self;
        
        _nodesListModel6 = [[V2EXNodesListModel alloc] initWithIndex:6];
        _nodesListModel6.delegate = self;
        
        _nodesListModel7 = [[V2EXNodesListModel alloc] initWithIndex:7];
        _nodesListModel7.delegate = self;
        
        _nodesListModel8 = [[V2EXNodesListModel alloc] initWithIndex:8];
        _nodesListModel8.delegate = self;
        
        _nodesListModel9 = [[V2EXNodesListModel alloc] initWithIndex:9];
        _nodesListModel9.delegate = self;
    }
    
   
    CGFloat yDelta = 0.0f;
//    CGFloat width = [self getWidth];
    
    // Tying up the segmented control to a scroll view
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64 + yDelta, 320, 50)];
   
    [self setupSegmentedControl];
    [self setupPaginatedScrollView];
    [self setupView];
    [self setupConstraints];

}

- (void)setupSegmentedControl {
    [self.segmentedControl setScrollEnabled:YES];
    [self.segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
    [self.segmentedControl setSectionTitles:@[/*@"收藏", */@"分享与探索", @"V2EX", @"iOS", @"Geek", @"游戏", @"Apple", @"生活", @"Internet", @"城市", @"品牌"]];
    [self.segmentedControl setSelectedSegmentIndex:0];
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
    
    __weak typeof(self) _weakSelf = self;
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel0];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel1];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel2];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel3];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel4];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel5];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel6];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel7];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel8];
    }];
    
    [self.paginatedScrollView addPageWithHandler:^(UIView *pageView) {
        [_weakSelf handlePageWith:pageView andModel:_weakSelf.nodesListModel9];
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

- (void)handlePageWith:(UIView *)pageView andModel:(V2EXNodesListModel *)nodesListModel {
    UITableView *tableview = [[UITableView alloc]init];
    tableview.rowHeight = 55;
    [tableview setDelegate:nodesListModel];
    [tableview setDataSource:nodesListModel];
//    [tableview reloadData];
    tableview.separatorInset = UIEdgeInsetsZero;
    [pageView addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

#pragma mark - V2EXRequestDataDelegate
- (void)requestTopicsList:(NSString *)URI {
        _uriClicked = [URI copy];
        [self showProgressView];
        [_normalModel getTopicsList:URI];
}

-(void)requestDataSuccess:(id)dataObject {
//    _topicsListInSingleNodeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"topicListInSingleNodeController"];

    _topicsListInSingleNodeViewController.uri = _uriClicked;
    [_topicsListInSingleNodeViewController loadNewNodeWithData:dataObject];

    [self.navigationController pushViewController:_topicsListInSingleNodeViewController animated:YES];
    [self hideProgressView];
}

- (void)requestDataFailure:(NSString *)errorMessage {
    [self hideProgressView];
    [self showMessage:errorMessage];
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}


@end
