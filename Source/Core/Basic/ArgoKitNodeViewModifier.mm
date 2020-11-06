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
+ (void)nodeViewAttributeWithNode:(ArgoKitNode *)node attributes:(NSArray<ViewAttribute *> *)attributes{
    for (ViewAttribute *attribute in attributes) {
        if (node.view) {
            if ([node.view respondsToSelector:attribute.selector]) {
                performSelector(node.view,attribute.selector,attribute.paramter);
                [node markDirty];
            }
          
        }
       
    }
}

+ (void)reuseNodeViewAttribute:(NSArray<ArgoKitNode*> *)nodes reuseNodes:(NSArray<ArgoKitNode*> *)reuseNodes{
    
    NSInteger nodeCount = nodes.count;
    if (nodeCount != reuseNodes.count) {
        return;
    }
    for (int i = 0; i < nodeCount; i++) {
        ArgoKitNode *node = nodes[i];
        ArgoKitNode *resueNode = reuseNodes[i];
        node.text = resueNode.text;
        [self nodeViewAttributeWithNode:node attributes:resueNode.viewAttributes];
        
        if (node.childs.count > 0 && node.childs.count == resueNode.childs.count) {
            [self reuseNodeViewAttribute:node.childs reuseNodes:resueNode.childs];
        }
    }
}
@end
