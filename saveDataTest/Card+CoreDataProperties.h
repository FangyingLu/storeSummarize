//
//  Card+CoreDataProperties.h
//  saveDataTest
//
//  Created by Lufangying on 16/11/7.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import "Card+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *no;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
