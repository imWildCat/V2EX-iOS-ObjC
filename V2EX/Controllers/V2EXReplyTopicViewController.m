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
    
    [self configureTextViewLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _originalTextViewFrame = self.replyContent.frame;

    _model = [[V2EXNormalModel alloc] initWithDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
//    [self.replyContent becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self moveTextViewForKeyboard:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveTextViewForKeyboard:notification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (up == YES) {
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect newTextViewFrame = self.replyContent.frame;
//        originalTextViewFrame = self.replyContent.frame;
        newTextViewFrame.size.height = keyboardTop - self.replyContent.frame.origin.y - 5;
        
        self.replyContent.frame = newTextViewFrame;
    } else {
        // Keyboard is going away (down) - restore original frame
        self.replyContent.frame = _originalTextViewFrame;
    }
    
    [UIView commitAnimations];
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
    if ([self.replyContent.text length] > 0) {
        [self showProgressView];
        [_model replyTopic:self.topicID andOnce:self.onceCode andContent:self.replyContent.text];
    } else {
        [self showMessage:@"回复内容不能为空"];
    }
}

- (void)configureTextViewLayout {
    [self.replyContent.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] CGColor]];
    [self.replyContent.layer setBorderWidth:1.0];
    
    self.replyContent.layer.cornerRadius = 5;
    self.replyContent.clipsToBounds = YES;
}

@end
