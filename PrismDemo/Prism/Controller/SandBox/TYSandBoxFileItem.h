//
//  TYSandBexFileItem.h
//  PrismDemo
//
//  Created by tany on 2017/9/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TYSandBoxFileType) {
    TYSandBoxFileTypeDir,
    TYSandBoxFileTypeImage,
    TYSandBoxFileTypePlist,
    TYSandBoxFileTypePDF,
    TYSandBoxFileTypeFile,
    TYSandBoxFileTypeSQL,
    TYSandBoxFileTypeLog
};

@interface TYSandBoxFileItem : NSObject

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, assign) TYSandBoxFileType fileType;

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) NSDate *fileDate;

- (TYSandBoxFileType)typeWithFileExtension:(NSString *)fileExtension;

@end
