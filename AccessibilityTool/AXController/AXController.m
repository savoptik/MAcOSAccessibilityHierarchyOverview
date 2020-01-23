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

+ (NSArray<NSString *> *)getWindowList {

    // получить все окна
        CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    NSArray* arr = CFBridgingRelease(windowList);
    // перебираем окна
    for (NSMutableDictionary* entry in arr) {
        // получаем PID приложения по окну
        pid_t pid = [[entry objectForKey:(id)kCGWindowOwnerPID] intValue];
        // получаем ссылку на приложение
                AXUIElementRef appRef = AXUIElementCreateApplication(pid);
                NSLog(@"Ref = %@",appRef);
        // получаем окна приложения
                CFArrayRef windowList;
        AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef *)&windowList);
        NSLog(@"WindowList = %@", windowList);
        if ((windowList) && (CFArrayGetCount(windowList) >= 1)) {
            // получение текущего первого окна
            AXUIElementRef windowRef = (AXUIElementRef) CFArrayGetValueAtIndex( windowList, 0);
            CFArrayRef childrenList;
            AXUIElementCopyAttributeValue(windowRef, kAXChildrenAttribute, (CFTypeRef *)&childrenList);
            CFStringRef name;
            AXUIElementCopyAttributeValue((AXUIElementRef)CFArrayGetValueAtIndex(childrenList, 0), kAXLabelValueAttribute, (CFTypeRef *)&name);
                                          NSLog(@"название первого a11y элемента %@", name);
        }
    }
    return NULL;
}

@end
