#import <Cephei/HBPreferences.h>

@interface CPAView : UIView <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, retain)HBPreferences* preferences;
@property(nonatomic, retain)UIImage* placeholderImage;
@property(nonatomic, retain)UIButton* dismissButton;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@property(nonatomic, retain)UIView* emptyView;
@property(nonatomic, retain)UILabel* listEmptyLabel;
@property(nonatomic, retain)UILabel* headerLabel;
@property(nonatomic, retain)UIView* headerView;
@property(nonatomic, retain)UIImageView* backgroundView;
@property(nonatomic, assign)CGFloat tableHeight;
@property(nonatomic, assign)CGFloat lastHeight;
@property(nonatomic, assign)CGRect baseFrame;
@property(nonatomic, assign)CGRect targetFrame;
@property(nonatomic, assign)BOOL isOpen;
@property(nonatomic, assign)BOOL isOpenFully;
@property(nonatomic, assign)BOOL showNames;
@property(nonatomic, assign)BOOL showIcons;
@property(nonatomic, assign)BOOL darkMode;
@property(nonatomic, assign)BOOL dismissAfterPaste;
@property(nonatomic, assign)BOOL dismissesFully;
@property(nonatomic, assign)BOOL wantsAnimations;
@property(nonatomic, assign)BOOL playsHapticFeedback;
@property(nonatomic, retain)UIView* wrapperView;
@property(nonatomic, retain)UITableView* tableView;
@property(nonatomic, retain)NSMutableArray* items;
@property(nonatomic, retain)NSMutableDictionary* icons;
- (void)refresh;
- (void)toggle;
- (void)show:(BOOL)fully animated:(BOOL)animated;
- (void)hide:(BOOL)fully animated:(BOOL)animated;
- (void)cpaPaste:(NSString *)text;
- (void)recreateBlur;
- (void)setHeight:(CGFloat)height;
- (void)preloadIcons;
@end