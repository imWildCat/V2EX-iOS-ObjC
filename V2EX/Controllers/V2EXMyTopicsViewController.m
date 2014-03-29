//
//  V2EXMyTopicsViewController.m
//  V2EX
//
//  Created by WildCat on 3/20/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXMyTopicsViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import "V2EXUserTopicsListCell.h"
#import "V2EXStringUtil.h"

@interface V2EXMyTopicsViewController ()

@end

@implementation V2EXMyTopicsViewController

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
	
    if (self.doc == nil) {
        [self showMessage:@"未知错误，无法加载您的主题"];
        return;
    }
    self.tableView.rowHeight = 70; // TODO: Why don't storyboard with identifiertopicListInSingleNodeController support rowHeight?
    [self handleUserTopicsListData];
   
}

- (void)handleUserTopicsListData {
    self.data = [[NSMutableArray alloc] init];
    NSArray *topicsArray = [self.doc searchWithXPathQuery:@"//div[@class='content']/div[@class='box']/div[@class='cell item']"];
    
    for (TFHppleElement *element in topicsArray) {
        NSString *title = [[element searchFirstElementWithXPathQuery:@"//span[@class='item_title']/a"] text]?:@"";
        NSString *nodeTitle = [[element searchFirstElementWithXPathQuery:@"//span[@class='small fade']/a[1]"] text]?:@"";
        NSString *replies = [[element searchFirstElementWithXPathQuery:@"//a[@class='count_orange']"] text]?:@"0";
        NSString *lastReplyUsername = [[element searchFirstElementWithXPathQuery:@"//span[@class='small fade']/strong[2]/a"] text]?:@"无回复";
        NSString *link = [[element searchFirstElementWithXPathQuery:@"//span[@class='item_title']/a"] objectForKey:@"href"];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              title, @"title",
                              nodeTitle, @"nodeTitle",
                              replies, @"replies",
                              lastReplyUsername, @"lastReplyUsername",
                              link, @"link",
                              nil];
        [self.data addObject:dict];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath row];
    static NSString *CellIdentifier = @"userTopicListCell";
    
    UINib *nib = [UINib nibWithNibName:@"V2EXUserTopicsListCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    V2EXUserTopicsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *rowData = [self.data objectAtIndex:index];
    
    cell.title.text = [rowData valueForKey:@"title"];
    cell.nodeTitle.text = [rowData valueForKey:@"nodeTitle"];
    cell.replies.text = [rowData valueForKey:@"replies"];
    cell.lastReplyUsername.text = [rowData valueForKey:@"lastReplyUsername"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [indexPath row];
    NSUInteger topicID = [V2EXStringUtil link2TopicID:[[self.data objectAtIndex:index] objectForKey:@"link"]];
    
    if (topicID > 0) {
        [self.model getTopicWithID:topicID];
        [self showProgressView];
    } else {
        [self showMessage:@"无法加载您的主题"];
    }
}

- (void)requestDataSuccess:(id)dataObject {
    [self pushToSingleTopicViewController:dataObject];
}



@end
