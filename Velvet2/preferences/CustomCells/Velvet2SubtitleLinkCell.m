#import "../../headers/HeadersPreferences.h"

@implementation Velvet2SubtitleLinkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		if (specifier.properties[@"systemIcon"]) {
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:25]];
            UIImage *image = [UIImage systemImageNamed:specifier.properties[@"systemIcon"] withConfiguration:config];
            [specifier setProperty:image forKey:@"iconImage"];

            self.imageView.tintColor = kVelvetColor;
        }

        if (specifier.properties[@"cellSubtitleText"]) {
            self.detailTextLabel.text = specifier.properties[@"cellSubtitleText"];
        }
	}

	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    if (self.specifier.properties[@"systemIcon"]) {
        self.textLabel.frame = CGRectMake(60, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(60, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    }

    PSListController *controller = [self _viewControllerForAncestor];
    if ([controller isKindOfClass:NSClassFromString(@"Velvet2PreviewController")]) {
        Velvet2PreviewController *previewController = (Velvet2PreviewController *)controller;

        if (previewController.identifier && [previewController appSettingForKeyExists:self.specifier.properties[@"key"]]) {
            self.backgroundColor = [kVelvetColor colorWithAlphaComponent:0.3];
        }
    }
}
@end