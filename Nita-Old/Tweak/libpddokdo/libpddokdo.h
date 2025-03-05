@import UIKit;

@interface PDDokdo : NSObject
	@property (nonatomic, readwrite) BOOL isCelsius;

	+ (PDDokdo *)sharedInstance;
	
	- (UIImage *)currentConditionImage;
	
	- (NSInteger)currentCondition;
	- (NSInteger)lowestTemperature;
	- (NSInteger)highestTemperature;

	- (NSString *)currentLocation;
	- (NSString *)currentConditions;
	- (NSString *)currentTemperature;
	- (NSString *)currentConditionAsString;

	- (void)refreshData;
	- (void)refreshWeatherData;
@end

@interface WFTemperature : NSObject

@property (nonatomic, assign, readwrite) CGFloat celsius;
@property (nonatomic, assign, readwrite) CGFloat fahrenheit;

@end

@interface WeatherImageLoader : NSObject

+ (UIImage *)conditionImageWithConditionIndex:(NSInteger)index;

@end

@interface WADayForecast : NSObject

@property (nonatomic, assign, readwrite) NSUInteger icon;

@property (nonatomic, copy, readwrite) WFTemperature *low;
@property (nonatomic, copy, readwrite) WFTemperature *high;

@end

@interface WACurrentForecast : NSObject

@property(assign, nonatomic)long long conditionCode;

- (void)setConditionCode:(long long)arg1;

@end

@interface WAForecastModel : NSObject

@property (nonatomic,retain) WACurrentForecast* currentConditions;
@property (nonatomic, copy, readwrite) NSArray <WADayForecast *>*dailyForecasts;

@end

@interface WALockscreenWidgetViewController : UIViewController

- (UIImage *)_conditionsImage;

- (WAForecastModel *)currentForecastModel;

- (NSString *)_temperature;
- (NSString *)_locationName;
- (NSString *)_conditionsLine;

- (void)updateWeather;
- (void)_updateTodayView;

@end

@interface PDDokdo ()

@property (nonatomic, retain, readonly) WALockscreenWidgetViewController *widget;

@end