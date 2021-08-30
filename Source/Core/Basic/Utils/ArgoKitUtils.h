//
//  ArgoKitUtils.h
//  ArgoKit
//
//  Created by Bruce on 2020/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArgoKitUtils : NSObject
+ (void)runMainThreadAsyncBlock:(dispatch_block_t)block;
+ (void)runMainThreadSyncBlock:(dispatch_block_t)block;
+ (UIColor*)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (CGSize)sizeThatFits:(CGSize)size
          font:(UIFont *)font
         numberOfLines:(NSInteger)numberOfLines
      attributedString:(nullable NSAttributedString *)attributedString;

+ (CGSize)sizeThatFits:(CGSize)size
                  font:(UIFont *)font
         lineBreakMode:(NSLineBreakMode)breakMode
           lineSpacing:(CGFloat)lineSpacing
      paragraphSpacing:(CGFloat)paragraphSpacing
         textAlignment:(NSTextAlignment)textAlign
         numberOfLines:(NSInteger)numberOfLines
      attributedString:(nullable NSAttributedString *)attributedString;

+ (void)asynCaculationBlock:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
