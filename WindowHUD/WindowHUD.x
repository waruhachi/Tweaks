#import "WindowHUD.h"

@implementation WindowHUD

- (UIImage *)iconGlyph {
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
	label.textColor = [UIColor blackColor];
	label.backgroundColor= [UIColor clearColor];
	label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumScaleFactor = 10.0f/12.0f;
	label.clipsToBounds = YES;
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [label.font fontWithSize:25];
	label.numberOfLines = 1;
	label.text = @"HUD";

	UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0.0);
	CGContextRef context = UIGraphicsGetCurrentContext();

	if (_selected) {
		// Flip the label so that it actuall does appear the right way when the screen is flipped
		CGAffineTransform flipVertical = CGAffineTransformMake(-1, 0, 0, 1, label.bounds.size.width, 0);
		CGContextConcatCTM(context, flipVertical);
	}

	[[label layer] renderInContext: context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

- (UIColor *)selectedColor {
	return [UIColor colorWithRed:0.01 green:0.68 blue:0.86 alpha:1.0];
}

- (BOOL)isSelected {
	return _selected;
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;
	[super reconfigureView];

	Class cls = NSClassFromString(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0") ? @"UIRootSceneWindow" : @"FBRootWindow");
	[cls sharedInstance].transform = _selected ? CGAffineTransformMake(-1, 0, 0, 1, 0, 0) : CGAffineTransformMake(1, 0, 0, 1, 0, 0);
}

@end
