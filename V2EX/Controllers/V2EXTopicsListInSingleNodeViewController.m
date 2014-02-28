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
#import "V2EXMBProgressHUDUtil.h"
#import "V2EXStringUtil.h"

@interface V2EXTopicsListInSingleNodeViewController ()

@end

@implementation V2EXTopicsListInSingleNodeViewController

//+ (V2EXTopicsListInSingleNodeViewController *)sharedController
//{
//    static V2EXTopicsListInSingleNodeViewController *_sharedTopicsListInSingleNodeViewControllerInstance = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        _sharedTopicsListInSingleNodeViewControllerInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"topicListInSingleNodeController"];
//    });
//    
//    return _sharedTopicsListInSingleNodeViewControllerInstance;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 70; // TODO: Why don't storyboard with identifiertopicListInSingleNodeController support rowHeight?
    _loadingStatus = 1;
    
//    self.singleTopicViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"singleTopicController"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//}


- (void)loadNewNodeWithData:(NSData *)data {
    // Reload data
    _loadingStatus = 1;
    [self requestDataSuccess:data];
    
    // Scroll to the top
//    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)loadData {
    if ([self canStartNewLoading]) {
        _loadingStatus = 1;
        [self.model getTopicsList:self.uri];
    }
}

- (void)loadTopic:(NSString *)URI {
    if ([self canStartNewLoading]) {
        _loadingStatus = 2;
        [self showProgressView];
        
        [self.model getTopicWithLinkURI:URI];
    }
}

- (void)requestDataSuccess:(id)dataObject {
    NSLog(@"test");
    if (_loadingStatus == 1) {
        [self handleListData:dataObject];
    } else {
        // Check if need to log in
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:dataObject];
        NSArray *messageArray = [doc searchWithXPathQuery:@"//div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='message']"];
        if ([messageArray count] > 0) {
            if ([[[messageArray objectAtIndex:0] text] isEqualToString:@"查看本主题需要登录"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查看本主题需要登录" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            } else {
                [self pushToSingleTopicViewController:dataObject];
            }
        } else {
                [self pushToSingleTopicViewController:dataObject];
        }
    }
    [super requestDataSuccess:dataObject];

}

- (void)pushToSingleTopicViewController:(NSData *)dataObject {
    V2EXSingleTopicViewController *singleTopicController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"singleTopicController"];
    [singleTopicController loadNewTopicWithData:dataObject];
    [self.navigationController pushViewController:singleTopicController animated:YES];
}

- (void)requestDataFailure:(NSString *)errorMessage {
    [super requestDataFailure:errorMessage];
}

- (void) handleListData:(id)dataObject {
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
        
        // Handle reply count
        NSString *replyCount;
        if ([replyElements count] > 0)
        {
            TFHppleElement *replyElement = [replyElements objectAtIndex:0];
            replyCount = [replyElement text];
        } else {
            replyCount = @"0";
        }
        
        NSString *link = [[[element searchWithXPathQuery:@"//td[3]/span[@class='item_title']/a"] objectAtIndex:0] objectForKey:@"href"];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [V2EXStringUtil hanldeAvatarURL:[avatarElement objectForKey:@"src"]], @"avatar",
                              [titleElement text], @"title",
                              [userNameElement text], @"username",
                              replyCount, @"replies",
                              link, @"link", nil
                              ];
        [self.data addObject:dict];
    }
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

- (NSString *)link2TopicID:(NSString *) urlString{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/t/[0-9]+#reply"
                                                                           options:0
                                                                            error:&error];
    if (regex != nil) {
        NSArray *array = [regex matchesInString: urlString
                                        options: 0
                                          range: NSMakeRange( 0, [urlString length])];
        if ([array count] > 0) {
            NSTextCheckingResult *match = [array objectAtIndex:0];
            NSRange firstHalfRange = [match rangeAtIndex:0];
            NSString *result = [[[urlString substringWithRange:firstHalfRange] stringByReplacingOccurrencesOfString:@"/t/" withString:@""] stringByReplacingOccurrencesOfString:@"#reply" withString:@""];
            return result;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [indexPath row];
    [self loadTopic:[[self.data objectAtIndex:index] objectForKey:@"link"]];
}

@end
