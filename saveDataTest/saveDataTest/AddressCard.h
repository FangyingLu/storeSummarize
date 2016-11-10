//
//  AddressCard.h
//  saveDataTest
//
//  Created by Lufangying on 16/10/20.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Email;
@interface AddressCard : NSObject<NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Email *emailObj;
@property (nonatomic, assign) NSInteger salary;

@end

@interface Email : NSObject<NSCoding>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *emailDisplay;

@end
