//
//  TYSandBexFileItem.m
//  PrismDemo
//
//  Created by tany on 2017/9/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYSandBoxFileItem.h"

@implementation TYSandBoxFileItem

- (TYSandBoxFileType)typeWithFileExtension:(NSString *)fileExtension {
    if ([[fileExtension lowercaseString] isEqualToString:@"jpg"] || [[fileExtension lowercaseString] isEqualToString:@"gif"] || [[fileExtension lowercaseString] isEqualToString:@"jpeg"]) {
        return TYSandBoxFileTypeImage;
    }
    if ([[fileExtension lowercaseString] isEqualToString:@"pdf"]) {
        return TYSandBoxFileTypePDF;
    }
    
    if ([[fileExtension lowercaseString] isEqualToString:@"plist"]) {
        return TYSandBoxFileTypePlist;
    }
    
    if ([[fileExtension lowercaseString] isEqualToString:@"log"]) {
        return TYSandBoxFileTypeLog;
    }
    
    if ([[fileExtension lowercaseString] isEqualToString:@"sqlite"]) {
        return TYSandBoxFileTypeSQL;
    }
    
    return TYSandBoxFileTypeFile;
}

@end
