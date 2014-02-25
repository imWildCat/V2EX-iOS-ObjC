//
//  V2EXLatestTopicsViewController.m
//  V2EX
//
//  Created by WildCat on 2/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXLatestTopicsViewController.h"
#import "V2EXTopicsListCell.h"
#import "V2EXStringUtil.h"

@interface V2EXLatestTopicsViewController ()

@end

@implementation V2EXLatestTopicsViewController

+ (V2EXLatestTopicsViewController *)sharedController
{
    static V2EXLatestTopicsViewController *_sharedLatestTopicsViewControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedLatestTopicsViewControllerInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"latestTopicsController"];
    });
    
    return _sharedLatestTopicsViewControllerInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self showProgressView];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self.model getLatestTopics];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topicsListCell";
    
//    static BOOL nibsRegistered = NO;
//    if (!nibsRegistered) {
//        UINib *nib = [UINib nibWithNibName:@"V2EXTopicsListCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
//        nibsRegistered = YES;
//    }
    UINib *nib = [UINib nibWithNibName:@"V2EXTopicsListCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    V2EXTopicsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    [cell.replies.layer setCornerRadius:8];
//    [cell.userAvatar.layer setCornerRadius:cell.userAvatar.frame.size.width/5];
////    cell.userAvatar.layer.masksToBounds = YES;
    
    NSUInteger row = [indexPath row];
    id rowData = [self.data objectAtIndex:row];
    [cell.title setText:[rowData valueForKey:@"title"]];
    [cell.nodeTitle setText:[[rowData objectForKey:@"node"] valueForKey:@"title"]];
    
    NSString *replies = [NSString stringWithFormat:@"%i",[[rowData valueForKey:@"replies"]intValue]];
    //Using [[rowData valueForKey:@"replies"] directly will lead to an exception.
    [cell.replies setText:replies];
    
    [cell.username setText:[[rowData objectForKey:@"member"] valueForKey:@"username"]];
    NSString *avatarUrl = [V2EXStringUtil hanldeAvatarURL:[[rowData objectForKey:@"member"] valueForKey:@"avatar_large"]];
    //TODO: Support https
    [cell.userAvatar setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_large"]];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger index = indexPath.row;
}

- (void)requestDataSuccess:(id)dataObject {
    self.data = dataObject;
    [super requestDataSuccess:dataObject];
}
//
//- (void)requestDataFailure:(NSString *)errorMessage {
//    [self showMessage:errorMessage];
//    [self showProgressView];
//}


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

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}
@end
