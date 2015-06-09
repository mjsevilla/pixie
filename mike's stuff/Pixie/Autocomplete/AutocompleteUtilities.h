//	AutocompleteUtilities.h

#define kGoogleAPINSErrorCode 42

#import <UIKit/UIKit.h>

@class CLPlacemark;

typedef NS_ENUM(NSInteger, AutocompletePlaceType) {
    SPPlaceTypeAll,
    SPPlaceTypeGeocode,
    SPPlaceTypeEstablishment,
    SPPlaceTypeRegions,
    SPPlaceTypeCities
};

typedef void (^PlacemarkResultBlock)(CLPlacemark *placemark, NSString *addressString, NSError *error);
typedef void (^AutocompleteResultBlock)(NSArray *places, NSError *error);
typedef void (^PlaceDetailResultBlock)(NSDictionary *placeDictionary, NSError *error);

extern AutocompletePlaceType SPPlaceTypeFromDictionary(NSDictionary *placeDictionary);
extern NSString *SPBooleanStringForBool(BOOL boolean);
extern NSString *SPPlaceTypeStringForPlaceType(AutocompletePlaceType type);
extern BOOL SPIsEmptyString(NSString *string);

@interface NSArray(SPFoundationAdditions)
- (id)onlyObject;

@end