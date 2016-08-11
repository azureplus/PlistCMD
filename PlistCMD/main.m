//
//  main.m
//  PlistCMD
//
//  Created by dev on 16/8/11.
//  Copyright © 2016年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
int main(int argc, const char * argv[]) {
    
    NSString *path = @"/Users/dev/Desktop/client/";
    NSString *savePath = @"/Users/dev/Desktop/client2/";
    NSString *ext = @"strings";
    NSString *name = nil;
    NSArray *keys = nil;
    if (keys) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *key in keys) {
            [array addObject:[key uppercaseString]];
        }
        keys = array;
    }
    
    
    NSError *error;
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:&error];    
    
    for (NSString *subpath in [subPaths filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.lastPathComponent contains[cd] %@", ext]]) {
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:subpath]];
        NSMutableString *strings = [NSMutableString string];
        
        NSArray *allKeys = [plist allKeys];
        if (keys) {
            allKeys = [allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.uppercaseString IN %@", keys]];
        }
        
        for (NSString *key in [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
            if (!keys || [keys containsObject:key]) {
                // only copy if its matched
                NSString *s1 = [[key stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                                stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                
                NSString *s2 = [[[plist objectForKey:key] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                                stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                NSString *out1 = [NSString stringWithFormat:@"\"%@\" = \"%@\";\n", s1, s2];
                NSLog(@"%@",out1);
                [strings appendString:out1];
            }
        }
        
        if ([strings length] > 0) {
            NSString *newPath = nil;
            
            if (name) {
                newPath = [savePath stringByAppendingPathComponent:
                           [[subpath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.strings", name]]];
            }
            else {
                newPath = [savePath stringByAppendingPathComponent:
                           [[subpath stringByDeletingPathExtension] stringByAppendingPathExtension:@"strings"]];
            }
            
            NSError *error;
            if (![[NSFileManager defaultManager] createDirectoryAtPath:[newPath stringByDeletingLastPathComponent]
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:&error]) {
                
            }
            if (![strings writeToFile:newPath atomically:YES encoding:NSUTF16StringEncoding error:&error]) {
            }
        }
    }
    
    
    return 0;
}
