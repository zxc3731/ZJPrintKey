//
//  NSObject+ZJPrintKey.h
//  
//
//  Created by MACMINI on 15/11/17.
//  Copyright (c) 2015年 LZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZJPrintKey)
- (void)zj_dictionaryToLogUrlStr:(NSString *)urlStr andKey:(NSString *)key andKeyReplaceDictionary:(NSDictionary *)dict;
@end
