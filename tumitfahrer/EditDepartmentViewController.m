//
//  EditRepartmentViewController.m
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

#import "EditDepartmentViewController.h"
#import "FacultyManager.h"
#import "NavigationBarUtilities.h"
#import "CustomBarButton.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface EditDepartmentViewController ()

@property NSInteger chosenFaculty;

@end

@implementation EditDepartmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.chosenFaculty = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor customLightGray];
	[self.pickerView selectRow:[[FacultyManager sharedInstance] indexForFacultyName:[CurrentUser sharedInstance].user.department] inComponent:0 animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    
    // right button of the navigation bar
    CustomBarButton *rightBarButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[FacultyManager sharedInstance] allFaculties].count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenFaculty = row;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[FacultyManager sharedInstance] friendlyNameOfFacultyAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50.0f;
}

//[NSNumber numberWithInt:(int)self.chosenFaculty],

-(void)rightBarButtonPressed {
    User *user = [CurrentUser sharedInstance].user;
    NSString  *body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, [[FacultyManager sharedInstance] nameOfFacultyAtIndex: self.chosenFaculty], user.firstName, user.lastName, user.phoneNumber];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/users/%@",API_ADDRESS, [CurrentUser sharedInstance].user.userId]]];
	user.department = [[FacultyManager sharedInstance] nameOfFacultyAtIndex: self.chosenFaculty];
	
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your department has been changed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
    } else {
        [ActionManager showAlertViewWithTitle:@"Failure" description:@"An error occured changing your department. Please try again later."];
    }
    NSLog(@"EditDepartment-didRecieveResponse: %ld",(long)[httpResponse statusCode]);
    NSLog(@"EditDepartment-didRecieveResponse: %@",response.debugDescription);
    NSLog(@"EditDepartment-didRecieveResponse: %@",response.description);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [CurrentUser saveUserToPersistentStore:[CurrentUser sharedInstance].user];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"EditDepartment-connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"EditDepartment-Error: %@",error);
}
@end
