#import "_AGTLocation.h"

@interface AGTLocation : _AGTLocation {}
// Custom logic goes here.

+(instancetype) locationWithLatitude:(NSNumber *) latitude
                           longitude:(NSNumber *) longitude
                             address:(NSString *) address
                             context:(NSManagedObjectContext *) context;
@end
