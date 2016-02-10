//
//  AGTAppDelegate.m
//  Everpobre
//
//  Created by Fernando Rodríguez Romero on 01/02/14.
//  Copyright (c) 2014 Agbo. All rights reserved.
//

#import "AGTAppDelegate.h"
#import "AGTSimpleCoreDataStack.h"

#import "AGTNotebook.h"
#import "AGTNote.h"
#import "AGTNotebooksViewController.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+TabNavigation.h"
#import "AGTLocation.h"

@implementation AGTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Crear una instancia del stack de Core Data
    self.model = [AGTSimpleCoreDataStack coreDataStackWithModelName:@"Model"];
    
    // ¿Añadimos datos chorras?
    if (ADD_DUMMY_DATA) {
        [self addDummyData];

    }
    
    
    // Iniciamos el autoguardar
    [self autoSave];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[AGTNotebook entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:AGTNamedEntityAttributes.modificationDate
                                                          ascending:NO],
                            [NSSortDescriptor sortDescriptorWithKey:AGTNamedEntityAttributes.name
                                                          ascending:YES]];
    
    NSFetchedResultsController *results = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                              managedObjectContext:self.model.context
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:nil];
    
    // Controller para mostrar las notas en una lista
    AGTNotebooksViewController *nbVC = [[AGTNotebooksViewController alloc]
                                        initWithFetchedResultsController:results
                                        style:UITableViewStylePlain];
    
    
    
    
    AGTMapViewController *mapVC = [[AGTMapViewController alloc] initWithAnnotationModel:nil];
    
    self.window.rootViewController = [nbVC wrappedInTabBarWithMapViewController:mapVC];
    
    //self.window.rootViewController = [nbVC wrappedInNavigation];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"Adiós, mundo cruel");
}


#pragma mark - Utils

- (float)randomLowerBound: (NSInteger) lowerBound upperBound: (NSInteger) upperBound {
    
    return lowerBound + arc4random() % (upperBound - lowerBound);
    
}


-(void) addDummyData{
    
    [self.model zapAllData];
    
    AGTNotebook *novias = [AGTNotebook notebookWithName:@"Ex-novias para el recuerdo"
                                                context:self.model.context];
    
    //[self randomHeightLowerBound:0 upperBound:200]
    
    AGTLocation *location = [NSEntityDescription insertNewObjectForEntityForName:[AGTLocation entityName]
                                                          inManagedObjectContext:self.model.context];
    
    //location.latitude = [NSNumber numberWithFloat:[self randomLowerBound:20 upperBound:50]];
    //location.longitude = [NSNumber numberWithFloat:[self randomLowerBound:-20 upperBound:10]];
    location.latitude = [NSNumber numberWithFloat:41.3827416];
    location.longitude = [NSNumber numberWithFloat:1.32880926];
    location.address = @"Vete a saber...";
    
    [AGTNote noteWithName:@"Camila Dávalos"
                 location:location
                 notebook:novias
                  context:self.model.context];
    
    [AGTNote noteWithName:@"Mariana Dávalos"
                 location:location
                 notebook:novias
                  context:self.model.context];
    
    [AGTNote noteWithName:@"Pampita"
                 location:location
                 notebook:novias
                  context:self.model.context];
    
    AGTNotebook *lugares = [AGTNotebook notebookWithName:@"Lugares donde me han pasado cosas raras"
                                                 context:self.model.context];
    
    [AGTNote noteWithName:@"Puerta del Sol"
                 location:location
                 notebook:lugares
                  context:self.model.context];
    [AGTNote noteWithName:@"Tatooine"
                 location:location
                 notebook:lugares
                  context:self.model.context];
    [AGTNote noteWithName:@"Dantooine"
                 location:location
                 notebook:lugares
                  context:self.model.context];
    [AGTNote noteWithName:@"Solaria"
                 location:location
                 notebook:lugares
                  context:self.model.context];

    // Guardamos
    [self save];

}
-(void) trastearConDatos{
    
    // Añadir
    [self addDummyData];
    
    
    // Buscar
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[AGTNote entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:AGTNamedEntityAttributes.name
                                                          ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:AGTNamedEntityAttributes.modificationDate
                                                          ascending:NO]];
    NSError *error = nil;
    NSArray *results = [self.model.context executeFetchRequest:req
                                                         error:&error];
    
    if (results == nil) {
        NSLog(@"Error al buscar: %@", results);
    }else{
        NSLog(@"Results %@", results);
    }
    

    
    
}


-(void)save{
    
    [self.model saveWithErrorBlock:^(NSError *error) {
        NSLog(@"Error al guardar %s \n\n %@", __func__, error);
    }];
}

-(void)autoSave{
    
    if (AUTO_SAVE) {
        NSLog(@"Autoguardando....");
        
        [self save];
        [self performSelector:@selector(autoSave)
                   withObject:nil
                   afterDelay:AUTO_SAVE_DELAY_IN_SECONDS];
        
        
    }
}



#pragma mark - Predicate Playground
-(void)predicateTest{
    
    // Obtenemos las novias para el recuerdo
    NSPredicate *novias = [NSPredicate predicateWithFormat:@"notebook.name == 'Ex-novias para el recuerdo'"];
    NSPredicate *davalos = [NSCompoundPredicate andPredicateWithSubpredicates:@[novias,[NSPredicate predicateWithFormat:@"name ENDSWITH[cd] 'davalos' "]]];
    NSPredicate *pampita = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] 'pampita'"];
    
    // Las novias
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[AGTNote entityName]];
    req.predicate = novias;
    
    NSArray *res = [self.model executeRequest:req
                                    withError:^(NSError *error) {
                                        NSLog(@"Error al buscar %@", req);
                                    }];
    
    NSLog(@"Novias:\n %@", res);
    
    // Las dávalos
    req.predicate = davalos;
    res = [self.model executeRequest:req
                           withError:^(NSError *error) {
                               NSLog(@"Error al buscar %@", req);
                           }];
    
    NSLog(@"Dávalos:\n %@", res);
    
    // Pampita
    req.predicate = pampita;
    res = [self.model executeRequest:req
                           withError:^(NSError *error) {
                               NSLog(@"Error al buscar %@", req);
                           }];

    NSLog(@"Pampita:\n %@", res);
}






























@end
