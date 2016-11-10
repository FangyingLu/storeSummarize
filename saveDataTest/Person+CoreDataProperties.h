//
//  Person+CoreDataProperties.h
//  saveDataTest
//
//  Created by Lufangying on 16/11/7.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
