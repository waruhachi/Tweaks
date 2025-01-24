#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

%hook NSJSONSerialization

+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error {
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	if (jsonString) {
		jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"membershipTypeId\":\\d+" withString:@"\"membershipTypeId\":2" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonString.length)];
		data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	}
	
	return %orig(data, opt, error);
}

%end