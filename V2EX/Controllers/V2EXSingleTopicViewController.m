//
//  V2EXSingleTopicViewController.m
//  V2EX
//
//  Created by WildCat on 2/19/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXSingleTopicViewController.h"
#import "TFHpple+V2EXMethod.h"
#import "V2EXStringUtil.h"
#import "UIView+FrameMethods.h"
#import <NSAttributedString+HTML.h>
#import <DTAttributedTextCell.h>
#import <UIImageView+WebCache.h>
#import "UIViewController+V2EXJump.h"
#import "V2EXReplyTopicViewController.h"

// identifier for cell reuse
NSString * const AttributedTextCellReuseIdentifier = @"AttributedTextCellReuseIdentifier";

@interface V2EXSingleTopicViewController ()

@end

@implementation V2EXSingleTopicViewController {
    BOOL _useStaticRowHeight;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.tableView.rowHeight = 70; // TODO: Why don't storyboard with identifiertopicListInSingleNodeController support rowHeight?
    
//    _cellCache = [[NSCache alloc] init];
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

- (void)loadNewTopicWithID:(NSUInteger)ID {
    if (!self.data) {
        [self showProgressView];
    } else {
        [self setData:nil];
        _cellCache = nil;
        
        self.data = [[NSMutableArray alloc] init];
        _cellCache = [[NSCache alloc] init];
    }
    
    [self.model getTopicWithID:ID];
}

- (void)loadData {
    [self loadNewTopicWithID:_topicID];
}

- (void)requestDataSuccess:(id)dataObject {
    [self handleTopicData:dataObject];
    
    [super requestDataSuccess:dataObject];
}

- (void)handleTopicData:(NSData *)dataObject {
    self.data = [[NSMutableArray alloc] init];
    
    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:dataObject];
    
    NSString *title = [[doc searchFirstElementWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/h1"] text];
    self.navigationItem.title = title;
    
    // topic id
    NSUInteger topicID = (NSUInteger)[[[[doc searchFirstElementWithXPathQuery:@"//form"] objectForKey:@"action"] stringByReplacingOccurrencesOfString:@"/t/" withString:@""] integerValue];
    _topicID = topicID;
    
    // once code
    NSString *onceCodeString = [[doc searchFirstElementWithXPathQuery:@"//div[@class='box']//input[@name='once']"] objectForKey:@"value"];
    _onceCode = (NSUInteger)[onceCodeString intValue];

    NSString *authorUsername = [[doc searchFirstElementWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/small/a"] text];
    NSString *authorTime = [[[[[[[doc searchFirstElementWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/small"] raw] stringByReplacingOccurrencesOfString:@"<small class=\"gray\">By " withString:@""] stringByReplacingOccurrencesOfString:[[doc searchFirstElementWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/small/a"] raw] withString:@""] stringByReplacingOccurrencesOfString:@" at " withString:@""] stringByReplacingOccurrencesOfString:@"</small>" withString:@""] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<a class=\"op\" href=\"/append/topic/%i\">APPEND</a>", _topicID] withString:@""];
    NSString *authorAvatar = [[doc searchFirstElementWithXPathQuery:@"//div[@id='Wrapper']//div[@class='header']/div[@class='fr']/a/img[@class='avatar']"] objectForKey:@"src"];
    NSString *authorContent;
    if ([[doc searchWithXPathQuery:@"//div[@id='Wrapper']//div[@class='cell']/div[@class='topic_content']"] count] > 0) {
        authorContent = [[[[doc searchFirstElementWithXPathQuery:@"//div[@id='Wrapper']//div[@class='cell']/div[@class='topic_content']"] raw] stringByReplacingOccurrencesOfString:@"<div class=\"topic_content\">" withString:@""] stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
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
        NSString *replyUsername = [[singleReply searchFirstElementWithXPathQuery:@"//td[3]/strong/a"] text];
        NSString *replyTime = [[singleReply searchFirstElementWithXPathQuery:@"//td[3]/span[@class='fade small']"] text];
        NSString *replyAvatar = [[singleReply searchFirstElementWithXPathQuery:@"//td[1]/img"] objectForKey:@"src"];
        NSString *replyContent = [[[[singleReply searchFirstElementWithXPathQuery:@"//td[3]/div[@class='reply_content']"] raw]
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

#pragma mark UITableViewDataSource
- (void)configureCell:(DTAttributedTextCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = [self.data objectAtIndex:indexPath.row];
	
    NSString *formattedContent = [NSString stringWithFormat:@"<div style=\"font-size:15px;padding-top:50px;\">%@</div>", [rowData objectForKey:@"content"]];
	[cell setHTMLString:formattedContent];
	
    cell.accessoryType = UITableViewCellAccessoryNone;
	cell.attributedTextContextView.shouldDrawImages = YES;
    // TODO: support to display images in topics
    
    // Set user avatar
    UIImageView *userAvatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
    [userAvatarImgView setImageWithURL:[rowData objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"avatar_large"]];
    
//    [cell.imageView setImageWithURL:[rowData objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"avatar_large"]];
//    [userAvatarImgView setWidth:50 height:50];
    [userAvatarImgView.layer setCornerRadius:userAvatarImgView.frame.size.width/5];
    userAvatarImgView.layer.masksToBounds = YES;
    [cell addSubview:userAvatarImgView];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Set username
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 6, 240, 21)];
    usernameLabel.text = [rowData objectForKey:@"username"];
    usernameLabel.font = [UIFont systemFontOfSize:16];
//    usernameLabel.textAlignment = NSTextAlignmentRight;
    usernameLabel.textColor = [UIColor darkGrayColor];
    [cell addSubview:usernameLabel];
    
    // Set other info
    UILabel *otherInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 38, 240, 11)];
    otherInfoLabel.text = [rowData objectForKey:@"time"];
    otherInfoLabel.font = [UIFont systemFontOfSize:10];
    otherInfoLabel.textAlignment = NSTextAlignmentRight;
    otherInfoLabel.textColor = [UIColor darkGrayColor];
    [cell addSubview:otherInfoLabel];
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
	if (_useStaticRowHeight)
	{
		return tableView.rowHeight;
	}
	
	DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    
	return [cell requiredRowHeightInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
	
	return cell;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger index = [indexPath row];
//    static NSString *CellIdentifier = @"replyCell";
//    
//    UINib *nib = [UINib nibWithNibName:@"V2EXSingleTopicCell" bundle:nil];
//    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
//
//    V2EXSingleTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    NSDictionary *rowData = [self.data objectAtIndex:index];
//    
//    cell.userName.text = [rowData objectForKey:@"username"];
//    cell.replyTime.text = [rowData objectForKey:@"time"];
//    [cell.avatar setImageWithURL:[rowData objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"avatar_large"]];
//    
//
//	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:[[rowData objectForKey:@"content"] dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL];
//    cell.content.shouldDrawImages = YES;
//    // Don't use cell.content.delegate (But I don't know why not)
//    cell.content.textDelegate = self;
//    cell.content.attributedString = attributedString;
//    CGRect frame = cell.content.attributedTextContentView.frame;
//    CGSize size = cell.content.contentSize;
//    frame.size.height = size.height;
//    cell.content.frame = frame;
//    
//    return cell;
//}



//

#pragma mark Custom Views on Text


//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
//    NSLog(@"attachment");
//    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
////        imageView.contextView = attributedTextContentView;
////        imageView.delegate = self;
//        
//        // url for deferred loading
//        [imageView setImageWithURL:attachment.contentURL];
//        return imageView;
//    }
//    return nil;
//}

//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
//{
//    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
//	{
//        NSLog(@"draw image");
//		// if the attachment has a hyperlinkURL then this is currently ignored
//		DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
//		imageView.delegate = self;
//		
//		// sets the image if there is one
//		imageView.image = [(DTImageTextAttachment *)attachment image];
//		
//		// url for deferred loading
//		imageView.url = attachment.contentURL;
//		
//		
//		return imageView;
//	}
//	else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
//	{
//		DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
//		videoView.attachment = attachment;
//		
//		return videoView;
//	}
//	
//	return nil;
//}

// toReplyController
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"toReplyController"]) {
        if (_topicID > 0 && _onceCode > 0) {
            return YES;
        } else {
            [self showMessage:@"无法回复，可能因为您尚未登录"];
            return NO;
        }
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toReplyController"]) {
        V2EXReplyTopicViewController *replyController = [segue destinationViewController];
        replyController.lastController = self;
        replyController.topicID = _topicID;
        replyController.onceCode = _onceCode;
    }
}

// After reply
- (void)afterReplyTopic:(NSData *)data {
    [self requestDataSuccess:data];
}

@end
