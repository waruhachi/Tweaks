@import Cephei;
@import CepheiPrefs;

#import <roothide.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

@interface AmongLockRootListController : HBRootListController {
    UITableView * _table;
}
@property(nonatomic, retain)UISwitch* enableSwitch;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
- (void)toggleState;
- (void)setEnableSwitchState;
- (void)resetPrompt;
- (void)resetPreferences;
- (void)respring;
- (void)respringUtil;
@end

@interface NSTask : NSObject
@property(copy)NSString* launchPath;
- (void)launch;
@end