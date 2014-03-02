//
//  V2EXSelfViewController.m
//  V2EX
//
//  Created by WildCat on 3/1/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXSelfViewController.h"
#import "V2EXUserLoginViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import <TFHpple.h>
#import "V2EXUserUtil.h"
#import <UIImageView+WebCache.h>
#import <NSAttributedString+HTML.h>

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
    _model = [[V2EXNormalModel alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
     [self prepareForUserInfo];
}

- (void)prepareForUserInfo {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaultes stringForKey:@"saved_username"];
    
    if (username) {
        [_model getUserInfo:username];
        [self showProgressView];
    } else {
        [self pushToUserLoginController];
    }
}

- (void)pushToUserLoginController {
    [self showMessage:@"您尚未登录，请登录"];
    V2EXUserLoginViewController *userLoginController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"userLoginController"];
    userLoginController.isLoadFromSeflController = YES;
    [self.navigationController pushViewController:userLoginController animated:YES];
}


- (void)requestDataSuccess:(id)dataObject {
    [self hideProgressView];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:dataObject];
    if ([V2EXUserUtil isLogin:doc]) {
        [self handleWithUserPage:doc];
    } else {
        [self pushToUserLoginController];
    }
}

- (void)handleWithUserPage:(TFHpple *)doc {
    self.usernameLabel.text = [self getValueForDoc:doc withXpath:@"//div[@class='inner']/table//tr/td[3]/h1"];
    
    NSURL *avatarURL = [NSURL URLWithString:[@"https:" stringByAppendingString:[[[doc searchWithXPathQuery:@"//img[@class='avatar']"] objectAtIndex:0] objectForKey:@"src"]]];
    // TODO: https
    [self.avatar setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"avatar_large"]];
    
    self.userMetaLabel.text = [[self getValueForDoc:doc withXpath:@"//table//td[@width='auto']//span[@class='gray']"] stringByReplacingOccurrencesOfString:@"V2EX " withString:@""];
    
    NSString *socialInformationHTML = [[[[doc searchWithXPathQuery:@"//div[@class='inner']"] objectAtIndex:1] raw] stringByReplacingOccurrencesOfString:@" src=\"" withString:@"style=\"color:black;\" src=\"http://v2ex.com"];
//    NSString *socialInformationHTML = @"<b>sda</b>";
    self.userSocialInformationLabel.attributedString = [[NSAttributedString alloc] initWithHTMLData:[socialInformationHTML dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL];

}

- (NSString *)getValueForDoc:(TFHpple *)doc withXpath:(NSString *)xpath {
    return [[[doc searchWithXPathQuery:xpath] objectAtIndex:0] text];
}


- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}
@end
