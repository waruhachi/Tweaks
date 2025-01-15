#import "Avrora.h"

BOOL enabled;

%group Avrora

%hook SBApplication

- (NSString *)displayName { // set display names

    if ([SparkAppList doesIdentifier:@"love.litten.avrora.datepreferences" andKey:@"dateApps" containBundleIdentifier:[self bundleIdentifier]]) {
        NSDateFormatter* dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:dateFormatValue];
        if (!lowercaseAllLabelsSwitch) return [[NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]] capitalizedString];
        else return [[NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]] lowercaseString];
    } else if ([SparkAppList doesIdentifier:@"love.litten.avrora.weatherpreferences" andKey:@"weatherApps" containBundleIdentifier:[self bundleIdentifier]]) {
        if (conditionSwitch || temperatureSwitch) {
            if (conditionSwitch && !temperatureSwitch) {
                if (!lowercaseAllLabelsSwitch) return [NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentConditions]];
                else return [[NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentConditions]] lowercaseString];
            } else if (!conditionSwitch && temperatureSwitch) {
                return [NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]];
            }
        } else {
            return %orig;
        }
    } else if ([SparkAppList doesIdentifier:@"love.litten.avrora.clockpreferences" andKey:@"clockApps" containBundleIdentifier:[self bundleIdentifier]]) {
        NSDateFormatter* timeFormat = [NSDateFormatter new];
        [timeFormat setDateFormat:timeFormatValue];
        return [NSString stringWithFormat:@"%@", [timeFormat stringFromDate:[NSDate date]]];
    } else if ([SparkAppList doesIdentifier:@"love.litten.avrora.nowplayingpreferences" andKey:@"nowPlayingApps" containBundleIdentifier:[self bundleIdentifier]]) {
        if (songTitleSwitch || artistNameSwitch) {
            if ([[%c(SBMediaController) sharedInstance] isPlaying] || [[%c(SBMediaController) sharedInstance] isPaused]) {
                if (songTitleSwitch && !artistNameSwitch) {
                    if (!lowercaseAllLabelsSwitch) return songTitle;
                    else [songTitle lowercaseString];
                } else if (!songTitleSwitch && artistNameSwitch) {
                    if (!lowercaseAllLabelsSwitch) return artistName;
                    else [artistName lowercaseString];
                }
            } else {
                return %orig;
            }
        } else {
            return %orig;
        }
    } else {
        if (lowercaseAllLabelsSwitch)
            return [%orig lowercaseString];

        if (hideAllOtherLabelsSwitch)
            return @"";
    }

    return %orig;
    
}

%end

%hook SBIconController

- (void)viewDidAppear:(BOOL)animated { // refresh weather data when home screen appears

    %orig;

    if (!conditionSwitch && !temperatureSwitch) return;

    [[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%hook SBFolderIcon

- (id)displayNameForLocation:(id)arg1 { // lowercase/hide folder names

    if (!lowercaseAllLabelsSwitch && !hideAllOtherLabelsSwitch)
        return %orig;
    else if (lowercaseAllLabelsSwitch)
        return [%orig lowercaseString];
    else if (hideAllOtherLabelsSwitch)
        return nil;
    else
        return %orig;

}

%end

%hook SBHWidget

- (id)displayName { // lowercase/hide widget names

    if (!lowercaseAllLabelsSwitch && !hideAllOtherLabelsSwitch)
        return %orig;
    else if (lowercaseAllLabelsSwitch)
        return [%orig lowercaseString];
    else if (hideAllOtherLabelsSwitch)
        return @"";
    else
        return %orig;

}

%end

%end

%group AvroraData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get current song and artist name

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary* dict = (__bridge NSDictionary *)information;
        if (dict) {
            if (songTitleSwitch) {
                if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle])
                    songTitle = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];
            } else if (artistNameSwitch) {
                if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist])
                    artistName = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist];
            }
        }
    });
    
}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.avrorapreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];

    // date
    [preferences registerObject:&dateFormatValue default:@"MMMM" forKey:@"dateFormat"];

    // clock
    [preferences registerObject:&timeFormatValue default:@"HH:mm" forKey:@"timeFormat"];

    // weather
    [preferences registerBool:&conditionSwitch default:NO forKey:@"condition"];
    [preferences registerBool:&temperatureSwitch default:NO forKey:@"temperature"];

    // now playing
    [preferences registerBool:&songTitleSwitch default:NO forKey:@"songTitle"];
    [preferences registerBool:&artistNameSwitch default:NO forKey:@"artistName"];

    // miscellaneous
    [preferences registerBool:&lowercaseAllLabelsSwitch default:NO forKey:@"lowercaseAllLabels"];
    [preferences registerBool:&hideAllOtherLabelsSwitch default:NO forKey:@"hideAllOtherLabels"];

	if (enabled) {
		%init(Avrora);
        if (songTitleSwitch || artistNameSwitch) %init(AvroraData);
    }

}