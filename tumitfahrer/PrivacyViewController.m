//
//  PrivacyViewController.m
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

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@property NSArray *licensesArray;
@property NSArray *privacyArray;
@property NSArray *termsArray;

@end

@implementation PrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSString* license = [[NSBundle mainBundle] pathForResource:@"OpenSourceProjects" ofType:@"txt"];
        self.licensesArray = [NSArray arrayWithObjects:license, nil];
        NSString* privacy1 = [[NSBundle mainBundle] pathForResource:@"Privacy" ofType:@"txt"];
        self.privacyArray = [NSArray arrayWithObjects:privacy1, nil];
		NSString* terms1 = [[NSBundle mainBundle] pathForResource:@"Terms" ofType:@"txt"];
		self.termsArray = [NSArray arrayWithObjects:terms1, nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    if (self.privacyViewTypeEnum == Licenses) {
        for(int i = 0; i< self.licensesArray.count; i++) {
            NSString *license = [NSString stringWithContentsOfFile:[self.licensesArray objectAtIndex:i] encoding:NSUTF8StringEncoding error:nil];
            
            self.contentTextView.text = [self.contentTextView.text stringByAppendingString:license];
        }
	} else if (self.privacyViewTypeEnum == Terms) {
		for(int i = 0; i< self.termsArray.count; i++) {
			NSString *terms = [NSString stringWithContentsOfFile:[self.termsArray objectAtIndex:i] encoding:NSUTF8StringEncoding error:nil];
			
			self.contentTextView.text = [self.contentTextView.text stringByAppendingString:terms];
		}
    } else {
        for(int i = 0; i< self.privacyArray.count; i++) {
            NSString *privacy = [NSString stringWithContentsOfFile:[self.privacyArray objectAtIndex:i] encoding:NSUTF8StringEncoding error:nil];
            
            self.contentTextView.text = [self.contentTextView.text stringByAppendingString:privacy];
        }
    }
}

@end
