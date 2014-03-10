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

@end
