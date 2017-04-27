//
//  NSURLSessionConfiguration+TYURLProtocol.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "NSURLSessionConfiguration+TYURLProtocol.h"
#import <objc/runtime.h>
#import "TYURLProtocol.h"

static BOOL isHookWorking = NO;

@implementation NSURLSessionConfiguration (TYURLProtocol)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
        Method origMethod = class_getInstanceMethod(cls, @selector(protocolClasses));
        Method replMethod = class_getInstanceMethod(self, @selector(ty_protocolClasses));
        if (origMethod && replMethod) {
            if (class_addMethod(cls, @selector(protocolClasses), method_getImplementation(replMethod), method_getTypeEncoding(replMethod)))
            {
                class_replaceMethod(self, @selector(ty_protocolClasses), method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
            }
            else
            {
                method_exchangeImplementations(origMethod, replMethod);
            }
        }
    });

}

- (NSArray <Class>*)ty_protocolClasses {
    if (!isHookWorking) {
        return [self ty_protocolClasses];
    }
    NSMutableArray *array = [[self ty_protocolClasses] mutableCopy];
    if (array.count == 0) {
        return @[[TYURLProtocol class]];
    }
    if (![array containsObject:[TYURLProtocol class]]) {
        [array insertObject:[TYURLProtocol class] atIndex:0];
    }
    
    return array;
}

+ (void)start {
    isHookWorking = YES;
}

+ (void)stop {
    isHookWorking = NO;
}

@end
