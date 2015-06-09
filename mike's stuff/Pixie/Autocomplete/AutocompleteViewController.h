//	AutocompleteViewController.h

#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;

@interface AutocompleteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, MKMapViewDelegate> {
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
	UITableViewController *searchResultsController;
    
    BOOL shouldBeginEditing;
}

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
