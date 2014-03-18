//
//  V2EXNewTopicViewController.h
//  V2EX
//
//  Created by WildCat on 3/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V2EXRequestDataDelegate.h"

@interface V2EXNewTopicViewController : UIViewController <V2EXRequestDataDelegate>
{
    CGRect _originalTextViewFrame;
    
    NSUInteger _once;
    
    NSUInteger _lastRequestTime;
}

@property (strong, nonatomic) IBOutlet UITextField *topicTitle;
@property (strong, nonatomic) IBOutlet UITextView *topicContent;
@property (strong, nonatomic) NSString *uri;

@end
