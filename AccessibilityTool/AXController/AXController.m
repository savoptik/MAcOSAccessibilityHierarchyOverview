//
//  AXController.m
//  AccessibilityTool
//
//  Created by Артём Семёнов on 23.01.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

#import "AXController.h"
#import <CoreFoundation/CoreFoundation.h>
#import <ApplicationServices/ApplicationServices.h>

@implementation AXController

+ (void)printHierarchyForWindowPID:(pid_t)pid {
    // получаем приложение
    AXUIElementRef appRef = AXUIElementCreateApplication(pid);
    // получаем окна этого приложения
    CFArrayRef windowList;
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef *)&windowList);
    // проверяем, если окон нет, выходим
    if ((!windowList) || CFArrayGetCount(windowList)<1) return;
    // выбираем окно на переднем плане
    AXUIElementRef windowRef = (AXUIElementRef)CFArrayGetValueAtIndex(windowList, 0);
    [self printHierarcghy:windowRef andLevel:0];
}

+ (void)printHierarcghy:(AXUIElementRef)elementRef andLevel:(int)level {
    CFTypeRef role;
    AXUIElementCopyAttributeValue(elementRef, kAXRoleAttribute, (CFTypeRef *)&role);
    NSString *strRole = CFBridgingRelease(role);
    CFTypeRef name;
    AXUIElementCopyAttributeValue(elementRef, kAXDescription, (CFTypeRef *)&name);
    NSString *strName = CFBridgingRelease(name);
    printf("уровень: %d, роль: %s, название: %s\n", level, [strRole UTF8String], [strName UTF8String]);
    CFArrayRef childrenList;
    AXUIElementCopyAttributeValue(elementRef, kAXChildrenAttribute, (CFTypeRef *)&childrenList);
    if (!childrenList) {
        return;
    }
    long m = CFArrayGetCount(childrenList);
    level += 1;
    for (int i = 0; i < m; i++) {
        [self printHierarcghy:(AXUIElementRef)CFArrayGetValueAtIndex(childrenList, i) andLevel:level];
    }
}

@end
