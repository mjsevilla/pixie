//	AutocompleteUtilities.m

#import "AutocompleteUtilities.h"

@implementation NSArray(SPFoundationAdditions)
- (id)onlyObject {
    return [self count] >= 1 ? self[0] : nil;
}
@end

NSArray *AutocompletePlaceTypeNames(void)
{
    static NSMutableArray *names = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = [NSMutableArray array];
        
        [names insertObject:@"" atIndex:SPPlaceTypeAll];
        
        [names insertObject:@"geocode" atIndex:SPPlaceTypeGeocode];
        [names insertObject:@"establishment" atIndex:SPPlaceTypeEstablishment];
        [names insertObject:@"(regions)" atIndex:SPPlaceTypeRegions];
        [names insertObject:@"(cities)" atIndex:SPPlaceTypeCities];
    });
    
    return names;
}

AutocompletePlaceType SPPlaceTypeFromDictionary(NSDictionary *placeDictionary) {
    NSUInteger index;
    
    for (NSString *type in placeDictionary[@"types"]) {
        index = [AutocompletePlaceTypeNames() indexOfObject:type];
        
        if (index != NSNotFound) {
            return (AutocompletePlaceType)index;
        }
    }
    
    return SPPlaceTypeGeocode;
}

NSString *SPBooleanStringForBool(BOOL boolean) {
    return boolean ? @"true" : @"false";
}

NSString *SPPlaceTypeStringForPlaceType(AutocompletePlaceType type) {
    return [AutocompletePlaceTypeNames() objectAtIndex:type];
}

extern BOOL SPIsEmptyString(NSString *string) {
    return !string || ![string length];
}