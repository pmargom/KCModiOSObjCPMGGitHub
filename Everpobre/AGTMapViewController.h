//
//  AGTMapViewController.h
//  Everpobre
//
//  Created by Pedro Martin Gomez on 10/2/16.
//  Copyright © 2016 Agbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGTMapViewController : UIViewController

-(id) initWithAnnotationModel:(NSArray<id<MKAnnotation>> *) model;

@end
