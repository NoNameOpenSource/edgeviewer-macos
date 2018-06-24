// Generated by Apple Swift version 4.1 (swiftlang-902.0.48 clang-902.0.37.1)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import ObjectiveC;
@import AppKit;
@import Foundation;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="EdgeViewer",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS("_TtC10EdgeViewer11AppDelegate")
@interface AppDelegate : NSObject <NSApplicationDelegate>
- (void)applicationDidFinishLaunching:(NSNotification * _Nonnull)aNotification;
- (void)applicationWillTerminate:(NSNotification * _Nonnull)aNotification;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSEvent;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC10EdgeViewer15ChapterViewItem")
@interface ChapterViewItem : NSCollectionViewItem
- (void)viewDidLoad;
- (void)mouseDown:(NSEvent * _Nonnull)event;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10EdgeViewer18CollectionViewItem")
@interface CollectionViewItem : NSCollectionViewItem
@property (nonatomic, getter=isSelected) BOOL selected;
- (void)viewDidLoad;
- (void)mouseDown:(NSEvent * _Nonnull)event;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSView;
@class NSButton;
@class NSTextField;
@class NSPageController;

SWIFT_CLASS("_TtC10EdgeViewer21ContentViewController")
@interface ContentViewController : NSViewController <NSPageControllerDelegate>
@property (nonatomic, weak) IBOutlet NSView * _Null_unspecified pageView;
@property (nonatomic, weak) IBOutlet NSButton * _Null_unspecified backToDetail;
@property (nonatomic, weak) IBOutlet NSTextField * _Null_unspecified pageNumberLabel;
@property (nonatomic, weak) IBOutlet NSButton * _Null_unspecified chapter;
@property (nonatomic, weak) IBOutlet NSButton * _Null_unspecified bookMark;
@property (nonatomic, weak) IBOutlet NSButton * _Null_unspecified settings;
- (void)viewDidLoad;
- (void)viewDidDisappear;
- (IBAction)viewPrevious:(id _Nonnull)sender;
- (IBAction)viewNext:(id _Nonnull)sender;
- (IBAction)switchViewType:(id _Nonnull)sender;
- (NSPageControllerObjectIdentifier _Nonnull)pageController:(NSPageController * _Nonnull)pageController identifierForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (NSViewController * _Nonnull)pageController:(NSPageController * _Nonnull)pageController viewControllerForIdentifier:(NSPageControllerObjectIdentifier _Nonnull)identifier SWIFT_WARN_UNUSED_RESULT;
- (void)pageController:(NSPageController * _Nonnull)pageController prepareViewController:(NSViewController * _Nonnull)viewController withObject:(id _Nullable)object;
- (NSRect)pageController:(NSPageController * _Nonnull)pageController frameForObject:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
- (void)viewWillLayout;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class RatingControl;
@class NSCollectionView;
@class NSImageView;
@class NSProgressIndicator;

SWIFT_CLASS("_TtC10EdgeViewer20DetailViewController")
@interface DetailViewController : NSViewController
@property (nonatomic, weak) IBOutlet RatingControl * _Null_unspecified ratingControl;
@property (nonatomic, weak) IBOutlet NSCollectionView * _Null_unspecified chapterView;
@property (nonatomic, weak) IBOutlet NSButton * _Null_unspecified ReadFromBeginningButton;
@property (nonatomic, weak) IBOutlet NSTextField * _Null_unspecified mangaTitle;
@property (nonatomic, weak) IBOutlet NSTextField * _Null_unspecified mangaAuthor;
@property (nonatomic, weak) IBOutlet NSTextField * _Null_unspecified mangaGenre;
@property (nonatomic, weak) IBOutlet NSTextField * _Null_unspecified mangaReleaseDate;
@property (nonatomic, strong) IBOutlet NSImageView * _Null_unspecified mangaImage;
@property (nonatomic, weak) IBOutlet NSProgressIndicator * _Null_unspecified mangaProgress;
- (IBAction)showReadFromBeginningButton:(id _Nonnull)sender;
- (IBAction)readButton:(NSButton * _Nonnull)sender;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


@interface DetailViewController (SWIFT_EXTENSION(EdgeViewer)) <NSCollectionViewDelegate>
- (void)collectionView:(NSCollectionView * _Nonnull)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> * _Nonnull)indexPaths;
@end


@interface DetailViewController (SWIFT_EXTENSION(EdgeViewer)) <NSCollectionViewDataSource>
- (NSInteger)collectionView:(NSCollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSCollectionViewItem * _Nonnull)collectionView:(NSCollectionView * _Nonnull)itemForRepresentedObjectAtcollectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC10EdgeViewer24DoublePageViewController")
@interface DoublePageViewController : NSViewController
@property (nonatomic, weak) IBOutlet NSImageView * _Null_unspecified leftImageView;
@property (nonatomic, weak) IBOutlet NSImageView * _Null_unspecified rightImageView;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil SWIFT_UNAVAILABLE;
@end

@protocol NSDraggingInfo;

