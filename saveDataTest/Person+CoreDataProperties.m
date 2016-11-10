//
//  Person+CoreDataProperties.m
//  saveDataTest
//
//  Created by Lufangying on 16/11/7.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic age;
@dynamic name;
@dynamic card;

@end
