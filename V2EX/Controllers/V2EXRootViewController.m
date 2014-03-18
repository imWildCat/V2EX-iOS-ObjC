//
//  V2EXViewController.m
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXRootViewController.h"
#import "V2EXMenuViewController.h"

@interface V2EXRootViewController ()

@end

@implementation V2EXRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    // The first sub view controller is according to contentController
    
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = (V2EXMenuViewController *)self.menuViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
