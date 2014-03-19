//
//  V2EXNewTopicViewController.h
//  V2EX
//
//  Created by WildCat on 3/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MBProgressHUD.h"
#import "V2EXRequestDataDelegate.h"
#import "V2EXNormalModel.h"
#import "V2EXAfterTopicActionDelegate.h"

@interface V2EXNewTopicViewController : UIViewController <V2EXRequestDataDelegate>
{
    CGRect _originalTextViewFrame;
    
    NSUInteger _once;
    NSUInteger _lastRequestTime;
    
    V2EXNormalModel *_model;
}

@property (nonatomic, assign) id<V2EXAfterTopicActionDelegate> lastController;
@property (strong, nonatomic) IBOutlet UITextField *topicTitle;
@property (strong, nonatomic) IBOutlet UITextView *topicContent;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (strong, nonatomic) NSString *uri;

- (IBAction)newTopicButtonClick:(id)sender;

@end
