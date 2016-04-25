//
//  Faculty.m
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

#import "FacultyManager.h"
#import "Faculty.h"

@interface FacultyManager ()

@property (nonatomic, strong) NSMutableArray *facultyArray;

@end

@implementation FacultyManager

+(instancetype)sharedInstance {
    static FacultyManager *sharedFaculty = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFaculty = [[self alloc] init];
    });
    return sharedFaculty;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        self.facultyArray = [[NSMutableArray alloc] init];
        [self initFaculties];
    }
    return self;
}

-(void)initFaculties {
	[self.facultyArray addObject:[[Faculty alloc] initWithName:@"ARCHITECTURE" facultyId:0 friendlyName:@"Architecture"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"CHEMISTRY" facultyId:1 friendlyName:@"Chemistry"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"CIVIL_GEO" facultyId:2 friendlyName:@"Civil, Geo, Env. Eng."]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"ELECTRICAL" facultyId:3 friendlyName:@"Electrical Engineering"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"INFORMATICS" facultyId:4 friendlyName:@"Informatics"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"LIFE_FOOD" facultyId:5 friendlyName:@"Life and Food Science"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"MATHEMATICS" facultyId:6 friendlyName:@"Mathematics"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"MECHANICAL" facultyId:7 friendlyName:@"Mechnical Engineering"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"MEDICINE" facultyId:8 friendlyName:@"TUM School of Medicine"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"PHYSICS" facultyId:9 friendlyName:@"Physics"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"SPORT_AND_HEALTH" facultyId:10 friendlyName:@"Sport and Health Science"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"TUM_SCHOOL_OF_EDUCATION" facultyId:11 friendlyName:@"TUM School of Education"]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"TUM_SCHOOL_OF_MANAGEMENT" facultyId:12 friendlyName:@"TUM School of Management"]];
}

-(NSArray *)allFaculties {
    return self.facultyArray;
}

// return name of a specific faculty
-(NSString *)nameOfFacultyAtIndex:(NSInteger)index {
    if(index < 0 || index >= [self.facultyArray count])
        return @"";
    
    Faculty *faculty = [self.facultyArray objectAtIndex:index];
    return faculty.name;
}

-(NSString *)friendlyNameOfFacultyAtIndex:(NSInteger)index {
	if(index < 0 || index >= [self.facultyArray count])
		return @"";
	
	Faculty *faculty = [self.facultyArray objectAtIndex:index];
	return faculty.friendlyName;
}

-(NSInteger)indexForFacultyName:(NSString *)name {
    int index = 0;
    for (Faculty *faculty in self.facultyArray) {
        if ([faculty.name isEqualToString:name]) {
            return index;
        }
        index++;
    }
    return 0;
}

-(NSString *)nameForFacultyFriendlyName:(NSString *)friendlyName {
	int index = 0;
	for (Faculty *faculty in self.facultyArray) {
		if ([faculty.friendlyName isEqualToString:friendlyName]) {
			return faculty.name;
		}
		index++;
	}
	return @"";
}

-(NSInteger)indexForFacultyFriendlyName:(NSString *)friendlyName {
	int index = 0;
	for (Faculty *faculty in self.facultyArray) {
		if ([faculty.friendlyName isEqualToString:friendlyName]) {
			return index;
		}
		index++;
	}
	return 0;
}

-(NSString *)friendlyNameForFacultyName:(NSString *)name {
	int index = 0;
	for (Faculty *faculty in self.facultyArray) {
		if ([faculty.name isEqualToString:name]) {
			return faculty.friendlyName;
		}
		index++;
	}
	return @"";
}
@end
