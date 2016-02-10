//
//  AGTAnnotation.m
//  Everpobre
//
//  Created by Pedro Martin Gomez on 10/2/16.
//  Copyright © 2016 Agbo. All rights reserved.
//

#import "AGTAnnotation.h"
@import CoreLocation;

@interface AGTAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (strong, nonatomic) NSString *address;

@end

@implementation AGTAnnotation
//@synthesize coordinate=_coordinate;

/*-(NSString *)title{
    return @"Estatua de MazingerZ";
}

-(NSString *)subtitle{
    return @"Meca de frikis y otakus.";
}*/

-(id) init{
    
    if (self = [super init]) {
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(41.3827416, 1.32880926);
        _coordinate = coords;
        
    }
    return self;
}

- (id)initWithTitle:(NSString *) title
           subTitle:(NSString *) subTitle
           latitude:(float) latitude
          longitude:(float) longitude
            address:(NSString *) address {
    
    if (self = [super init]) {
        
        _title = title;
        _subTitle = subTitle;
        _latitude = latitude;
        _longitude = longitude;
        _address = address;
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude, longitude);
        _coordinate = coords;
    }
    return self;
    
}

@end