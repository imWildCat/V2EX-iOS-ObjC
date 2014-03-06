//
//  V2EXReplyTopicViewController.m
//  V2EX
//
//  Created by WildCat on 3/5/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXReplyTopicViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import "TFHpple+V2EXMethod.h"

@interface V2EXReplyTopicViewController ()

@end

@implementation V2EXReplyTopicViewController

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
    
    if (self.topicID <= 0 || self.onceCode <= 0) {
        [self showMessage:@"您尚未登录，不能回复"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    _model = [[V2EXNormalModel alloc] initWithDelegate:self];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info= [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.replyContent.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - kbSize.height - 5);
}

- (void)requestDataSuccess:(id)dataObject {
    [self hideProgressView];
    
    TFHppleElement *replyFormElement = [[[TFHpple alloc] initWithHTMLData:dataObject] searchFirstElementWithXPathQuery:@"//div[@class='box']//div[@class='cell']//form"];
    
    if (replyFormElement) {
        NSUInteger responseTopicID = (NSUInteger)[[[replyFormElement objectForKey:@"action"] stringByReplacingOccurrencesOfString:@"/t/" withString:@""] integerValue];
        if (responseTopicID == self.topicID && responseTopicID > 0) {
            [self.lastController afterReplyTopic:dataObject];
            [self showMessage:@"回复成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    [self showMessage:@"回复失败，请重试"];
    return;
}

- (IBAction)doReply:(id)sender {
    [self showProgressView];
    [_model replyTopic:self.topicID andOnce:self.onceCode andContent:self.replyContent.text];
}

@end
