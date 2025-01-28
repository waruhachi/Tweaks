@interface PUStackView : UIView
@property (nonatomic, retain) UIView *lockView;
-(void)updateLockViewForCollection:(PHCollection *)collection;
@end

@interface PUAlbumListCellContentView : UIView
@property (setter=_setStackView:,nonatomic,retain) PUStackView* stackView;
@end

@interface PUAlbumGadget : NSObject
@property(retain, nonatomic) PHCollection *collection;
@property(retain, nonatomic) PUAlbumListCellContentView *albumListCellContentView;
@end

@interface PXGadgetUIViewController : UICollectionViewController
@end

@interface PXHorizontalCollectionGadget : PXGadgetUIViewController
@end

@interface PUHorizontalAlbumListGadget : PXHorizontalCollectionGadget
-(PUAlbumGadget *)gadgetAtLocation:(CGPoint)location inCoordinateSpace:(id)space;
-(PUAlbumGadget *)_gadgetAtIndexPath:(NSIndexPath *)indexPath;
@end



@interface PUSessionInfo : NSObject
@property(retain, nonatomic) PHAssetCollection *targetAlbum;
@property(retain, nonatomic) PHAssetCollection *sourceAlbum;
@property (nonatomic, readwrite, copy) NSOrderedSet *transferredAssets;
@end

@interface PUAlbumPickerSessionInfo : PUSessionInfo
@end

@interface PUAlbumListViewController : UIViewController
@property (nonatomic, readwrite, strong) PUSessionInfo *sessionInfo;
@property (nonatomic, readwrite, strong) PHCollection *collection;
-(PHAssetCollection *)collectionAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface PUAlbumListCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) PUAlbumListCellContentView *albumListCellContentView;
@end