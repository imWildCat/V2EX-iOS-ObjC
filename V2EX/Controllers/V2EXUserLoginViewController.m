//
//  V2EXUserLoginViewController.m
//  V2EX
//
//  Created by WildCat on 3/1/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXUserLoginViewController.h"
#import <RESideMenu.h>
#import "UIViewController+MBProgressHUD.h"
#import <TFHpple.h>
//#import "V2EXGlobalCache.h"

@interface V2EXUserLoginViewController ()

@end

@implementation V2EXUserLoginViewController

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
    
    // Set request and response serializer
    _manager = [[AFHTTPSessionManager alloc] init];
    _requestSerializer = [AFHTTPRequestSerializer serializer];
    _responseSerializer = [AFHTTPResponseSerializer serializer];
    [_requestSerializer setValue:@"http://v2ex.com/signin" forHTTPHeaderField:@"Referer"];
    [_requestSerializer setValue:DEFAULT_USET_AGENT forHTTPHeaderField:@"User-Agent"];
    [_responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    _manager.requestSerializer = _requestSerializer;
    _manager.responseSerializer = _responseSerializer;
    
    [self loadSavedUserData];
    
    if (_isLoadFromSeflController) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
//        btn.image = [UIImage imageNamed:@"IconMenu"];
  
        self.navigationItem.leftBarButtonItem = btn;
    }
	
    // Do any additional setup after loading the view.
}

- (void)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)loadSavedUserData {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaultes stringForKey:@"saved_username"];
    NSString *password = [userDefaultes stringForKey:@"saved_password"];
    
    if (username) {
        self.usernameTextField.text = username;
        if (password) {
            self.passwordTextField.text = password;
            [self doLogin:nil];
        }
    }
}

- (IBAction)doLogin:(id)sender {

//    [_model userLoginWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text];
//    [self.navigationController popViewControllerAnimated:YES];
    if ([self.usernameTextField.text length] > 0 && [self.passwordTextField.text length] > 0) {
        [self prepareForLogin];
    } else {
        [self showMessage:@"请输入用户名和密码"];
    }
    
}

- (IBAction)resetPassword:(id)sender {
    //TODO: support https
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://v2ex.com/forgot"]];
}

#pragma mark - Login selector
- (void)prepareForLogin {
    [self showProgressView];
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    self.loginButton.enabled = NO;
    
    [_manager GET:@"http://v2ex.com/signin" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        TFHpple *doc = [[TFHpple alloc]initWithHTMLData:responseObject];
        
        NSString *next = [[[doc searchWithXPathQuery:@"//input[@name='next']"] objectAtIndex:0] objectForKey:@"value"];
        NSString *once = [[[doc searchWithXPathQuery:@"//input[@name='once']"] objectAtIndex:0] objectForKey:@"value"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:next, @"next", once, @"once", nil];
        
        
        [self performSelector:@selector(login:) withObject:dict afterDelay:1];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showLoginNetworkError:error];
    }];
    
}

- (void)login:(NSDictionary *)dict {
    [_manager POST:@"http://v2ex.com/signin" parameters:[NSDictionary dictionaryWithObjectsAndKeys:self.usernameTextField.text, @"u", self.passwordTextField.text, @"p",
                                                        [dict objectForKey:@"next"], @"next", [dict objectForKey:@"once"], @"once", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)[task response];
//        NSDictionary *headers = [response allHeaderFields];
        
//        NSLog(@"%@", headers);
        // TODO: Handle 302 redirect
        if (YES/*[headers objectForKey:@"Location"]*/) {
            [_manager GET:@"http://v2ex.com/signin" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [self validateLogin:responseObject];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showLoginNetworkError:error];
            }];
        } else {
            [self validateLogin:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showLoginNetworkError:error];
    }];
}

- (void)validateLogin:(NSData *)responseObject {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:responseObject];
    if ([self checkLogin:doc]) {
        [self showMessage:@"登录成功"];
        [self afterLogin];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //            NSLog(@"data:%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self showLoginPasswordError];
    }
}

- (BOOL)checkLogin:(TFHpple *)doc {
    NSArray *usernameArray = [doc searchWithXPathQuery:@"//div[@id='Top']//table//td[@width='auto']//a[@class='top']"];
    if ([usernameArray count] > 0) {
        NSString *username =[[[usernameArray objectAtIndex:0] objectForKey:@"href"] stringByReplacingOccurrencesOfString:@"/member/" withString:@""];
        if ([[username lowercaseString] isEqualToString:[self.usernameTextField.text lowercaseString]]) {
            NSLog(@"User log in: %@", username);
            return YES;
        }
    }
    return NO;
}

/**
 *  After Login set timestamp to "/user/lastlogin" in Global Cache
 *
 *  @param username current username
 */
- (void)afterLogin {
    [self saveUsernameAndPassword];
    [self finishLoginRequest];
}

/**
 *  Logout - Just clean the cookies
 */
+ (void)logout {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

- (void)finishLoginRequest {
    [self hideProgressView];
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    self.loginButton.enabled = YES;
}

// Handle error
- (void)showLoginNetworkError:(NSError *)error {
    [self finishLoginRequest];
    [self showMessage:@"登录过程中出现网络错误，请重试"];

    NSLog(@"[ERROR]Network Error during login action: %@", [error description]);
}

- (void)showLoginOtherError:(NSError *)error {
    [self finishLoginRequest];
    [self showMessage:@"无法检测您是否已经登录，请重试"];
    [V2EXUserLoginViewController logout];
    NSLog(@"[ERROR]Other Error(might about HTML DOM) during login action: %@", [error description]);
}

- (void)showLoginPasswordError {
    [self finishLoginRequest];
    [self showMessage:@"登录失败，密码错误"];
    [V2EXUserLoginViewController logout];
}

// Save username and password

- (void)saveUsernameAndPassword {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:self.usernameTextField.text forKey:@"saved_username"];
    [userDefaultes setObject:self.passwordTextField.text forKey:@"saved_password"];
    [userDefaultes synchronize];
}


@end
