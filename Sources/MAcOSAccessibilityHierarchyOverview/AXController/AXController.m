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

+ (void)printHierarchyForWindowPID:(pid_t)pid depth:(int)depth {
    // получаем приложение
    AXUIElementRef appRef = AXUIElementCreateApplication(pid);
    if (!appRef) {
        printf("по заданному PID %d  приложений не найдено\n", pid);
        return;
    }
    // получаем окна этого приложения
    CFArrayRef windowList;
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef *)&windowList);
    // проверяем, если окон нет, выходим
    if ((!windowList) || CFArrayGetCount(windowList)<1) {
        printf("У заданного приложения нет окон\n");
        return;
    }
    // выбираем окно на переднем плане
    AXUIElementRef windowRef = (AXUIElementRef)CFArrayGetValueAtIndex(windowList, 0);
    [self printHierarchy:windowRef andLevel:0 depth:depth];
}

+ (void)printHierarchy:(AXUIElementRef)elementRef andLevel:(int)level depth:(int)depth {
    CFTypeRef role;
    AXUIElementCopyAttributeValue(elementRef, kAXRoleAttribute, (CFTypeRef *)&role);
    NSString *strRole = CFBridgingRelease(role);
    CFTypeRef name;
    AXUIElementCopyAttributeValue(elementRef, kAXDescription, (CFTypeRef *)&name);
    NSString *strName = CFBridgingRelease(name);
    NSString *strinForPrint = [NSString stringWithFormat:@"%@. role: %@, name: %@\n", [NSNumber numberWithInt:level], strRole, strName];
    for (int i = 0; i < level; i++) {
        strinForPrint = [NSString stringWithFormat:@"  %@", strinForPrint];
    }
    printf([strinForPrint UTF8String]);
    CFArrayRef childrenList;
    AXUIElementCopyAttributeValue(elementRef, kAXChildrenAttribute, (CFTypeRef *)&childrenList);
    if (!childrenList) {
        return;
    }
    long m = CFArrayGetCount(childrenList);
    level += 1;
    for (int i = 0; i < m; i++) {
        if ((depth == 0) || (level < depth)) {
            [self printHierarchy:(AXUIElementRef)CFArrayGetValueAtIndex(childrenList, i) andLevel:level depth:depth];
        }
    }
}

+ (NSString *)getHierarchy:(AXUIElementRef)elementRef andLevel:(int)level depth:(int)depth {
    CFTypeRef role;
    AXUIElementCopyAttributeValue(elementRef, kAXRoleAttribute, (CFTypeRef *)&role);
    NSString *strRole = CFBridgingRelease(role);
    CFTypeRef name;
    AXUIElementCopyAttributeValue(elementRef, kAXDescription, (CFTypeRef *)&name);
    NSString *strName = CFBridgingRelease(name);
    NSString *hierarchyStap = [NSMutableString stringWithFormat:@"%d %@, название: %@", level, strRole, strName];
    CFArrayRef childrenList;
    AXUIElementCopyAttributeValue(elementRef, kAXChildrenAttribute, (CFTypeRef *)&childrenList);
    if (!childrenList) {
        return hierarchyStap;
    }
    long m = CFArrayGetCount(childrenList);
    level += 1;
    for (int i = 0; i < m; i++) {
        if ((depth == 0) || (level < depth)) {
            hierarchyStap = [NSString stringWithFormat:@"%@\n%@", hierarchyStap, [self getHierarchy:(AXUIElementRef)CFArrayGetValueAtIndex(childrenList, i) andLevel:level depth:depth]];
        }
    }
    return hierarchyStap;
}

+ (NSString *)getHierarchyForWindowPID:(pid_t)pid depth:(int)depth { 
    // получаем приложение
    AXUIElementRef appRef = AXUIElementCreateApplication(pid);
    if (!appRef) {
        return [NSString stringWithFormat:@"по заданному PID %d  приложений не найдено\n", pid];
    }
    // получаем окна этого приложения
    CFArrayRef windowList;
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef *)&windowList);
    // проверяем, если окон нет, выходим
    if ((!windowList) || CFArrayGetCount(windowList)<1) {
        return @"У заданного приложения нет окон\n";
    }
    // выбираем окно на переднем плане
    AXUIElementRef windowRef = (AXUIElementRef)CFArrayGetValueAtIndex(windowList, 0);
    return [self getHierarchy:windowRef andLevel:0 depth:depth];
}

@end
