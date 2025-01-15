//
//  CrystalRootListController.h
//  Crystal
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Preferences/PSListController.h>

@interface CrystalRootListController : PSListController
@end

@interface NSTask : NSObject
@property(copy)NSArray* arguments;
@property(copy)NSString* launchPath;
- (void)launch;
@end
