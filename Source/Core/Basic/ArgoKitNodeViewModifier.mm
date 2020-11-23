//
//  ArgoKitNodeModifier.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/5.
//

#import "ArgoKitNodeViewModifier.h"
#import <objc/runtime.h>
#import "ArgoReusedLayoutHelper.h"
static void performSelector(id object, SEL selector, NSArray<id> *values)
{
    if (object == nil) {
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
        }  else if ([argumentTypeString isEqualToString:@"B"]) { // bool
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
        } else if ([argumentTypeString isEqualToString:[NSString stringWithUTF8String:@encode(CGRect)]]) { // CGRect {CGRect={CGPoint=dd}{CGSize=dd}}
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
+ (void)nodeViewAttributeWithNode:(nullable ArgoKitNode *)node attributes:(nullable NSArray<ViewAttribute *> *)attributes{
    if (!node) {
        return;
    }
    [self _nodeViewAttributeWithNode:node attributes:attributes markDirty:YES];
}

+ (void)nodeViewAttributeWithNode:(nullable ArgoKitNode *)node attributes:(nullable NSArray<ViewAttribute *> *)attributes markDirty:(BOOL)markDirty{
    if (!node) {
        return;
    }
    [self _nodeViewAttributeWithNode:node attributes:attributes markDirty:markDirty];
}

+ (void)_nodeViewAttributeWithNode:(nullable ArgoKitNode *)node attributes:(nullable NSArray<ViewAttribute *> *)attributes markDirty:(BOOL)markDirty{
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

+ (void)reuseNodeViewAttribute:(nullable NSArray<ArgoKitNode*> *)nodes reuseNodes:(nullable NSArray<ArgoKitNode*> *)reuseNodes resetFrame:(BOOL)only{
    NSInteger nodeCount = nodes.count;
    if (nodeCount != reuseNodes.count) {
        return;
    }
    for (int i = 0; i < nodeCount; i++) {
        ArgoKitNode *node = nodes[i];
        ArgoKitNode *resueNode = reuseNodes[i];
        
        resueNode.linkNode = node;
        if (!node.view) {
            [node createNodeViewIfNeed:node.frame];
        }
        
        node.backupViewAttributes = resueNode.viewAttributes;
        if (!only) {
            [self _nodeViewAttributeWithNode:node attributes:resueNode.viewAttributes.allValues markDirty:NO];
        }
        node.view.frame = resueNode.frame;
        if (node.childs.count > 0 && node.childs.count == resueNode.childs.count) {
            [self reuseNodeViewAttribute:node.childs reuseNodes:resueNode.childs resetFrame:only];
        }
    }
}

+ (void)reuseNodeViewAttribute:(ArgoKitNode *)node reuseNode:(ArgoKitNode*)reuseNode{
    reuseNode.linkNode = node;
    [self reuseNodeViewAttribute:node.childs reuseNodes:reuseNode.childs resetFrame:NO];
}

+ (void)resetNodeViewFrame:(ArgoKitNode *)node reuseNode:(ArgoKitNode*)reuseNode{
    reuseNode.linkNode = node;
    [self reuseNodeViewAttribute:node.childs reuseNodes:reuseNode.childs resetFrame:YES];
}
@end
