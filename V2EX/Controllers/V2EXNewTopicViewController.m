//
//  V2EXNewTopicViewController.m
//  V2EX
//
//  Created by WildCat on 3/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNewTopicViewController.h"
#import "TFHpple+V2EXMethod.h"

@interface V2EXNewTopicViewController ()

@end

@implementation V2EXNewTopicViewController

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
	
    [self configureTextViewLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _originalTextViewFrame = self.topicContent.frame;
    
    _model = [[V2EXNormalModel alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self request4OnceCode];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTextViewLayout {
    [self.topicContent.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] CGColor]];
    [self.topicContent.layer setBorderWidth:1.0];
    
    self.topicContent.layer.cornerRadius = 5;
    self.topicContent.clipsToBounds = YES;
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
        CGRect newTextViewFrame = self.topicContent.frame;
        //        originalTextViewFrame = self.replyContent.frame;
        newTextViewFrame.size.height = keyboardTop - self.topicContent.frame.origin.y - 5;
        
        self.topicContent.frame = newTextViewFrame;
    } else {
        // Keyboard is going away (down) - restore original frame
        self.topicContent.frame = _originalTextViewFrame;
    }
    
    [UIView commitAnimations];
}

- (IBAction)newTopicButtonClick:(id)sender {
    [self showProgressView];
    if ((_lastRequestTime - [[NSDate date] timeIntervalSince1970]) >= 900
        || _once <= 0) {
        [self request4OnceCode];
    } else {
        [self request2PostNewTopic];
    }
}

- (void)request4OnceCode {
    if ([self.uri length] <= 0) {
        [self showMessage:@"意外错误，请重试"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [_model getNewTopicPage:self.uri];
}

- (void)request2PostNewTopic {
    if ([self.topicTitle.text length] <= 0) {
        [self showMessage:@"标题不能为空"];
        return;
    }
    
    self.rightButton.enabled = NO;
    
    NSLog(@"Posting new topic: %@, to node: %@", self.topicTitle.text, self.uri);
    [_model newTopic:self.uri andTitle:self.topicTitle.text andContent:self.topicContent.text andOnce:_once];
}

- (void)requestDataSuccess:(id)dataObject {
    if (_once <= 0) {
        [self hanldeOnceCode:dataObject];
        if (self.rightButton.enabled == NO) {
            [self request2PostNewTopic];
        }
    } else {
        [self handlePostRespondData:dataObject];
    }
}

- (void)hanldeOnceCode:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSString *onceCode = [[doc searchFirstElementWithXPathQuery:@"//input[@name='once']"] objectForKey:@"value"];
    _once = (NSUInteger)[onceCode integerValue];
}

- (void)handlePostRespondData:(NSData *)data {
    self.rightButton.enabled = YES;
    [self hideProgressView];
    [self.navigationController popViewControllerAnimated:NO];

    
    // TODO: Validation for new topic
//    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
//    NSString *newTopicTitle = [[doc searchFirstElementWithXPathQuery:@"//div[@class='header']/h1"] text];
//    if (newTopicTitle == self.topicTitle.text) {

//    BOOL isSuccess = [[@" " stringByAppendingString:newTopicTitle] stringByAppendingString:@" "] == self.topicTitle.text;
    [self.lastController afterCreateTopic:data];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    }
}

- (void)requestDataFailure:(NSString *)errorMessage {
    _once = 0;
    self.rightButton.enabled = YES;
}

- (void)setOnceValue:(NSUInteger)once {
    _once = once;
    _lastRequestTime = [[NSDate date] timeIntervalSince1970];
}


@end
