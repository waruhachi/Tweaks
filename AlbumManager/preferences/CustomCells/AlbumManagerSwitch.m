#import "../../headers/AlbumManager/Preferences.h"

@implementation AlbumManagerSwitch
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		[((UISwitch *)[self control]) setOnTintColor:kAlbumManagerColor];

        if (specifier.properties[@"systemIcon"]) {
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:25]];
            UIImage *image = [UIImage systemImageNamed:specifier.properties[@"systemIcon"] withConfiguration:config];
            [specifier setProperty:image forKey:@"iconImage"];

            self.imageView.tintColor = kAlbumManagerColor;
        }

        self.detailTextLabel.numberOfLines = 4;
	}

	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.specifier.properties[@"systemIcon"]) {
        self.textLabel.frame = CGRectMake(60, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(60, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    }
    
}
@end