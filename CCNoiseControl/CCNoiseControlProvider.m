#import "CCNoiseControl.h"
#import "CCNoiseControlProvider.h"

@implementation CCNoiseControlProvider

- (instancetype)init {
    self = [super init];

    return self;
}

- (NSUInteger)numberOfProvidedModules {
    return 1;
}

- (NSString*)identifierForModuleAtIndex:(NSUInteger)index {
    return @"com.brend0n.ccnoisecontrol";
}

- (id)moduleInstanceForModuleIdentifier:(NSString*)identifier {
    return [[CCNoiseControl alloc] init];
}

- (NSString*)displayNameForModuleIdentifier:(NSString*)identifier {
    return @"CCNoiseControl";
}

- (UIImage*)settingsIconForModuleIdentifier:(NSString*)identifier {
    CCUICAPackageDescription *description = [objc_getClass("CCUICAPackageDescription") descriptionForPackageNamed:@"CCNoiseControlIcon" inBundle:[NSBundle bundleForClass:[self class]]];
    CAPackage* package = [CAPackage packageWithContentsOfURL:[description packageURL] type:@"com.apple.coreanimation-bundle" options:0 error:nil];
    return [self imageFromLayer:[package rootLayer] flip:1];
}

//https://stackoverflow.com/questions/3454356/uiimage-from-calayer-in-ios
//https://stackoverflow.com/questions/1135631/vertical-flip-of-cgcontext
- (UIImage *)imageFromLayer:(CALayer *)layer flip:(BOOL)flip {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    if(flip) {
        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, layer.frame.size.height);
        CGContextConcatCTM(context, flipVertical);
    }

    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
