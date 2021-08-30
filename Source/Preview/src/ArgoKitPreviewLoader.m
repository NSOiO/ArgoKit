//
//  ArgoKitPreviewLoader.m
//  ArgoKitPreview
//
//  Created by Dongpeng Dai on 2020/12/29.
//

#import <Foundation/Foundation.h>
@import ObjectiveC;

//void _argokit_preview_config_(void);
//
//@interface ArgoKitPreviewLoader : NSObject
//@end
//
//@implementation ArgoKitPreviewLoader : NSObject
//+ (void)load {  _argokit_preview_config_(); }
//@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
static void swizzleInstanceMethodWithBlock(Class class, SEL originalSelector, SEL newSelector, id block) {
    IMP newImp = imp_implementationWithBlock(block);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (originalMethod) {
        const char *typeEncoding = method_getTypeEncoding(originalMethod);
        if (class_addMethod(class, newSelector, method_getImplementation(originalMethod), typeEncoding)) {
            if (!class_addMethod(class, originalSelector, newImp, typeEncoding)) {
                // 原方法是本类方法，需要将实现换为新实现。
                class_replaceMethod(class, originalSelector, newImp, typeEncoding);
            }
            // else 原方法是父类方法，已将新实现添加到本类。
            return;
        }
    }
}

static NSString * argokit_viewAliasNameFromView(UIView *view) {
    NSString *name;
    SEL sel = NSSelectorFromString(@"argokit_viewAliasName");
    if ([view respondsToSelector:sel]) {
        name = [view performSelector:sel];
    }
    return name;
}

void ArgoKitPreview_FitFlex() {
    Class cls = NSClassFromString(@"FLEXUtility");
    if (cls) {
        SEL sel = NSSelectorFromString(@"descriptionForView:includingFrame:");
        SEL newSel = NSSelectorFromString(@"argokit_descriptionForView:includingFrame:");
        Class meta = object_getClass(cls);
        swizzleInstanceMethodWithBlock(meta, sel, newSel, ^NSString *(NSObject* obj, UIView *view, BOOL include){
            NSString *des = @"-";
            if ([obj respondsToSelector:newSel]) {

                des = [obj performSelector:newSel withObject:view withObject:@(include)];
            }
            NSString *name = argokit_viewAliasNameFromView(view);
            NSString *replaced = [view.class description];
            if (name.length > 0 && replaced.length > 0) {
                NSRange range = [des rangeOfString:replaced];
                if (range.location != NSNotFound) {
                    des = [des stringByReplacingCharactersInRange:range withString:name];
                }
            }
            return des;
        });
    }
}

@interface ArgoKitPreview_Loader_Tester : NSObject
@end

@implementation ArgoKitPreview_Loader_Tester
+ (void)load {
//    ArgoKitPreview_FitFlex();
}
@end

#pragma clang diagnostic pop
