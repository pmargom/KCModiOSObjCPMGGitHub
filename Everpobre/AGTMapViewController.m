//
//  AGTMapViewController.m
//  Everpobre
//
//  Created by Pedro Martin Gomez on 10/2/16.
//  Copyright © 2016 Agbo. All rights reserved.
//

#import "AGTMapViewController.h"

@interface AGTMapViewController ()

@property (nonatomic,strong) NSArray<id<MKAnnotation>> *model;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation AGTMapViewController

-(id) initWithAnnotationModel:(NSArray<id<MKAnnotation>> *) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.mapView addAnnotations: self.model];

}

- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end

