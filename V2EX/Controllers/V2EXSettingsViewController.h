//
//  V2EXSettingsViewController.h
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface V2EXSettingsViewController : UIViewController

+ (V2EXSettingsViewController *)sharedController;
- (IBAction)showMenu:(id)sender;

@end
