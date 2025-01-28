#import <spawn.h>
#include "CentralRootListController.h"

@implementation CentralRootListController
	- (NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		}

		return _specifiers;
	}
@end
