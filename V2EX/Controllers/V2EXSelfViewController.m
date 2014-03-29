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
#import "TFHpple+V2EXMethod.h"
#import <UIImageView+WebCache.h>
#import <NSAttributedString+HTML.h>

#import "V2EXMyTopicsViewController.h"
#import "V2EXMyRepliesViewController.h"
#import "V2EXNotificationCenterViewController.h"

@interface V2EXSelfViewController ()

@end

@implementation V2EXSelfViewController

+ (V2EXSelfViewController *)sharedController
{
    static V2EXSelfViewController *_sharedLatestTopicsViewControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedLatestTopicsViewControllerInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"selfController"];
    });
    
    return _sharedLatestTopicsViewControllerInstance;
}

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
    _lastLoadUserInformationTime = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [self prepareForUserInfo];
}

- (void)prepareForUserInfo {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if (![[[userDefaultes stringForKey:@"saved_username"] uppercaseString] isEqualToString:[_currentUsername uppercaseString]]) {
        _lastLoadUserInformationTime = 0;
        NSLog(@"'%@' set '%@'", [[userDefaultes stringForKey:@"saved_username"] uppercaseString], [_currentUsername uppercaseString]);
    }
    _currentUsername = [[userDefaultes stringForKey:@"saved_username"] mutableCopy];
    
    if (([[NSDate date] timeIntervalSince1970] - _lastLoadUserInformationTime) > 86400) {
        // TODO: Produce more viable way to decide if reload data
        _loadingStatus = 4;
    
        if (_currentUsername) {
            [_model getUserInfo:_currentUsername];
            [self showProgressView];
        } else {
            [self pushToUserLoginController];
        }
    }
}

- (void)pushToUserLoginController {
    [self showMessage:@"您尚未登录，请登录"];
    V2EXUserLoginViewController *userLoginController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"userLoginController"];
    userLoginController.isLoadFromSeflController = YES;
    [self.navigationController pushViewController:userLoginController animated:YES];
}


- (void)requestDataSuccess:(id)dataObject {
    switch (_loadingStatus) {
        case 1:
        {
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:dataObject];
            V2EXMyTopicsViewController *myTopicsController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"myTopicsController"];
            [myTopicsController setDoc:doc];
            [self.navigationController pushViewController:myTopicsController animated:YES];
        }
            break;
        case 2:
        {
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:dataObject];
            V2EXMyRepliesViewController *myTopicsController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"myRepliesController"];
            [myTopicsController setDoc:doc];
            [self.navigationController pushViewController:myTopicsController animated:YES];
        }
            break;
        case 4:
        {
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:dataObject];
            if ([doc checkLogin]) {
                [self handleWithUserPage:doc];
            } else {
                [self pushToUserLoginController];
            }
        }
            break;
        default:
            break;
    }
    
    [self enableAllButtons];
}



- (void)requestDataFailure:(NSString *)errorMessage {
    [self enableAllButtons];
}

- (void)handleWithUserPage:(TFHpple *)doc {
    _lastLoadUserInformationTime = [[NSDate date] timeIntervalSince1970];
    
    self.usernameLabel.text = [self getValueForDoc:doc withXpath:@"//div[@class='inner']/table//tr/td[3]/h1"];
    
    NSURL *avatarURL = [NSURL URLWithString:[@"https:" stringByAppendingString:[[doc searchFirstElementWithXPathQuery:@"//img[@class='avatar']"] objectForKey:@"src"]]];
    // TODO: https
    [self.avatar setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"avatar_large"]];
    
    self.userMetaLabel.text = [[self getValueForDoc:doc withXpath:@"//table//td[@width='auto']//span[@class='gray']"] stringByReplacingOccurrencesOfString:@"V2EX " withString:@""];
    
//    NSString *socialInformationHTML = [[[doc searchFirstElementWithXPathQuery:@"//div[@class='inner']"] raw] stringByReplacingOccurrencesOfString:@" src=\"" withString:@"style=\"color:black;\" src=\"http://v2ex.com"];
//    self.userSocialInformationLabel.attributedString = [[NSAttributedString alloc] initWithHTMLData:[socialInformationHTML dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL];

}

- (NSString *)getValueForDoc:(TFHpple *)doc withXpath:(NSString *)xpath {
    return [[doc searchFirstElementWithXPathQuery:xpath] text];
}

// Next controllers:

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)myTopicsButtonClick:(id)sender {
    [self disableAllButtons];
    _loadingStatus = 1;
    [_model getUserTopics:_currentUsername];
}

- (IBAction)myRepliesButtonClick:(id)sender {
    [self disableAllButtons];
    _loadingStatus = 2;
    [_model getUserReplies:_currentUsername];
}

- (IBAction)notificationCenterButtonClick:(id)sender {
    [self disableAllButtons];
    _loadingStatus = 3;
    NSLog(@"Nothing 2 do");
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}

- (void)disableAllButtons {
    self.myTopicsButton.enabled = self.myRepliesButton.enabled = self.notificationCenterButton.enabled = NO;
    [self showProgressView];
}

- (void)enableAllButtons {
    _loadingStatus = 0;
    self.myTopicsButton.enabled = self.myRepliesButton.enabled = self.notificationCenterButton.enabled = YES;
//    [self hideProgressView];
}

@end
