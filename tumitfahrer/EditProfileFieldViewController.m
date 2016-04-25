//
//  EditProfileFieldViewController.m
//  tumitfahrer
//
/*
 * Copyright 2015 TUM Technische Universität München
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
//

#import "EditProfileFieldViewController.h"
#import "CustomBarButton.h"
#import "NavigationBarUtilities.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface EditProfileFieldViewController ()

@property (nonatomic, strong) NSString *passwordString;

@end

@implementation EditProfileFieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    self.textView.delegate = self;
    self.passwordString = @"";
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.updatedFiled == Password) {
        self.textView.text = self.initialDescription = @"";
        [self.textView setSecureTextEntry:YES];
    } else {
        self.textView.text = self.initialDescription;
    }
    [self.textView becomeFirstResponder];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
    
    // right button of the navigation bar
    CustomBarButton *rightBarButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightBarButtonPressed {
    if (self.textView.text.length == 0) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Before saving changes, please fill in the text view"];
    }
    
    NSString *trimmedString = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *escapedString = [trimmedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // add enum
    NSString *body;
    User *user = [CurrentUser sharedInstance].user;
    switch (self.updatedFiled) {
        case FirstName:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, user.department, escapedString, user.lastName, user.phoneNumber];
            user.firstName = trimmedString;
            break;
        case LastName:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, user.department, user.firstName, escapedString, user.phoneNumber];
                user.lastName = trimmedString;
            break;
        case Phone:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, user.department, user.firstName, user.lastName, escapedString];
            user.phoneNumber = trimmedString;
            break;
        case Car:
           body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",escapedString, user.department, user.firstName, user.lastName, user.phoneNumber];
            user.car = trimmedString;
            break;
        case Department:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, escapedString, user.firstName, user.lastName, user.phoneNumber];
            user.car = trimmedString;
            break;
        default:
            break;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/users/%@",API_ADDRESS, [CurrentUser sharedInstance].user.userId]]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[CurrentUser sharedInstance].user.apiKey  forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];//[NSKeyedArchiver archivedDataWithRootObject:@{@"password":np}]];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode]==200){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your data has been changed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
    } else {
        [ActionManager showAlertViewWithTitle:@"Failure" description:@"An error occured changing your data, please try again later"];
    }
    NSLog(@"EditProfileField-didRecieveResponse: %ld",(long)[httpResponse statusCode]);
    NSLog(@"EditProfileField-didRecieveResponse: %@",response.debugDescription);
    NSLog(@"EditProfileField-didRecieveResponse: %@",response.description);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [CurrentUser saveUserToPersistentStore:[CurrentUser sharedInstance].user];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"EditProfileField-connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"EditProfileField-Error: %@",error);
}


-(void)textViewDidChange:(UITextView *)textView {
    
    if (self.updatedFiled == Password) {
        if (self.textView.text.length > self.passwordString.length) {
            self.passwordString = [self.passwordString stringByAppendingFormat:@"%c",[self.textView.text characterAtIndex:(self.textView.text.length-1)]];
            self.textView.text = [self.textView.text stringByReplacingCharactersInRange:NSMakeRange(self.textView.text.length-1,1) withString:@"●"];
        } else if(self.textView.text.length < self.passwordString.length && self.passwordString.length > 0) {
            self.passwordString = [self.passwordString stringByReplacingCharactersInRange:NSMakeRange(self.passwordString.length-1,1) withString:@""];
        }
    }
}

-(void)dealloc {
    self.textView.delegate = nil;
}
    
@end
