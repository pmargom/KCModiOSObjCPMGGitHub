#import "_AGTNote.h"

@interface AGTNote : _AGTNote {}
// Custom logic goes here.


+(instancetype) noteWithName:(NSString *) name
                    location:(AGTLocation *) location
                    notebook:(AGTNotebook *) notebook
                     context:(NSManagedObjectContext *) context;

@end
