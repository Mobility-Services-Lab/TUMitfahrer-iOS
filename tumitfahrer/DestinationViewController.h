//
//  DestinationViewController.h
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

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;

@protocol DestinationViewControllerDelegate

-(void)selectedDestination:(NSString *)destination coordinate:(CLLocationCoordinate2D)coordinate indexPath:(NSIndexPath*)indexPath;

@end

@interface DestinationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id <DestinationViewControllerDelegate> delegate;
@property (nonatomic) NSIndexPath *rideTableIndexPath;
@property (nonatomic, strong) NSMutableArray *predefinedDestinations;
@property (nonatomic, strong) NSMutableArray *headers;

@end
