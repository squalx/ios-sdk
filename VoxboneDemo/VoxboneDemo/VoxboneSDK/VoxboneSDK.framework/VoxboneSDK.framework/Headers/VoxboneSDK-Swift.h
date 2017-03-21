// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
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

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
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
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
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
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
@import VoxImplant;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@protocol VoxboneDelegate;

SWIFT_CLASS("_TtC10VoxboneSDK9VBWrapper")
@interface VBWrapper : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) VBWrapper * _Nonnull shared;)
+ (VBWrapper * _Nonnull)shared;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (void)setVoxboneDelegateWithDelegate:(id <VoxboneDelegate> _Null_unspecified)delegate;
- (id <VoxboneDelegate> _Null_unspecified)getVoxboneDelegate;
- (void)connect;
- (void)connect:(BOOL)connectivityCheck;
- (void)connectTo:(NSString * _Null_unspecified)host;
- (void)closeConnection;
- (void)loginWithUsername:(NSString * _Null_unspecified)user andPassword:(NSString * _Null_unspecified)password;
- (void)loginWithUsername:(NSString * _Null_unspecified)user andOneTimeKey:(NSString * _Null_unspecified)hash;
- (void)loginWithUsername:(NSString * _Null_unspecified)user andToken:(NSString * _Null_unspecified)token;
- (void)refreshTokenWithUsername:(NSString * _Null_unspecified)user andToken:(NSString * _Null_unspecified)token;
- (void)requestOneTimeKeyWithUsername:(NSString * _Null_unspecified)user;
- (NSString * _Null_unspecified)createCall:(NSString * _Null_unspecified)to withVideo:(BOOL)video andCustomData:(NSString * _Null_unspecified)customData;
- (BOOL)startCall:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (BOOL)attachAudioTo:(NSString * _Null_unspecified)callId;
- (BOOL)disconnectCall:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)declineCall:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)answerCall:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)sendDTMF:(NSString * _Null_unspecified)callId digit:(int32_t)digit;
- (void)sendMessage:(NSString * _Null_unspecified)callId withText:(NSString * _Null_unspecified)text andHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)sendInfo:(NSString * _Null_unspecified)callId withType:(NSString * _Null_unspecified)mimeType content:(NSString * _Null_unspecified)content andHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)setMute:(BOOL)b;
- (BOOL)setUseLoudspeaker:(BOOL)b;
- (NSTimeInterval)getCallDuration:(NSString * _Null_unspecified)callId;
@end

@class NSNumber;

@interface VBWrapper (SWIFT_EXTENSION(VoxboneSDK)) <VoxImplantDelegate>
- (void)onLoginSuccessfulWithDisplayName:(NSString * _Null_unspecified)displayName andAuthParams:(NSDictionary * _Null_unspecified)authParams;
- (void)onLoginFailedWithErrorCode:(NSNumber * _Null_unspecified)errorCode;
- (void)onOneTimeKeyGenerated:(NSString * _Null_unspecified)key;
- (void)onRefreshTokenFailed:(NSNumber * _Null_unspecified)errorCode;
- (void)onRefreshTokenSuccess:(NSDictionary * _Null_unspecified)authParams;
- (void)onConnectionSuccessful;
- (void)onConnectionClosed;
- (void)onConnectionFailedWithError:(NSString * _Null_unspecified)reason;
- (void)onCallConnected:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallDisconnected:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallRinging:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallFailed:(NSString * _Null_unspecified)callId withCode:(int32_t)code andReason:(NSString * _Null_unspecified)reason withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallAudioStarted:(NSString * _Null_unspecified)callId;
@end


SWIFT_PROTOCOL("_TtP10VoxboneSDK15VoxboneDelegate_")
@protocol VoxboneDelegate <NSObject>
@optional
- (void)onLoginSuccessfulWithDisplayName:(NSString * _Null_unspecified)displayName andAuthParams:(NSDictionary * _Null_unspecified)authParams;
- (void)onLoginFailedWithErrorCode:(NSNumber * _Null_unspecified)errorCode;
- (void)onOneTimeKeyGenerated:(NSString * _Null_unspecified)key;
- (void)onRefreshTokenFailed:(NSNumber * _Null_unspecified)errorCode;
- (void)onRefreshTokenSuccess:(NSDictionary * _Null_unspecified)authParams;
- (void)onConnectionSuccessful;
- (void)onConnectionClosed;
- (void)onConnectionFailedWithError:(NSString * _Null_unspecified)reason;
- (void)onCallConnected:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallDisconnected:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallRinging:(NSString * _Null_unspecified)callId withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallFailed:(NSString * _Null_unspecified)callId withCode:(int32_t)code andReason:(NSString * _Null_unspecified)reason withHeaders:(NSDictionary * _Null_unspecified)headers;
- (void)onCallAudioStarted:(NSString * _Null_unspecified)callId;
@end

#pragma clang diagnostic pop
