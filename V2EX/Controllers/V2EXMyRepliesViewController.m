//
//  V2EXMyRepliesViewController.m
//  V2EX
//
//  Created by WildCat on 3/20/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXMyRepliesViewController.h"
#import <DTAttributedTextCell.h>
#import "V2EXStringUtil.h"
#define AttributedTextCellReuseIdentifier @"userRepliesListCell"

@interface V2EXMyRepliesViewController ()

@end

@implementation V2EXMyRepliesViewController

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
	// Do any additional setup after loading the view.
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"repliesList" ofType:@"css"];
    NSData   *cssData = [NSData dataWithContentsOfFile:path];
    _cssStyle = [[@"<style type=\"test/css\">" stringByAppendingString:[[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding]] stringByAppendingString:@"</style>"];
    
    _cellCache = [NSCache new];
    [self handleRepliesData];
    
}

- (void)handleRepliesData {
    self.data = [[NSMutableArray alloc] init];
    _topicLinkArray = [[NSMutableArray alloc] init];
    
    NSArray *repliesDockArray = [self.doc searchWithXPathQuery:@"//div[@class='dock_area']"];
    NSArray *repliesInnerArray = [self.doc searchWithXPathQuery:@"//div[@class='reply_content']"];
    for (int i = 0; i < [repliesDockArray count]; ++i) {
        NSString *row = [[[repliesDockArray objectAtIndex:i] raw] stringByAppendingString:[[repliesInnerArray objectAtIndex:i] raw]];
        [self.data addObject:row];
        
        NSString *link = [[[repliesDockArray objectAtIndex:i] searchFirstElementWithXPathQuery:@"//span[@class='gray']/a"] objectForKey:@"href"];
        [_topicLinkArray addObject:link?:@""];
    }
}

#pragma mark UITableViewDataSource
- (void)configureCell:(DTAttributedTextCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = [self.data objectAtIndex:indexPath.row];
	
    NSString *formattedContent = [_cssStyle stringByAppendingString:[NSString stringWithFormat:@"<div>%@</div>", rowData]];
	[cell setHTMLString:formattedContent];
	
    cell.accessoryType = UITableViewCellAccessoryNone;
	cell.attributedTextContextView.shouldDrawImages = YES;
}

- (BOOL)_canReuseCells
{
	// reuse does not work for variable height
	
	if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
	{
		return NO;
	}
	
	// only reuse cells with fixed height
	return YES;
}

- (DTAttributedTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
	// workaround for iOS 5 bug
	NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
	
	DTAttributedTextCell *cell = [_cellCache objectForKey:key];
    
	if (!cell)
	{
		if ([self _canReuseCells])
		{
			cell = (DTAttributedTextCell *)[tableView dequeueReusableCellWithIdentifier:AttributedTextCellReuseIdentifier];
		}
        
		if (!cell)
		{
			cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:AttributedTextCellReuseIdentifier];
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hasFixedRowHeight = NO;
		
		// cache it, if there is a cache
		[_cellCache setObject:cell forKey:key];
	}
	
	[self configureCell:cell forIndexPath:indexPath];
	
	return cell;
}

// disable this method to get static height = better performance
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    
	return [cell requiredRowHeightInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [indexPath row];
    NSUInteger topicID = [V2EXStringUtil link2TopicID:[_topicLinkArray objectAtIndex:index]];
    
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
