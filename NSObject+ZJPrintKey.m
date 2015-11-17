//
//  NSObject+ZJPrintKey.m
//  
//
//  Created by MACMINI on 15/11/17.
//  Copyright (c) 2015年 LZJ. All rights reserved.
//

#import "NSObject+ZJPrintKey.h"
#import <objc/runtime.h>
@implementation NSObject (ZJPrintKey)
static char replaceDictionaryKey;
- (void)zj_dictionaryToLogUrlStr:(NSString *)urlStr andKey:(NSString *)key andKeyReplaceDictionary:(NSDictionary *)dict {
    if (!urlStr || urlStr.length == 0 || !key) {
        return;
    }
    objc_setAssociatedObject(self, &replaceDictionaryKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSLog(@"Loading......");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
        NSLog(@"Loaded");
        NSDictionary *temDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self findTheValue:key andDict:temDict];
    });
}
- (void)findTheValue:(NSString *)str andDict:(NSDictionary *)dict {
    NSArray *ak = dict.allKeys;
    for (NSString *keyName in ak) {
        if ([keyName isEqualToString:@"data"]) {
            NSLog(@"1");
            id tem = dict[keyName];
            NSDictionary *temDict = objc_getAssociatedObject(self, &replaceDictionaryKey);
            if ([tem isKindOfClass:[NSDictionary class]]) {
                [self handleDict:tem andKeyreplaces:temDict];
            }
            else if ([tem isKindOfClass:[NSArray class]]) {
                if ([tem count] >= 1) {
                    [self handleDict:tem[0] andKeyreplaces:temDict];
                }
            }
            else {
                NSLog(@"Format is not correct");
            }
            objc_setAssociatedObject(self, &replaceDictionaryKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return;
        }
        else {
            id tem = dict[keyName];
            if ([tem isKindOfClass:[NSDictionary class]]) {
                [self findTheValue:str andDict:tem];
            }
            else if ([tem isKindOfClass:[NSArray class]]) {
                if ([tem count] >= 1) {
                    [self findTheValue:str andDict:tem[0]];
                }
            }
            else {
                
            }
        }
    }
    NSLog(@"not found");
}
- (void)handleDict:(NSDictionary *)dict andKeyreplaces:(NSDictionary *)kDict {
    NSMutableString *mustr = [NSMutableString new];
    
    __block NSDictionary *temDict = kDict;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *temKey = temDict ? (temDict[key] ? temDict[key] : key) : key;
        if ([obj isKindOfClass:[NSNumber class]]) {
            [mustr appendString:[NSString stringWithFormat:@"@property (strong, nonatomic) NSNumber *%@;\n", temKey]];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            [mustr appendString:[NSString stringWithFormat:@"@property (strong, nonatomic) NSArray *%@;\n", temKey]];
        }
        else {
            [mustr appendString:[NSString stringWithFormat:@"@property (copy, nonatomic) NSString *%@;\n", temKey]];
        }
    }];
    
    NSLog(@"\n/**********ZJPrintKey***********/\n%@/**********ZJPrintKey***********/\n", mustr);
}
@end
