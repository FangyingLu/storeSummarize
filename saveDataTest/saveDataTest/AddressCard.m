//
//  AddressCard.m
//  saveDataTest
//
//  Created by Lufangying on 16/10/20.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import "AddressCard.h"

#define kAddressCardName @"AddressCard_name"
#define kAddressCardEmail @"AddressCard_email"
#define kAddressCardSalary @"AddressCard_salary"
#define kEmailName @"emailName"
#define kEmailDisplay @"emailDisplay"

@implementation AddressCard

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:kAddressCardName];
    [aCoder encodeObject:_emailObj forKey:kAddressCardEmail];
    [aCoder encodeInteger:_salary forKey:kAddressCardSalary];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _name = [aDecoder decodeObjectForKey:kAddressCardName];
    _emailObj = [aDecoder decodeObjectForKey:kAddressCardEmail];
    _salary = [aDecoder decodeIntegerForKey:kAddressCardSalary];
    return self;
}

@end


@implementation Email
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_email forKey:kEmailName];
    [aCoder encodeObject:_emailDisplay forKey:kEmailDisplay];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _email =  [aDecoder decodeObjectForKey:kEmailName];
    _emailDisplay = [aDecoder decodeObjectForKey:kEmailDisplay];
    return self;
}

@end
