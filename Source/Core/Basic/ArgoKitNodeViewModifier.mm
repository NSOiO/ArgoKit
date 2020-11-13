//
//  ArgoKitNodeModifier.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/5.
//

#import "ArgoKitNodeViewModifier.h"
#import <objc/runtime.h>

static void performSelector(id object, SEL selector, NSArray<id> *values)
{
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
    //TODO: 获取返回值，暂不支持
//    id returnValue = nil;
//    if (methodSignate.methodReturnLength != 0) {
//        [invocation getReturnValue:&returnValue];
//  }
}

@implementation ArgoKitNodeViewModifier
+ (void)nodeViewAttributeWithNode:(nullable ArgoKitNode *)node attributes:(nullable NSArray<ViewAttribute *> *)attributes{
    if (!node) {
        return;
    }
    if (node.view) {
        [self _nodeViewAttributeWithNode:node attributes:attributes];
    }else{
        if (node.linkNode.revLinkNode == node) {
            [self _nodeViewAttributeWithNode:node.linkNode attributes:attributes];
        }
    }
}

+ (void)_nodeViewAttributeWithNode:(nullable ArgoKitNode *)node attributes:(nullable NSArray<ViewAttribute *> *)attributes{
    if (!node) {
        return;
    }
    if (node.view) {
        for (ViewAttribute *attribute in attributes) {
            if ([node.view respondsToSelector:attribute.selector]) {
                performSelector(node.view,attribute.selector,attribute.paramter);
                if (attribute.isDirty) {
                    [node markDirty];
                }
            }else if([node.view.layer respondsToSelector:attribute.selector]){
                performSelector(node.view.layer,attribute.selector,attribute.paramter);
            }
        }
    }
}

+ (void)reuseNodeViewAttribute:(nullable NSArray<ArgoKitNode*> *)nodes reuseNodes:(nullable NSArray<ArgoKitNode*> *)reuseNodes{
    NSInteger nodeCount = nodes.count;
    if (nodeCount != reuseNodes.count) {
        return;
    }
    for (int i = 0; i < nodeCount; i++) {
        ArgoKitNode *node = nodes[i];
        ArgoKitNode *resueNode = reuseNodes[i];
        resueNode.linkNode = node;
        node.revLinkNode = resueNode;
        node.backupViewAttributes = resueNode.viewAttributes;
        [self nodeViewAttributeWithNode:node attributes:resueNode.viewAttributes.allValues];
        node.view.frame = resueNode.frame;
        if (node.childs.count > 0 && node.childs.count == resueNode.childs.count) {
            [self reuseNodeViewAttribute:node.childs reuseNodes:resueNode.childs];
        }
    }
}
@end
