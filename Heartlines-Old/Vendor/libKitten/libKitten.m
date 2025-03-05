//
//  libKitten.m
//  libKitten
//
//  Created by Alexandra (@schneelittchen)
//

#import "libKitten.h"

@implementation libKitten

+ (UIColor *)backgroundColor:(UIImage *)image {

    return [self getColorFromImage:image calculation:0 dimension:0 flexibility:0 range:0];

}

+ (UIColor *)primaryColor:(UIImage *)image {

    return [self getColorFromImage:image calculation:1 dimension:10 flexibility:2 range:50];
    
}

+ (UIColor *)secondaryColor:(UIImage *)image {

    return [self getColorFromImage:image calculation:1 dimension:15 flexibility:3 range:60];

}

+ (BOOL)isDarkImage:(UIImage *)image {

    if (!image) return YES;

    BOOL isDark = NO;
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);
    int darkPixels = 0;
    size_t length = CFDataGetLength(imageData);
    int totalPixels = (int)(image.size.width * image.size.height);
    int darkThreshold = (int)(totalPixels * 0.45);

    for (int i = 0; i < length; i += 4) {
        int r = pixels[i];
        int g = pixels[i+1];
        int b = pixels[i+2];
        float luminance = (0.299 * r + 0.587 * g + 0.114 * b);
        if (luminance < 150) darkPixels++;
    }

    if (darkPixels >= darkThreshold) isDark = YES;
    CFRelease(imageData);

    return isDark;

}

+ (BOOL)isDarkColor:(UIColor *)color {

    if (!color) return YES;

    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    double brightness = (r * 299 + g * 587 + b * 114) / 1000;
    return brightness < 0.5;

}

+ (UIColor *)getColorFromImage:(UIImage *)image calculation:(int)calculation dimension:(int)dimension flexibility:(int)flexibility range:(int)range {

    if (!image) return [UIColor whiteColor];

    if (calculation == 0) { // Average color calculation
        CGSize size = CGSizeMake(1, 1);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, 1, 1) blendMode:kCGBlendModeCopy alpha:1];
        UIImage *avgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(avgImage.CGImage));
        const UInt8 *pixels = CFDataGetBytePtr(imageData);
        UIColor *color = [UIColor colorWithRed:pixels[0]/255.0f
                                         green:pixels[1]/255.0f
                                          blue:pixels[2]/255.0f
                                         alpha:pixels[3]/255.0f];
        CFRelease(imageData);
        return color;
    }
    else if (calculation == 1) { // Dominant color calculation
        CGImageRef imageRef = [image CGImage];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        unsigned char *rawData = (unsigned char *)calloc(dimension * dimension * 4, sizeof(unsigned char));
        
        CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension,
                                                     8, dimension * 4, colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);
        CGContextRelease(context);

        NSMutableDictionary *colorCounter = [NSMutableDictionary dictionary];

        for (int i = 0; i < dimension * dimension; i++) {
            int byteIndex = i * 4;
            int alpha = rawData[byteIndex + 3];
            if (alpha < 128) continue;

            int r = rawData[byteIndex];
            int g = rawData[byteIndex + 1];
            int b = rawData[byteIndex + 2];

            // Color quantization with flexibility
            int cubeSize = flexibility * 2 + 1;
            if (cubeSize < 1) cubeSize = 1;

            int clampedR = MIN(MAX(r, 0), 255);
            int clampedG = MIN(MAX(g, 0), 255);
            int clampedB = MIN(MAX(b, 0), 255);

            int quantR = (clampedR / cubeSize) * cubeSize + flexibility;
            int quantG = (clampedG / cubeSize) * cubeSize + flexibility;
            int quantB = (clampedB / cubeSize) * cubeSize + flexibility;

            quantR = MIN(MAX(quantR, 0), 255);
            quantG = MIN(MAX(quantG, 0), 255);
            quantB = MIN(MAX(quantB, 0), 255);

            UInt32 colorKey = (quantR << 16) | (quantG << 8) | quantB;
            NSNumber *key = @(colorKey);
            colorCounter[key] = @([colorCounter[key] intValue] + 1);
        }

        free(rawData);

        NSArray *sortedColors = [colorCounter keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj2 compare:obj1];
        }];

        NSMutableArray *resultColors = [NSMutableArray array];
        NSMutableArray *excludedColors = [NSMutableArray array];

        for (NSNumber *colorKey in sortedColors) {
            UInt32 rgb = [colorKey unsignedIntValue];
            int r = (rgb >> 16) & 0xFF;
            int g = (rgb >> 8) & 0xFF;
            int b = rgb & 0xFF;

            BOOL shouldExclude = NO;
            for (NSNumber *excludedKey in excludedColors) {
                UInt32 exRgb = [excludedKey unsignedIntValue];
                int exR = (exRgb >> 16) & 0xFF;
                int exG = (exRgb >> 8) & 0xFF;
                int exB = exRgb & 0xFF;
  
                double distance = sqrt(pow(r - exR, 2) + pow(g - exG, 2) + pow(b - exB, 2));
                if (distance < range) {
                    shouldExclude = YES;
                    break;
                }
            }

            if (!shouldExclude) {
                [excludedColors addObject:colorKey];
                UIColor *color = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
                [resultColors addObject:color];
            }
        }

        return [resultColors firstObject] ?: [UIColor whiteColor];
    }

    return [UIColor whiteColor];
}

@end