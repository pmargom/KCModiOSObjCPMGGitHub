#import "AGTNote.h"
#import "AGTLocation.h"


@interface AGTNote ()

+(NSArray *)observableKeyNames;

@end


@implementation AGTNote

+(NSArray *) observableKeyNames{
    return @[@"name", @"creationDate", @"notebook", @"photo"];
    
}
+(instancetype) noteWithName:(NSString *) name
                    location:(AGTLocation *) location
                    notebook:(AGTNotebook *) notebook
                     context:(NSManagedObjectContext *) context{
    
    AGTNote *note = [NSEntityDescription insertNewObjectForEntityForName:[AGTNote entityName]
                                                  inManagedObjectContext:context];
    
    note.creationDate = [NSDate date];
    note.notebook = notebook;
    note.modificationDate = [NSDate date];
    note.name = name;
    note.text = @"Type a description";
    note.location = location;
    
    return note;
}


@end
