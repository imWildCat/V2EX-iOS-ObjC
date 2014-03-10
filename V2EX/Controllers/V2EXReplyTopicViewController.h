//
//  V2EXReplyTopicViewController.h
//  V2EX
//
//  Created by WildCat on 3/5/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V2EXNormalModel.h"
#import "V2EXAfterTopicActionDelegate.h"

@interface V2EXReplyTopicViewController : UIViewController <V2EXRequestDataDelegate>
{
    V2EXNormalModel *_model;
    
    CGRect _originalTextViewFrame;
}

@property (nonatomic, assign) id<V2EXAfterTopicActionDelegate> lastController;
@property (strong, nonatomic) IBOutlet UITextView *replyContent;
@property (nonatomic) NSUInteger topicID;
@property (nonatomic) NSUInteger onceCode;

- (IBAction)doReply:(id)sender;

@end
