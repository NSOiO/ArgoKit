//
//  ArgoKitUtils.m
//  ArgoKit
//
//  Created by Bruce on 2020/10/31.
//

#import "ArgoKitUtils.h"
#import <CoreText/CoreText.h>
#include <pthread/pthread.h>
@implementation ArgoKitUtils
static dispatch_queue_t argokit_caculate_queue  = nil;
+ (void)asynCaculationBlock:(dispatch_block_t)block{
    if (!argokit_caculate_queue) {
        argokit_caculate_queue = dispatch_queue_create("com.argokit.precaculate.nodecaculationQueue", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(argokit_caculate_queue, block);
}
+ (void)runMainThreadAsyncBlock:(dispatch_block_t)block{
    if (pthread_main_np()) {
        block();
    }else{
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)runMainThreadSyncBlock:(dispatch_block_t)block{
    if (pthread_main_np()) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}


+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [self colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];

    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;

    //R、G、B
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (CGSize)sizeThatFits:(CGSize)size
                  font:(UIFont *)font
         lineBreakMode:(NSLineBreakMode)breakMode
           lineSpacing:(CGFloat)lineSpacing
      paragraphSpacing:(CGFloat)paragraphSpacing
         textAlignment:(NSTextAlignment)textAlign
         numberOfLines:(NSInteger)numberOfLines
      attributedString:(nullable NSAttributedString *)attributedString{
    NSAttributedString *drawString = [self attributedStringForDraw:size font:font lineBreakMode:breakMode lineSpacing:lineSpacing paragraphSpacing:paragraphSpacing textAlignment:textAlign numberOfLines:numberOfLines attributedString:attributedString];
    if (!attributedString) {
        return CGSizeZero;
    }
    CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)drawString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedStringRef);
    if (!framesetter) {
        // 字符串处理失败
        return size;
    }
    
    CFRange range = CFRangeMake(0, 0);
    if (numberOfLines > 0 && framesetter) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (nil != lines && CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN(numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            range = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        CFRelease(frame);
        CFRelease(path);
    }
    CFRange fitCFRange = CFRangeMake(0, 0);
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, CGSizeMake(size.width, MAXFLOAT), &fitCFRange);
    if (framesetter) {
        CFRelease(framesetter);
    }
    if (newSize.height < font.lineHeight * 2) {
        return CGSizeMake(ceilf(newSize.width), ceilf(newSize.height));
    } else {
        return CGSizeMake(size.width, ceilf(newSize.height));
    }
}

+ (NSAttributedString *)attributedStringForDraw:(CGSize)size
                                                       font:(UIFont *)font
                                  lineBreakMode:(CGFloat)breakMode
                                    lineSpacing:(CGFloat)lineSpacing
                               paragraphSpacing:(CGFloat)paragraphSpacing
                                  textAlignment:(NSTextAlignment)textAlign
                                    numberOfLines:(NSInteger)numberOfLines
                                    attributedString:(nullable NSAttributedString *)attributedString
{
    NSAttributedString *strongString = attributedString;
    if (strongString.length) {
        // 添加排版格式
        NSMutableAttributedString *drawString = [strongString mutableCopy];
        
//        // 添加默认字体、颜色
//        [drawString enumerateAttributesInRange:NSMakeRange(0, drawString.length) options:0 usingBlock:^(NSDictionary<NSString *, id> *attrs, NSRange range, BOOL *stop) {
//            if (!attrs[(__bridge NSString *)kCTFontAttributeName] && !attrs[NSFontAttributeName]) {
//                if (font) {
//                    [drawString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:range];
//                    
//                    CTFontRef fontRef = (__bridge CTFontRef)font;
//                    if (nil != fontRef) {
//                        [drawString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
//                    }
//                }
//            }
//        }];
        
        // 如果LineBreakMode为TranncateTail,那么默认排版模式改成kCTLineBreakByCharWrapping,使得尽可能地显示所有文字
        CTLineBreakMode lineBreakMode = [self setupLineBreakMode:breakMode];
        if (lineBreakMode == kCTLineBreakByTruncatingTail) {
            lineBreakMode = kCTLineBreakByCharWrapping;
        }
        CTTextAlignment textAlignment = [self setupTextAlignment:textAlign];
        CGFloat lineSpacing = lineSpacing;
        CGFloat paragraphSpacing = paragraphSpacing;
        CGFloat fontLineMinHeight = font.lineHeight; //使用全局fontHeight作为最小lineHeight
        CTParagraphStyleSetting settings[] =
        {
            {kCTParagraphStyleSpecifierAlignment, sizeof(textAlignment), &textAlignment},
            {kCTParagraphStyleSpecifierLineBreakMode, sizeof(lineBreakMode), &lineBreakMode},
            {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(lineSpacing), &lineSpacing},
            {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(lineSpacing), &lineSpacing},
            {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(paragraphSpacing), &paragraphSpacing},
            {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(fontLineMinHeight), &fontLineMinHeight},
        };
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
        [drawString addAttribute:(__bridge NSString *)kCTParagraphStyleAttributeName value:(__bridge_transfer NSParagraphStyle *)paragraphStyle range:NSMakeRange(0, [drawString length])];
        return drawString;
    } else {
        return nil;
    }
}

+ (CTTextAlignment)setupTextAlignment:(NSTextAlignment)textAlign
{
    CTTextAlignment textAlignment = kCTTextAlignmentLeft;
    switch (textAlign) {
        case NSTextAlignmentLeft:
            textAlignment = kCTTextAlignmentLeft;
            break;
        case NSTextAlignmentRight:
            textAlignment = kCTTextAlignmentRight;
            break;
        case NSTextAlignmentCenter:
            textAlignment = kCTTextAlignmentCenter;
            break;
            
        default:
            break;
    }
    return textAlignment;
}
+ (CTLineBreakMode)setupLineBreakMode:(NSLineBreakMode)breakMode
{
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    switch (breakMode) {
        case NSLineBreakByCharWrapping:
            lineBreakMode = kCTLineBreakByCharWrapping;
            break;
        case NSLineBreakByClipping:
            lineBreakMode = kCTLineBreakByClipping;
            break;
        case NSLineBreakByTruncatingHead:
            lineBreakMode = kCTLineBreakByTruncatingHead;
            break;
        case NSLineBreakByTruncatingMiddle:
            lineBreakMode = kCTLineBreakByTruncatingMiddle;
            break;
        case NSLineBreakByTruncatingTail:
            lineBreakMode = kCTLineBreakByTruncatingTail;
            break;
        case NSLineBreakByWordWrapping:
            lineBreakMode = kCTLineBreakByWordWrapping;
            break;
        default:
            break;
    }
    return lineBreakMode;
}
@end
