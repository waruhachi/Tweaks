#import "CPALabel.h"

@implementation CPALabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.layoutMargins)];
}

@end