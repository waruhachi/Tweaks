@interface SBApplicationLaunchNotifyAirplaneModeAlertItem : NSObject
-(void)_turnOffAirplaneMode;
@end

@interface SBAlertItem : NSObject
@end

@interface _SBAlertController : UIAlertController
@property (nonatomic,retain) NSArray * actions;
@property (assign,nonatomic) SBAlertItem * alertItem;
@end

@interface SBAlertItemsController : NSObject
+(id)sharedInstance;
-(void)deactivateAlertItem:(SBAlertItem*)arg1;
@end

@interface UIAlertAction (Private)
-(void)setTitle:(NSString *)arg1;
-(void)setHandler:(void (^)(UIAlertAction *action))arg1;
@end

@interface RadiosPreferences : NSObject
-(void)setAirplaneMode:(bool)arg1;
-(void)synchronize;
@end