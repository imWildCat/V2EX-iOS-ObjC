//
//  V2EXNewTopicViewController.m
//  V2EX
//
//  Created by WildCat on 3/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNewTopicViewController.h"

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

@end
