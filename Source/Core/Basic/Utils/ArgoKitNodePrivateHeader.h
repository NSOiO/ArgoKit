//
//  ArgoKitNodePrivateHeader.h
//  ArgoKit
//
//  Created by Bruce on 2021/3/6.
//

#ifndef ArgoKitNodePrivateHeader_h
#define ArgoKitNodePrivateHeader_h
@interface ArgoKitNode()
@property(nonatomic, assign)BOOL layoutReusedNode;
@property(nonatomic, assign)BOOL nodeDirty;
- (void)createNodeViewIfNeedWithoutAttributes:(CGRect)frame;
- (void)resetAction:(ArgoKitNode *)reusedNode;
@end

#endif /* ArgoKitNodePrivateHeader_h */