SWIFT_CLASS("_TtC10EdgeViewer8DropView")
@interface DropView : NSView
@property (nonatomic) BOOL isDir;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)drawRect:(NSRect)dirtyRect;
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo> _Nonnull)sender SWIFT_WARN_UNUSED_RESULT;
- (void)draggingExited:(id <NSDraggingInfo> _Nullable)sender;
- (void)draggingEnded:(id <NSDraggingInfo> _Nonnull)sender;
- (BOOL)performDragOperation:(id <NSDraggingInfo> _Nonnull)sender SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC10EdgeViewer20FileReaderController")
@interface FileReaderController : NSViewController
@property (nonatomic, weak) IBOutlet DropView * _Null_unspecified dropView;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10EdgeViewer10HeaderView")
@interface HeaderView : NSView
@property (nonatomic, weak) IBOutlet NSTextField * _Null_unspecified sectionTitle;
@property (nonatomic, weak) IBOutlet NSTextField * _Null_unspecified imageCount;
- (void)drawRect:(NSRect)dirtyRect;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)decoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSOutlineView;
@class NSTableColumn;

SWIFT_CLASS("_TtC10EdgeViewer25LibraryListViewController")
@interface LibraryListViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (nonatomic, weak) IBOutlet NSOutlineView * _Null_unspecified outlineView;
- (void)viewDidLoad;
- (void)outlineViewSelectionDidChange:(NSNotification * _Nonnull)notification;
- (NSInteger)outlineView:(NSOutlineView * _Nonnull)outlineView numberOfChildrenOfItem:(id _Nullable)item SWIFT_WARN_UNUSED_RESULT;
- (BOOL)outlineView:(NSOutlineView * _Nonnull)outlineView isItemExpandable:(id _Nonnull)item SWIFT_WARN_UNUSED_RESULT;
- (id _Nonnull)outlineView:(NSOutlineView * _Nonnull)outlineView child:(NSInteger)index ofItem:(id _Nullable)item SWIFT_WARN_UNUSED_RESULT;
- (NSView * _Nullable)outlineView:(NSOutlineView * _Nonnull)outlineView viewForTableColumn:(NSTableColumn * _Nullable)tableColumn item:(id _Nonnull)item SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10EdgeViewer21LibraryViewController")
@interface LibraryViewController : NSSplitViewController
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSXMLParser;

SWIFT_CLASS("_TtC10EdgeViewer20LocalPluginXMLParser")
@interface LocalPluginXMLParser : NSObject <NSXMLParserDelegate>
- (void)parser:(NSXMLParser * _Nonnull)parser didStartElement:(NSString * _Nonnull)elementName namespaceURI:(NSString * _Nullable)namespaceURI qualifiedName:(NSString * _Nullable)qName attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributeDict;
- (void)parser:(NSXMLParser * _Nonnull)parser didEndElement:(NSString * _Nonnull)elementName namespaceURI:(NSString * _Nullable)namespaceURI qualifiedName:(NSString * _Nullable)qName;
- (void)parser:(NSXMLParser * _Nonnull)parser foundCharacters:(NSString * _Nonnull)string;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC10EdgeViewer13ProjectWindow")
@interface ProjectWindow : NSWindow
- (nonnull instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag OBJC_DESIGNATED_INITIALIZER;
- (IBAction)goBack:(id _Nullable)sender;
@end


SWIFT_CLASS("_TtC10EdgeViewer13RatingControl")
@interface RatingControl : NSStackView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)mouseDown:(NSEvent * _Nonnull)event;
@end


SWIFT_CLASS("_TtC10EdgeViewer19ShelfViewController")
@interface ShelfViewController : NSViewController
@property (nonatomic, weak) IBOutlet NSCollectionView * _Null_unspecified collectionView;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSCollectionViewLayout;

@interface ShelfViewController (SWIFT_EXTENSION(EdgeViewer)) <NSCollectionViewDelegateFlowLayout>
- (NSSize)collectionView:(NSCollectionView * _Nonnull)collectionView layout:(NSCollectionViewLayout * _Nonnull)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
@end


@interface ShelfViewController (SWIFT_EXTENSION(EdgeViewer)) <NSCollectionViewDelegate>
- (void)collectionView:(NSCollectionView * _Nonnull)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> * _Nonnull)indexPaths;
@end


@interface ShelfViewController (SWIFT_EXTENSION(EdgeViewer)) <NSCollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView * _Nonnull)collectionView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)collectionView:(NSCollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSCollectionViewItem * _Nonnull)collectionView:(NSCollectionView * _Nonnull)itemForRepresentedObjectAtcollectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (NSView * _Nonnull)collectionView:(NSCollectionView * _Nonnull)collectionView viewForSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind _Nonnull)kind atIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC10EdgeViewer24SinglePageViewController")
@interface SinglePageViewController : NSViewController
@property (nonatomic, weak) IBOutlet NSImageView * _Null_unspecified imageView;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC10EdgeViewer13UserPanelView")
@interface UserPanelView : NSView
- (void)drawRect:(NSRect)dirtyRect;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)decoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10EdgeViewer14ViewController")
@interface ViewController : NSViewController
- (void)viewDidLoad;
@property (nonatomic) id _Nullable representedObject;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
