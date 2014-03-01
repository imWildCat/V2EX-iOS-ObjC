//
//  V2EXSelfViewController.m
//  V2EX
//
//  Created by WildCat on 3/1/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXSelfViewController.h"

@interface V2EXSelfViewController ()

@end

@implementation V2EXSelfViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}
@end
