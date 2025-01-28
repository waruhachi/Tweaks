#import <SpringBoard/SBIcon.h>
#import <SpringBoard/SBIconView.h>
#import <SpringBoard/SBFolderView.h>
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBIconViewMap.h>

@interface SBFolderView (ShyPageDots)
-(void)_prepareHideLabels;
-(void)_hideLabels;
-(void)_showLabels;
@end

static void animateIconLabelAlpha(double alpha);
