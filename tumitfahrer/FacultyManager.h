//
//  Faculty.h
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

#import <Foundation/Foundation.h>

/**
 *  A singleton class that stores the Factulty objects.
 */
@interface FacultyManager : NSObject

+(instancetype)sharedInstance;

/**
 *  Retuns all faculties.
 *
 *  @return Array with all faculties.
 */
- (NSArray *)allFaculties;

/**
 *  Returns name of the faculty for a given faculty id.
 *
 *  @param index Id of the faculty.
 *
 *  @return Name of the faculty.
 */
- (NSString *)nameOfFacultyAtIndex:(NSInteger)index;
/**
 *  Returns friendly name of the faculty for a given faculty id.
 *
 *  @param index Id of the faculty.
 *
 *  @return friendlyName of the faculty.
 */
- (NSString *)friendlyNameOfFacultyAtIndex:(NSInteger)index;
/**
 *  Returns id of the faculty for the given name.
 *
 *  @param name Name of the faculty.
 *
 *  @return Id of the faculty.
 */
- (NSInteger)indexForFacultyName:(NSString *)name;
/**
 *  Returns name of the faculty for the given friendly name.
 *
 *  @param name Name of the faculty.
 *
 *  @return friendlyName of the faculty.
 */
- (NSString *)nameForFacultyFriendlyName:(NSString *)friendlyName;
/**
 *  Returns id of the faculty for the given friendly name.
 *
 *  @param friendlyName friendlyName of the faculty.
 *
 *  @return Id of the faculty.
 */
- (NSInteger)indexForFacultyFriendlyName:(NSString *)FriendlyName;

/**
 *  Returns friendlyName of the faculty for the given name.
 *
 *  @param friendlyName friendly name of the faculty.
 *
 *  @return name of the faculty.
 */
- (NSString *)friendlyNameForFacultyName:(NSString *)name;

@end
