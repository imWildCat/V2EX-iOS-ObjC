//
//  V2EXMenuViewController.m
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXMenuViewController.h"
#import "V2EXAppDelegate.h"
#import "V2EXUserLoginViewController.h"
#import "UIViewController+MBProgressHUD.h"

#define MENU_BUTTON_COUNT 5

@interface V2EXMenuViewController ()

@end

@implementation V2EXMenuViewController

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
	
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * MENU_BUTTON_COUNT) / 2.0f, self.view.frame.size.width, 54 * MENU_BUTTON_COUNT) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;
    
    V2EXAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    switch (indexPath.row) {
        case 0:
//            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"nodesListController"]];
            navigationController.viewControllers = @[appDelegate.sharedNodesListViewController];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            navigationController.viewControllers = @[appDelegate.sharedLatestTopicsViewController];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"selfController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"settingsController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            [self doLogout];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return MENU_BUTTON_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"社区节点", @"最新话题", @"个人中心", @"用户设置", @"注销登录"];
    NSArray *images = @[@"IconHome", @"IconRecent", @"IconProfile", @"IconSettings", @"IconKey"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)doLogout {
    [V2EXUserLoginViewController logout];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:nil forKey:@"saved_username"];
    [userDefaultes setObject:nil forKey:@"saved_password"];
    [userDefaultes synchronize];
    [self showMessage:@"您已登出"];
}


#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willShowMenuViewController");
    [self hideProgressView];
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didShowMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willHideMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didHideMenuViewController");
}

@end
