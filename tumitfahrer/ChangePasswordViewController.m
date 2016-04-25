//
//  ChangePasswordViewController.m
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

#import "ChangePasswordViewController.h"
#import "ConnectionManager.h"
#import "ActionManager.h"
#import "CurrentUser.h"


@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"ChangePassword" owner:self options:nil] objectAtIndex:0];
	[_currentPW setDelegate:self];
	[_changedPW setDelegate:self];
	[_repeatChangedPW setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == _currentPW) {
		[_changedPW becomeFirstResponder];
	} else if (textField == _changedPW) {
		[_repeatChangedPW becomeFirstResponder];
	} else {
		[textField resignFirstResponder];
		return YES;
	}
	
	return YES;
}

- (IBAction)cancel:(id)sender {
    NSLog(@"cancel");
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
	//Check Internet Connection, prompts an alert if no connection is available
    [ConnectionManager serverIsOnline:YES];//Making sure we are connected

    //PW need 6 signs and they need to match
    NSString *np = self.changedPW.text;
    NSString *nprepeat = self.repeatChangedPW.text;
    NSString *oldpw = self.currentPW.text;
    
    if(![np isEqual:nprepeat]){
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"New Passwords don't match"];
        return;
    }
    if([np length] < 4){
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Password needs to be at least 4 characters long"];
        return;
    }
    
    //The old pw is checked via the authorization string
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [CurrentUser sharedInstance].user.email, oldpw];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding ];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    //
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_ADDRESS, API_CHANGE_PASSWORD]]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:[[NSString stringWithFormat:@"{\"password\":\"%@\"}",np] dataUsingEncoding:NSUTF8StringEncoding]];//[NSKeyedArchiver archivedDataWithRootObject:@{@"password":np}]];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode]==200){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your password has been changed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
    } else if ([httpResponse statusCode] == 400){
        [ActionManager showAlertViewWithTitle:@"Error" description:@"Your old password was incorrect"];
    } else {
        [ActionManager showAlertViewWithTitle:@"Error" description:@"An error occured changing your password, please try again later"];
    }
    NSLog(@"ChangePasswordViewController-didRecieveResponse: %ld",(long)[httpResponse statusCode]);
    NSLog(@"ChangePasswordViewController-didRecieveResponse: %@",response.debugDescription);
    NSLog(@"ChangePasswordViewController-didRecieveResponse: %@",response.description);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"ChangePasswordViewController-connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ChangePasswordViewController-Error: %@",error);
}
//printf("%s", [@"BLAAAAAAAA" UTF8String]);
@end
