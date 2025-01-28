#import "Headers.h"

%group EasyAirplaneDisabler

%hook SBApplicationLaunchNotifyAirplaneModeAlertItem
-(void)didActivate {
    %orig;

    _SBAlertController *sbAlertController = MSHookIvar<_SBAlertController *>(self, "_alertController"); //This iVar is nil until the alert is activated
    UIAlertAction *settingsAction = [sbAlertController.actions firstObject];
    if (settingsAction) {
        //Replace "Open Settings" action with "Turn off Airplane"
        __block _SBAlertController *sbAlertControllerBl = sbAlertController;
        [settingsAction setHandler:^(UIAlertAction * action) {
            RadiosPreferences *preferences = [%c(RadiosPreferences) new];
            [preferences setAirplaneMode:NO];
            [preferences synchronize];
            [[%c(SBAlertItemsController) sharedInstance] deactivateAlertItem:sbAlertControllerBl.alertItem]; //Overriding handler causes alert to not dismiss. So I manually dismiss it.
        }];

        //Replace "Settings" button text with localized "Turn off" button
        //Localized keys are found in SpringBoard.strings files or with frida-trace on this method
        NSString *localizedDisable = [[NSBundle mainBundle] localizedStringForKey:@"TURN_OFF" value:@"Turn off" table:@"SpringBoard"];
        [settingsAction setTitle:localizedDisable];
    }
}
%end //hook SBApplicationLaunchNotifyAirplaneModeAlertItem

%end //group EasyAirplaneDisabler


%ctor {
    %init(EasyAirplaneDisabler);
}