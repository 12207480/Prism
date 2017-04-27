//
//  TYDLog.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/27.
//  Copyright © 2017年 tany. All rights reserved.
//

#ifndef TYDLog_h
#define TYDLog_h

#define TYDLOG_LEVEL_INFO       0
#define TYDLOG_LEVEL_DEBUG      1
#define TYDLOG_LEVEL_WARNING    2
#define TYDLOG_LEVEL_ERROR      3

#define TYDLOG_STRING_INFO      @"LOG"
#define TYDLOG_STRING_DEBUG     @"DEBUG"
#define TYDLOG_STRING_WARNING   @"WARNING"
#define TYDLOG_STRING_ERROR     @"ERROR"

#define TYDLogInfo(fmt, ...) NSLog((@">%@--> %s [Line %d] " fmt), TYDLOG_STRING_INFO, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define TYDLogWarning(fmt, ...) NSLog((@">%@--> %s [Line %d] " fmt), TYDLOG_STRING_WARNING, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define TYDLogError(fmt, ...) NSLog((@">%@--> %s [Line %d] " fmt), TYDLOG_STRING_ERROR, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
#   define TYDLogDebug(fmt, ...) NSLog((@">%@--> %s [Line %d] " fmt), TYDLOG_STRING_DEBUG, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define TYDLogDebug  (...)
#endif

#endif /* TYDLog_h */
