/* 
	Copyright (C) 2024  Serge Alagon

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>. 
*/

#include <UIKit/UIKit.h>

@interface CustomToast : UIView
	@property (nonatomic, strong) UILabel *titleLabel;
	@property (nonatomic, strong) UILabel *subtitleLabel;

	- (void)presentToast;
	- (void)hideWithAnimation;
	- (void)hideAfter:(NSTimeInterval)time;

	- (UIWindow *)getKeyWindow;
	- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon iconColor:(UIColor *)iconColor autoHide:(int)autoHide;
@end

@interface CustomToast ()
	@property (nonatomic, strong) UIStackView *hStack; 
	@property (nonatomic, strong) UIStackView *vStack; 
	@property (nonatomic, strong) UIView *containerView;
@end