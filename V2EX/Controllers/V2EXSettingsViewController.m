//
//  V2EXSettingsViewController.m
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXSettingsViewController.h"

@interface V2EXSettingsViewController ()

@end

@implementation V2EXSettingsViewController

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

+ (V2EXSettingsViewController *)sharedController
{
    static V2EXSettingsViewController *_sharedSettingsViewControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedSettingsViewControllerInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"settingsController"];
    });
    
    return _sharedSettingsViewControllerInstance;
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}
@end
