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

@property (weak, nonatomic) IBOutlet UITextField *county;

/*@property (weak, nonatomic) IBOutlet UISearchBar *county;

@property (weak, nonatomic) IBOutlet UITextField *postal;

@property (weak, nonatomic) IBOutlet UITextField *latlong;*/

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
