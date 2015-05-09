//	AutocompleteUtilities.h

#define kGoogleAPINSErrorCode 42

#import <UIKit/UIKit.h>

@class CLPlacemark;

typedef NS_ENUM(NSInteger, SPGooglePlacesAutocompletePlaceType) {
    SPPlaceTypeAll,
    SPPlaceTypeGeocode,
    SPPlaceTypeEstablishment,
    SPPlaceTypeRegions,
    SPPlaceTypeCities
};

typedef void (^SPGooglePlacesPlacemarkResultBlock)(CLPlacemark *placemark, NSString *addressString, NSError *error);
typedef void (^SPGooglePlacesAutocompleteResultBlock)(NSArray *places, NSError *error);
typedef void (^SPGooglePlacesPlaceDetailResultBlock)(NSDictionary *placeDictionary, NSError *error);

extern SPGooglePlacesAutocompletePlaceType SPPlaceTypeFromDictionary(NSDictionary *placeDictionary);
extern NSString *SPBooleanStringForBool(BOOL boolean);
extern NSString *SPPlaceTypeStringForPlaceType(SPGooglePlacesAutocompletePlaceType type);
extern BOOL SPIsEmptyString(NSString *string);

@interface NSArray(SPFoundationAdditions)
- (id)onlyObject;

@end