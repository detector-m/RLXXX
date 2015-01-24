//
//  GVDebug.h
//  GlobalVillage
//
//  Created by RivenL on 14/11/25.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#ifndef _GlobalVillage_GVDebug_h
#define _GlobalVillage_GVDebug_h

#ifdef DEBUG
//# define DLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLog(format, ...) NSLog((@"[函数名:%s]" "[行号:%d]" format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...)
#endif

#endif
