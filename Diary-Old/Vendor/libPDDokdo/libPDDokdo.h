//
//  libPDDokdo.h
//  libPDDokdo
//
//  Created by Soongyu Kwon (@s8ngyu)
//

@import UIKit;

@interface PDDokdo : NSObject

@property (nonatomic, readwrite) BOOL isCelsius; // If set to false, outputs will be in Fahrenheit
+ (PDDokdo *)sharedInstance;
- (void)refreshData;
- (NSString *)currentTemperature;
- (NSString *)currentLocation;
- (UIImage *)currentConditionImage;
- (NSInteger)currentCondition;
- (NSInteger)lowestTemperature;
- (NSInteger)highestTemperature;
- (NSString *)currentConditionAsString;
- (void)refreshWeatherData;
- (NSString *)currentConditions;
@end
