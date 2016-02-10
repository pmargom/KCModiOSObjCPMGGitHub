#import "AGTLocation.h"

@interface AGTLocation ()

// Private interface goes here.

@end

@implementation AGTLocation

+(instancetype) locationWithLatitude:(NSNumber *) latitude
                           longitude:(NSNumber *) longitude
                             address:(NSString *) address
                             context:(NSManagedObjectContext *) context {
    
    AGTLocation *location = [NSEntityDescription insertNewObjectForEntityForName:[AGTLocation entityName]
                                                          inManagedObjectContext:context];
    
    location.address = address;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
    
}

@end
