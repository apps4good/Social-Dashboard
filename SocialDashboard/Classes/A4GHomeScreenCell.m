//
//  A4GHomeScreenCell.m
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "A4GHomeScreenCell.h"

@implementation A4GHomeScreenCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        mediaButton[0] = nil;
        mediaButton[1] = nil;
        mediaButton[2] = nil;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    for (int i = 0; i < 3; i++)
    {
        mediaButton[i].alpha = 1;
    }
}

#pragma mark -
#pragma mark - Properties

-(void)setMediaButtonAtIndex:(NSInteger)index withButton:(UIButton *)newButton
{
    if (mediaButton[index] != nil)
    {
        newButton.frame = mediaButton[index].frame;
    }
    [mediaButton[index] removeFromSuperview];
    mediaButton[index] = newButton;
    [self addSubview: mediaButton[index]];
}

-(void)setButtonA:(UIButton *)buttonA
{
    [self setMediaButtonAtIndex: 0 withButton:buttonA];
}

-(void)setButtonB:(UIButton *)buttonB
{
    [self setMediaButtonAtIndex: 1 withButton:buttonB];
}

-(void)setButtonC:(UIButton *)buttonC
{
    [self setMediaButtonAtIndex: 2 withButton:buttonC];
}

-(UIButton *)buttonA
{
    return mediaButton[0];
}

-(UIButton *)buttonB
{
    return mediaButton[1];
}

-(UIButton *)buttonC
{
    return mediaButton[2];
}

#pragma mark - button action

-(IBAction)openMedia:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.delegate openMediaAtIndex: button.tag - 1];
}


@end
