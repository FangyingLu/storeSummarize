//
//  Card+CoreDataProperties.m
//  saveDataTest
//
//  Created by Lufangying on 16/11/7.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import "Card+CoreDataProperties.h"

@implementation Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Card"];
}

@dynamic no;
@dynamic person;

@end
