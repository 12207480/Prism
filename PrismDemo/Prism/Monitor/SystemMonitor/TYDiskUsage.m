//
//  TYDiskUsage.m
//  PrismDemo
//
//  Created by tany on 2017/8/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYDiskUsage.h"

@implementation TYDiskUsage

+ (unsigned long long) getDiskTotalSize {
    NSError *error;
    NSDictionary *directory = [[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
        return 0;
    }
    return [[directory objectForKey:NSFileSystemSize] unsignedLongLongValue];
}

+ (unsigned long long) getDiskFreeSize {
    NSError *error;
    NSDictionary *directory = [[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
        return 0;
    }
    return [[directory objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
}

+ (unsigned long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        return 0;
    }
    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}

+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    unsigned long long folerSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folerSize += [self fileSizeAtPath:filePath];
    }
    return folerSize;
}

@end
