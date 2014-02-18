//
//  V2EXTopicsListInSingleNodeViewController.m
//  V2EX
//
//  Created by WildCat on 2/16/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <TFHpple.h>
#import "V2EXTopicsListInSingleNodeViewController.h"
#import "V2EXTopicsListCell.h"
#import "V2EXNormalModel.h"

@interface V2EXTopicsListInSingleNodeViewController ()

@end

@implementation V2EXTopicsListInSingleNodeViewController

+ (V2EXTopicsListInSingleNodeViewController *)sharedController
{
    static V2EXTopicsListInSingleNodeViewController *_sharedTopicsListInSingleNodeViewControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedTopicsListInSingleNodeViewControllerInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"topicListInSingleNodeController"];
    });
    
    return _sharedTopicsListInSingleNodeViewControllerInstance;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 70; // TODO: Why don't storyboard support rowHeight?
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadNewNode];
    
    // Scroll to the top
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    _uri = nil;
}

- (void)loadNewNode {
    // Reload data
    [self requestDataSuccess:self.data];
}

- (void)loadData {
    [self.model getTopicsList:self.uri];
}

- (void)requestDataSuccess:(id)dataObject {
    self.data = [[NSMutableArray alloc] init];
    
    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:dataObject];
    
    NSString *allHtml = [[[doc searchWithXPathQuery:@"//div[@class='header']"] objectAtIndex:0] raw];
    NSString *delDiv = [[[doc searchWithXPathQuery:@"//div[@class='header']/div"] objectAtIndex:0] raw];
    NSString *delA = [[[doc searchWithXPathQuery:@"//div[@class='header']/a"] objectAtIndex:0] raw];
    NSString *delSpan = [[[doc searchWithXPathQuery:@"//div[@class='header']/span"] objectAtIndex:0] raw];
    NSString *title = [[[[[allHtml stringByReplacingOccurrencesOfString:delDiv withString:@""]
                       stringByReplacingOccurrencesOfString:delA withString:@""]
                       stringByReplacingOccurrencesOfString:delSpan withString:@""]
                       stringByReplacingOccurrencesOfString:@"\n    \n    </div>" withString:@""]
                       stringByReplacingOccurrencesOfString:@"<div class=\"header\">  " withString:@""];
    self.navigationItem.title = title;
    
    
    // Data Rows
    NSArray *elements = [doc searchWithXPathQuery:@"//body/div[2]/div/div/div[@class='cell']/table[1]"];
    
    for (TFHppleElement *element in elements) {
        TFHppleElement *avatarElement = [[element searchWithXPathQuery:@"//td[1]/a/img"] objectAtIndex:0];
        TFHppleElement *titleElement = [[element searchWithXPathQuery:@"//td[3]/span[@class='item_title']/a"] objectAtIndex:0];
        TFHppleElement *userNameElement = [[element searchWithXPathQuery:@"//td[3]/span[@class='small fade']/strong"] objectAtIndex:0];
        NSArray *replyElements = [element searchWithXPathQuery:@"//td[4]/a"];
        
        NSString *replyCount;
        if ([replyElements count] > 0)
        {
            TFHppleElement *replyElement = [replyElements objectAtIndex:0];
            replyCount = [replyElement text];
        } else {
            replyCount = @"0";
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [@"http:"stringByAppendingString: [avatarElement objectForKey:@"src"]], @"avatar",     //TODO: Support https
                              [titleElement text], @"title",
                              [userNameElement text], @"username",
                              replyCount, @"replies", nil
                              ];
        [self.data addObject:dict];
    }
    [super requestDataSuccess:dataObject];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath row];
    static NSString *CellIdentifier = @"topicsListCell";
    
    UINib *nib = [UINib nibWithNibName:@"V2EXTopicsListCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    V2EXTopicsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    id rowData = [self.data objectAtIndex:index];
    
    cell.title.text = [rowData valueForKey:@"title"];
    cell.nodeTitle.text = @"";
    cell.replies.text = [rowData valueForKey:@"replies"];
    cell.username.text = [rowData valueForKey:@"username"];
    [cell.userAvatar setImageWithURL:[NSURL URLWithString:[rowData valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"avatar_large"]];
    
    return cell;
}

@end
