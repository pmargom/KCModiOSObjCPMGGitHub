//
//  AGTNotebookCellView.m
//  Everpobre
//
//  Created by Fernando Rodríguez Romero on 10/04/14.
//  Copyright (c) 2014 Agbo. All rights reserved.
//

#import "AGTNotebookCellView.h"

@implementation AGTNotebookCellView

#pragma mark -  class methods
+(NSString *)cellId{
    return NSStringFromClass(self);
}
+(CGFloat)cellHeight{
    return 60.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
