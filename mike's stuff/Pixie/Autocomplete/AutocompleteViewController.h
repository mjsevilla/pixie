//	AutocompleteViewController.h

#import <MapKit/MapKit.h>

@class AutocompleteQuery;

@interface AutocompleteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, MKMapViewDelegate> {
    NSArray *searchResultPlaces;
    AutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
	UITableViewController *searchResultsController;
    
    BOOL shouldBeginEditing;
}

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
