//
//  AGTNoteViewController.m
//  Everpobre
//
//  Created by Fernando Rodríguez Romero on 18/06/14.
//  Copyright (c) 2014 Agbo. All rights reserved.
//

#import "AGTNoteViewController.h"
#import "AGTNote.h"
#import "AGTPhoto.h"
#import "AGTNotebook.h"
#import "AGTPhotoViewController.h"
#import "AGTAnnotation.h"
#import "AGTLocation.h"

@interface AGTNoteViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) AGTNote *model;
@property (nonatomic) BOOL new;
@property (nonatomic) BOOL deleteNote;
@end

@implementation AGTNoteViewController

#pragma mark - Init
-(id) initWithModel:(id) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return self;
}

-(id) initForNewNoteInNotebook: (AGTNotebook*) notebook{
    
    AGTNote *note = [AGTNote noteWithName:@""
                                 location:nil
                                 notebook:notebook
                                  context:notebook.managedObjectContext];
    
    _new = YES;
    return [self initWithModel:note];
}


#pragma mark - View Lifecycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // modelo -> vista
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateStyle = NSDateFormatterLongStyle;
    
    self.modificationDateView.text = [fmt stringFromDate:self.model.modificationDate];
    
    self.nameView.text = self.model.name;
    self.textView.text = self.model.text;
    
    UIImage *img = self.model.photo.image;
    if (!img) {
        img = [UIImage imageNamed:@"noImage.png"];
    }
    
    self.photoView.image = img;
    
    [self startObservingKeyboard];
    
    [self setupInputAccessoryView];
    
    if (self.new) {
        // Add the cancel button
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = cancel;
    }
    
    // delegados
    self.nameView.delegate = self;
    self.textView.delegate = self;

    
    // Añadimos un gesture recognizer a la foto
    self.photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(displayDetailPhoto:)];
    [self.photoView addGestureRecognizer:tap];
    

    // Botón de compartir
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(displayActions:)];
    self.navigationItem.rightBarButtonItem = share;
    
    // añadimos una anotación al mapa con la location
    AGTAnnotation *annotattion = [[AGTAnnotation alloc] initWithTitle:@"lala"
                                                             subTitle:@"lalalalal"
                                                             latitude:[self.model.location.latitude floatValue]
                                                            longitude:[self.model.location.longitude floatValue]
                                                              address:self.model.location.address];
    [self.mapView addAnnotation:annotattion];

} 



-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.deleteNote) {
        [self.model.managedObjectContext deleteObject:self.model];
    }else{
        // vista -> modelo
        self.model.text = self.textView.text;
        self.model.name = self.nameView.text;
        self.model.photo.image = self.photoView.image;
    }
    
    
    [self stopObservingKeyboard];
}

#pragma mark -  TextView
-(void) setupInputAccessoryView{
    
    UIToolbar *textBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, self.textView.frame.size.width, 44)];
    
    UIToolbar *nameBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, self.textView.frame.size.width, 44)];
    
    // Buttons
    UIBarButtonItem *sep = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard:)];
    
    UIBarButtonItem *done2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard:)];
    
    UIBarButtonItem *smile = [[UIBarButtonItem alloc] initWithTitle:@":-)"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(insertTitle:)];
    [textBar setItems: @[smile, sep, done]];
    [nameBar setItems:@[sep, done2]];
    
    self.textView.inputAccessoryView = textBar;
    self.nameView.inputAccessoryView = nameBar;
}

-(void)insertTitle:(UIBarButtonItem *)sender{
    [self.textView insertText:[NSString stringWithFormat:@"%@ ", sender.title]];
}

-(void)hideKeyboard:(id) sender{
    [self.view endEditing:YES];
}

#pragma mark - Keyboard
-(void) startObservingKeyboard{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillAppear:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillDissappear:)
               name:UIKeyboardWillHideNotification
             object:nil];
}

-(void) stopObservingKeyboard{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

// UIKeyboardWillShowNotification
-(void) notifyThatKeyboardWillAppear:(NSNotification *) notification{
    
    if ([self.textView isFirstResponder]) {
        // UserInfo
        NSDictionary *dict = notification.userInfo;
        
        
        double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:0
                         animations:^{
                             
                             self.textView.frame = CGRectMake(self.modificationDateView.frame.origin.x, self.modificationDateView.frame.origin.y, self.view.frame.size.width, self.textView.frame.size.height);
                         } completion:nil];
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:0
                         animations:^{
                             
                             self.textView.alpha = 0.8;
                         } completion:nil];

    }
    
}

// UIKeyboardWillShowNotification
-(void) notifyThatKeyboardWillDissappear:(NSNotification *) notification{
    
    if ([self.textView isFirstResponder]) {
        // UserInfo
        NSDictionary *dict = notification.userInfo;
        
        
        double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:0
                         animations:^{
                             
                             self.textView.frame = CGRectMake(0, 323, self.view.frame.size.width, self.textView.frame.size.height);
                         } completion:nil];
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:0
                         animations:^{
                             
                             self.textView.alpha = 1;
                         } completion:nil];
    }

}

#pragma mark - Utils
-(void) cancel:(id)sender{
    self.deleteNote = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Podríamos comprobar el texto
    [textField resignFirstResponder];
    return YES;
}


-(void) textFieldDidEndEditing:(UITextField *)textField{
    // guardamos
    self.model.name = self.nameView.text;
}

#pragma mark - UITextViewDelegate
-(void) textViewDidEndEditing:(UITextView *)textView{
    
    // Guardamos
    self.model.text = textView.text;
}
#pragma mark - Actions
-(void)displayDetailPhoto:(id) sender{
    
    
    if (self.model.photo == nil) {
        self.model.photo = [AGTPhoto photoWithImage:nil
                                            context:self.model.managedObjectContext];
    }
    AGTPhotoViewController *pVC = [[AGTPhotoViewController alloc] initWithModel:self.model.photo];
    
    [self.navigationController pushViewController:pVC
                                         animated:YES];
    

}

-(void) displayActions:(id) sender{
    
    UIActivityViewController *aVC = [[UIActivityViewController alloc] initWithActivityItems:[self arrayOfNoteItems] applicationActivities:nil];
    
    [self presentViewController:aVC
                       animated:YES
                     completion:nil];
}

-(NSArray *) arrayOfNoteItems{
    
    NSMutableArray *items = [NSMutableArray array];
    if (self.model.name) {
        [items addObject:self.model.name];
    }
    if (self.model.text) {
        [items addObject:self.model.text];
    }
    if (self.model.photo.image) {
        [items addObject:self.model.photo.image];
    }

    return items;

}







@end
















