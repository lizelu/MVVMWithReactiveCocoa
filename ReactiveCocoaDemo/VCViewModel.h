//
//  VCViewModel.h
//  ReactiveCocoaDemo
//
//  Created by Mr.LuDashi on 15/10/19.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCViewModel : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id) buttonIsValid;
- (void)login;
@end
