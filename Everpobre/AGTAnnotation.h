//
//  AGTAnnotation.h
//  Everpobre
//
//  Created by Pedro Martin Gomez on 10/2/16.
//  Copyright © 2016 Agbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface AGTAnnotation : NSObject<MKAnnotation>

- (id)initWithTitle:(NSString *) title
           subTitle:(NSString *) subTitle
           latitude:(float) latitude
          longitude:(float) longitude
            address:(NSString *) address;

@end
