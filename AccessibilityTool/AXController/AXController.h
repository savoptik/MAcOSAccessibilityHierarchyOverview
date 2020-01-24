//
//  AXController.h
//  AccessibilityTool
//
//  Created by Артём Семёнов on 23.01.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXController : NSObject

+ (void)printHierarchyForWindowPID:(pid_t)pid depth:(int)depth;
+ (void)printHierarcghy:(AXUIElementRef)elementRef andLevel:(int)level depth:(int)depth;

@end
