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

- (void)initDb {
    if (!self.db) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"db/v2ex_normal.db"];
        _db = [FMDatabase databaseWithPath:dbPath];
        [_db open];
        NSLog(@"initdb");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 70; // TODO: Why don't storyboard support rowHeight?
    
    [self loadNewNode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewNode {
    // Set title
    [self initDb];
    
    FMResultSet *retSet = [_db executeQuery:@"SELECT title FROM nodes WHERE uri = ?",self.uri];
    [retSet next];
    self.navigationItem.title = [retSet stringForColumn:@"title"];
    
    // Reload data
    [self requestDataSuccess:self.data];
}

- (void)loadData {
    [self.model getTopicsList:self.uri];
}

- (void)requestDataSuccess:(id)dataObject {
    self.data = [[NSMutableArray alloc] init];
    
    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:dataObject];
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
    NSLog(@"%i",index);
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
