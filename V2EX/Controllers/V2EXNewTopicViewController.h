//
//  V2EXNewTopicViewController.h
//  V2EX
//
//  Created by WildCat on 3/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V2EXNewTopicViewController : UIViewController
{
    CGRect _originalTextViewFrame;
}

@property (strong, nonatomic) IBOutlet UITextField *topicTitle;
@property (strong, nonatomic) IBOutlet UITextView *topicContent;

@end
