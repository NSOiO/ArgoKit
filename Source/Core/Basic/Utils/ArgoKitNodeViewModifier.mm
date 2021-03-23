//
//  ArgoKitNodeModifier.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/5.
//

#import "ArgoKitNodeViewModifier.h"
#import <objc/runtime.h>
#import "ArgoKitReusedLayoutHelper.h"
#import "ArgoKitNodePrivateHeader.h"
static void performSelector(id object, SEL selector, NSArray<id> *values)
{
    if (object == nil) {
        return;
    }
    // 一个nsvalue类型参数
    if (values.count == 1 && ![values.firstObject isKindOfClass:[NSValue class]]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
          [object performSelector:selector withObject:values.firstObject];
        #pragma clang diagnostic pop
        return;
    }
    // 两个非nsvalue类型参数
    if (values.count == 2 && ![values.firstObject isKindOfClass:[NSValue class]] && ![values.lastObject isKindOfClass:[NSValue class]]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
          [object performSelector:selector withObject:values.firstObject withObject:values.lastObject];
        #pragma clang diagnostic pop
        return;
    }
    
    NSMethodSignature *methodSignate = [[object class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignate];
    invocation.target = object;
    invocation.selector = selector;
    NSInteger paramsCount = methodSignate.numberOfArguments - 2;
    NSInteger count = MIN(paramsCount, values.count);
    for (int i = 0; i < count; i++) {
        id obj = values[i];
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        const char *argumentType = [methodSignate getArgumentTypeAtIndex:i + 2];
        NSString *argumentTypeString = [NSString stringWithUTF8String:argumentType];
        if ([argumentTypeString isEqualToString:@"@"]) { // id
            [invocation setArgument:&obj atIndex:i + 2];
        } else if([argumentTypeString isEqualToString:@"^{CGColor=}"]){
            [invocation setArgument:&obj atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"B"]) { // bool
            bool objVaule = [obj boolValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"f"]) { // float
            float objVaule = [obj floatValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"d"]) { // double
            double objVaule = [obj doubleValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"c"]) { // char
            char objVaule = [obj charValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"i"]) { // int
            int objVaule = [obj intValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"I"]) { // unsigned int
            unsigned int objVaule = [obj unsignedIntValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"S"]) { // unsigned short
            unsigned short objVaule = [obj unsignedShortValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"L"]) { // unsigned long
            unsigned long objVaule = [obj unsignedLongValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"s"]) { // shrot
            short objVaule = [obj shortValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"l"]) { // long
            long objVaule = [obj longValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"q"]) { // long long
            long long objVaule = [obj longLongValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"C"]) { // unsigned char
            unsigned char objVaule = [obj unsignedCharValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"Q"]) { // unsigned long long
            unsigned long long objVaule = [obj unsignedLongLongValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        }else if ([argumentTypeString isEqualToString:@":"]) { // unsigned long long
            [invocation setArgument:&obj atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:[NSString stringWithUTF8String:@encode(CGRect)]]) { // CGRect {CGRect={CGPoint=dd}}
            CGRect objVaule = [obj CGRectValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:[NSString stringWithUTF8String:@encode(UIEdgeInsets)]]) { // UIEdgeInsets {UIEdgeInsets=dddd}
            UIEdgeInsets objVaule = [obj UIEdgeInsetsValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        }
  }
    [invocation invoke];
}

@implementation ArgoKitNodeViewModifier
+ (void)nodeViewAttributeWithNode:(nullable ArgoKitNode *)node attributes:(nullable NSArray<ViewAttribute *> *)attributes markDirty:(BOOL)markDirty{
    if (!node) {
        return;
    }
    UIView *view = node.view;
    for (ViewAttribute *attribute in attributes) {
        if(attribute.isCALayer){
            if(view &&  [view.layer respondsToSelector:attribute.selector]){
                performSelector(view.layer,attribute.selector,attribute.paramter);
            }
        }else{
            if (view && [view respondsToSelector:attribute.selector]) {
                performSelector(view,attribute.selector,attribute.paramter);
            }
        }
        
        if (attribute.isDirty && markDirty) {
            [node markDirty];
        }
    }
}

+ (void)performViewAttribute:(nullable UIView *)view attributes:(nullable NSArray<ViewAttribute *> *)attributes{
    if (!view) {
        return;
    }
    for (ViewAttribute *attribute in attributes) {
        NSString *selector_name;
        if (attribute.selector) {
            selector_name = @(sel_getName(attribute.selector));
        }
        if (![selector_name hasPrefix:@"set"]) {//不是set方法则排除在外
            continue;
        }
        if(attribute.isCALayer){
            if(view &&  [view.layer respondsToSelector:attribute.selector]){
                performSelector(view.layer,attribute.selector,attribute.paramter);
            }
        }else{
            if (view && [view respondsToSelector:attribute.selector]) {
                performSelector(view,attribute.selector,attribute.paramter);
            }
        }
    }
}

+ (void)reuseNodeViewAttribute:(nullable NSArray<ArgoKitNode*> *)nodes reuseNodes:(nullable NSArray<ArgoKitNode*> *)reuseNodes onlyResetFrame:(BOOL)onlyResetFrame{
    BOOL resetFrame = onlyResetFrame;
    NSInteger nodeCount = nodes.count;
    if (nodeCount != reuseNodes.count) {
        return;
    }
    for (int i = 0; i < nodeCount; i++) {
        ArgoKitNode *node = nodes[i];
        ArgoKitNode *reuseNode = reuseNodes[i];
        
        reuseNode.linkNode = node;
        if (!node.view &&
            reuseNode.isEnabled &&
            // FIX: 修复父空间gone和子视图的gone不一致导致的复用问题
            !CGRectEqualToRect(reuseNode.frame, CGRectZero)) {
            if ([node respondsToSelector:@selector(createNodeViewIfNeedWithoutAttributes:)]) {
                [node createNodeViewIfNeedWithoutAttributes:reuseNode.frame];
            }
            resetFrame = false;
        }
        
        // 设置frame在前
        if (!CGRectEqualToRect(node.view.frame, reuseNode.frame)) {
            node.view.frame = reuseNode.frame;
            
        }
        // 更新UI属性在后
        if (!resetFrame) {
            [self commitAttributeValueToView:node reuseNode:reuseNode];
        }
        
        if (node.childs.count > 0) {
            [self reuseNodeViewAttribute:node.childs reuseNodes:reuseNode.childs onlyResetFrame:onlyResetFrame];
        }
    }
}

+ (void)reuseNodeViewAttribute:(ArgoKitNode *)node reuseNode:(ArgoKitNode*)reuseNode{
    reuseNode.linkNode = node;
    [self reuseNodeViewAttribute:node.childs reuseNodes:reuseNode.childs onlyResetFrame:NO];
}

+ (void)_resetNodeViewFrame:(ArgoKitNode *)node reuseNode:(ArgoKitNode*)reuseNode{
    reuseNode.linkNode = node;
    [self reuseNodeViewAttribute:node.childs reuseNodes:reuseNode.childs onlyResetFrame:YES];
}

+ (void)resetNodeViewFrame:(nullable ArgoKitNode *)node{
    if (node.linkNode) {
        [ArgoKitNodeViewModifier _resetNodeViewFrame:node.linkNode reuseNode:node];
    }else{
        [ArgoKitNodeViewModifier _resetNodeViewFrame:node reuseNode:node];
    }
}

+ (void)commitAttributeValueToView:(ArgoKitNode *)node reuseNode:(ArgoKitNode*)reuseNode{
    // 处理UIView属性点击事件
    [self nodeViewAttributeWithNode:node attributes:[reuseNode nodeAllAttributeValue] markDirty:NO];
    // 处理UIControl点击事件
    if (node.nodeActions.count && [node.view isKindOfClass:[UIControl class]] && [node.view respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
        NSArray<NodeAction *> *copyActions = [reuseNode.nodeActions mutableCopy];
        for(NodeAction *action in copyActions){
            [node addTarget:node.view forControlEvents:action.controlEvents action:action.actionBlock];
        }
    }
    if(!CGRectEqualToRect(reuseNode.frame, CGRectZero)){
        [node reuseNodeToView:reuseNode view:node.view];
    }
}


+ (void)prepareForReuseNode:(nullable ArgoKitNode*)node{
    if (!node || !node.view) {
        return;
    }
    for (UIGestureRecognizer *recognizer in node.view.gestureRecognizers) {
        [node.view removeGestureRecognizer:recognizer];
    }
    [node prepareForUse:node.view];
    for(ArgoKitNode *subNode in node.childs){
        [self prepareForReuseNode:subNode];
    }
}
@end
