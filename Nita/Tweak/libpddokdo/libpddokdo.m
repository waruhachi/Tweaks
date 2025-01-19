#import "libpddokdo.h"

@implementation PDDokdo
@synthesize widget = _widget;

+ (PDDokdo *)sharedInstance {
	static PDDokdo *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [self new];
	});
	return sharedInstance;
}

- (WALockscreenWidgetViewController *)widget {
	if (_widget) return _widget;

	_widget = [NSClassFromString(@"WALockscreenWidgetViewController") new];
	return _widget;
}

- (void)refreshData {
	[self.widget updateWeather];
	[self.widget _updateTodayView];
}

- (NSString *)currentTemperature {
	return [self.widget respondsToSelector:@selector(_temperature)] ? [self.widget _temperature] : @"Unknown Temperature";
}

- (NSString *)currentLocation {
	return [self.widget respondsToSelector:@selector(_locationName)] ? [self.widget _locationName] : @"Unknown Location";
}

- (UIImage *)currentConditionImage {
	if ([self.widget respondsToSelector:@selector(_conditionsImage)]) {
		return [self.widget _conditionsImage];
	} else {
		return [NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:-1];
	}
}

- (NSInteger)currentCondition {
	if ([self.widget respondsToSelector:@selector(currentForecastModel)]) {
		if ([self.widget currentForecastModel]) {
			WADayForecast *dailyForecast = [[self.widget currentForecastModel] dailyForecasts][0];
			return dailyForecast.icon;
		}
	}

	return -1;
}

- (NSInteger)lowestTemperature {
	if ([self.widget respondsToSelector:@selector(currentForecastModel)]) {
		if ([self.widget currentForecastModel] && [[self.widget currentForecastModel] respondsToSelector:@selector(dailyForecasts)]) {
			@try {
				WADayForecast *dailyForecast = [[self.widget currentForecastModel] dailyForecasts][0];
				return self.isCelsius ? dailyForecast.low.celsius : dailyForecast.low.fahrenheit;
			} @catch (NSException *exception) {
				NSLog(@"[Nightwind] -> -[PDDokdo lowestTemperature] exception: %@", exception);
			}
		}
	}
	return 0;
}

- (NSInteger)highestTemperature {
	if ([self.widget respondsToSelector:@selector(currentForecastModel)]) {
		if ([self.widget currentForecastModel]) {
			@try {
				WADayForecast *dailyForecast = [[self.widget currentForecastModel] dailyForecasts][0];
				return self.isCelsius ? dailyForecast.high.celsius : dailyForecast.high.fahrenheit;
			} @catch (NSException *exception) {
				NSLog(@"[Nightwind] -> -[PDDokdo highestTemperature] exception: %@", exception);
			}
		}
	}

	return 0;
}

- (NSString *)currentConditionAsString {
	return [self.widget _conditionsLine] ? [self.widget _conditionsLine] : @"Unknown Condition";
}

- (void)refreshWeatherData {
	if ([self.widget respondsToSelector:@selector(updateWeather)]) {
		[self.widget updateWeather];
	}
	if ([self.widget respondsToSelector:@selector(_updateTodayView)]) {
		[self.widget _updateTodayView];
	}
}

- (NSString *)currentConditions {
	if ([self.widget respondsToSelector:@selector(_conditionsLine)]) {
		return [self.widget _conditionsLine];
	}
	return @"N/A";
}

@end