//
//  V2EXSingleTopicViewController.m
//  V2EX
//
//  Created by WildCat on 2/19/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXSingleTopicViewController.h"
#import <TFHpple.h>
#import "V2EXStringUtil.h"
#import "V2EXSingleTopicCell.h"

@interface V2EXSingleTopicViewController ()

@end

@implementation V2EXSingleTopicViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

+ (V2EXSingleTopicViewController *)sharedController
{
    static V2EXSingleTopicViewController *_sharedSingleTopicViewControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedSingleTopicViewControllerInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"singleTopicController"];
    });
    
    return _sharedSingleTopicViewControllerInstance;
}

- (void)loadNewTopicWithData:(NSData *)data {
    [self requestDataSuccess:data];
}

- (void)loadNewTopicWithID:(NSUInteger *)ID {
    //TODO:not implementation yet
}

- (void)requestDataSuccess:(id)dataObject {
    [self handleTopicData:dataObject];
    
    [super requestDataSuccess:dataObject];
}

- (void)handleTopicData:(NSData *)dataObject {
    self.data = [[NSMutableArray alloc] init];
    
    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:dataObject];
    
    NSString *title = [[[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/h1"] objectAtIndex:0] text];
    self.navigationItem.title = title;
    
    NSString *authorUsername = [[[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/small/a"] objectAtIndex:0] text];
    NSString *authorTime = [[[[[[[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/small"] objectAtIndex:0] raw] stringByReplacingOccurrencesOfString:@"<small class=\"gray\">By " withString:@""] stringByReplacingOccurrencesOfString:[[[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/small/a"] objectAtIndex:0] raw] withString:@""] stringByReplacingOccurrencesOfString:@" at " withString:@""] stringByReplacingOccurrencesOfString:@"</small>" withString:@""];
    NSString *authorAvatar = [[[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/div[@class='fr']/a/img[@class='avatar']"] objectAtIndex:0] objectForKey:@"src"];
    NSString *authorContent;
    if ([[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='cell']/div[@class='topic_content']"] count] > 0) {
        authorContent = [[[[[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='cell']/div[@class='topic_content']"] objectAtIndex:0] raw] stringByReplacingOccurrencesOfString:@"<div class=\"topic_content\">" withString:@""] stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    } else {
        authorContent = @"";
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          authorUsername, @"username",
                          authorTime, @"time",
                          [V2EXStringUtil hanldeAvatarURL:authorAvatar], @"avatar",
                          authorContent, @"content", nil
                          ];
    [self.data addObject:dict];
    
    NSArray *replyArray = [doc searchWithXPathQuery:@"//div[@class='cell']//table|//div[@class='inner']//table|//div[@class='cell collapsed']//table"];
    for (TFHppleElement *singleReply in replyArray) {
        NSString *replyUsername = [[[singleReply searchWithXPathQuery:@"//td[3]/strong/a"] objectAtIndex:0] text];
        NSString *replyTime = [[[singleReply searchWithXPathQuery:@"//td[3]/span[@class='fade small']"] objectAtIndex:0] text];
        NSString *replyAvatar = [[[singleReply searchWithXPathQuery:@"//td[1]/img"] objectAtIndex:0] objectForKey:@"src"];
        NSString *replyContent = [[[[[singleReply searchWithXPathQuery:@"//td[3]/div[@class='reply_content']"] objectAtIndex:0] raw]
                                   stringByReplacingOccurrencesOfString:@"<div class=\"reply_content\">" withString:@""] stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              replyUsername, @"username",
                              replyTime, @"time",
                              [V2EXStringUtil hanldeAvatarURL:replyAvatar], @"avatar",
                              replyContent, @"content", nil
                              ];
        [self.data addObject:dict];
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath row];
    static NSString *CellIdentifier = @"replyCell";
    
    UINib *nib = [UINib nibWithNibName:@"V2EXSingleTopicCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    V2EXSingleTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *rowData = [self.data objectAtIndex:index];
    
    cell.userName.text = [rowData objectForKey:@"username"];
    cell.replyTime.text = [rowData objectForKey:@"time"];
    [cell.avatar setImageWithURL:[rowData objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"avatar_large"]];
    cell.content.text = [rowData objectForKey:@"content"];
    
    return cell;
}

@end
