//	AutocompletePlace.m

#import "AutocompletePlace.h"
#import "PlaceDetailQuery.h"

@interface AutocompletePlace()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) AutocompletePlaceType type;
@end

@implementation AutocompletePlace

+ (AutocompletePlace *)placeFromDictionary:(NSDictionary *)placeDictionary apiKey:(NSString *)apiKey
{
    AutocompletePlace *place = [[self alloc] init];
    place.name = placeDictionary[@"description"];
    place.reference = placeDictionary[@"reference"];
    place.identifier = placeDictionary[@"id"];
    place.type = SPPlaceTypeFromDictionary(placeDictionary);
    place.key = apiKey;
    return place;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@, Reference: %@, Identifier: %@, Type: %@",
            self.name, self.reference, self.identifier, SPPlaceTypeStringForPlaceType(self.type)];
}

- (CLGeocoder *)geocoder {
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    return geocoder;
}

- (void)resolveEstablishmentPlaceToPlacemark:(PlacemarkResultBlock)block {
    PlaceDetailQuery *query = [[PlaceDetailQuery alloc] initWithApiKey:self.key];
    query.reference = self.reference;
    [query fetchPlaceDetail:^(NSDictionary *placeDictionary, NSError *error) {
        if (error) {
            block(nil, nil, error);
        } else {
            NSString *addressString = placeDictionary[@"formatted_address"];
            [[self geocoder] geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error) {
                    [self resolveGecodePlaceToPlacemark:block];
                } else {
                    CLPlacemark *placemark = [placemarks onlyObject];
                    block(placemark, self.name, error);
                }
            }];
        }
    }];
}

- (void)resolveGecodePlaceToPlacemark:(PlacemarkResultBlock)block {
    [[self geocoder] geocodeAddressString:self.name completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            block(nil, nil, error);
        } else {
            CLPlacemark *placemark = [placemarks onlyObject];
            block(placemark, self.name, error);
        }
    }];
}

- (void)resolveToPlacemark:(PlacemarkResultBlock)block {
    if (self.type == SPPlaceTypeGeocode) {
        [self resolveGecodePlaceToPlacemark:block];
    } else {
        [self resolveEstablishmentPlaceToPlacemark:block];
    }
}


@end
