//
//  V2EXTableViewController.m
//  V2EX
//
//  Created by WildCat on 2/7/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXTableViewController.h"
#import "V2EXSingleTopicViewController.h"
#import "TFHpple+V2EXMethod.h"
#import "V2EXUserLoginViewController.h"
#import "UIViewController+V2EXJump.h"

@interface V2EXTableViewController ()

@end

@implementation V2EXTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Refresh control
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // Data model
    if(!_model){
        _model = [[V2EXNormalModel alloc]initWithDelegate:self];
    }
}


- (void)refreshTableView {
    if(self.refreshControl.refreshing){
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中"];
        [self loadData];
    }
}

- (void)loadData {
    // Must implement this method in subclass.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoadData

- (void)requestDataSuccess:(NSDictionary *)dataObject {
    [self.tableView reloadData];
    [self hideProgressView];
    
    [self finishRefresh];
    _loadingStatus = 0;
}

- (void)requestDataFailure:(NSString *)errorMessage {
    [self finishRefresh];
    _loadingStatus = 0;
}

- (BOOL)canStartNewLoading {
    return _loadingStatus == 0;
}

- (void)finishRefresh {
    // Refresh Control
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载完成"];
    [self performSelector:@selector(afterFinishRefresh) withObject:nil afterDelay:0.5f];
}

- (void)afterFinishRefresh {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}

#pragma mark - Push to new controller method
- (void)pushToSingleTopicViewController:(NSData *)dataObject {
    // Check if need to log in
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:dataObject];
    NSArray *messageArray = [doc searchWithXPathQuery:@"//div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='message']"];
    if ([messageArray count] > 0) {
        if ([[[messageArray objectAtIndex:0] text] isEqualToString:@"查看本主题需要登录"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查看本主题需要登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            // If not login, show alert
            // TODO: still request to login if has logged in
            return;
        }
    }
    
    V2EXSingleTopicViewController *singleTopicController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"singleTopicController"];
    [singleTopicController loadNewTopicWithData:dataObject];
    [self.navigationController pushViewController:singleTopicController animated:YES];
}

#pragma marks -- UIAlertViewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self pushToUserLoginController];
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
