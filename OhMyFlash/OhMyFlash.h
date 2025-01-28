@interface AVFlashlight : NSObject
-(BOOL)setFlashlightLevel:(float)level withError:(id*)error ;
@end

static BOOL getBool(NSString *key);
