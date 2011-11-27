//
//  ToolbarItemButton.h
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import <AppKit/AppKit.h>

typedef enum ToolbarItemStyle {
  ToolbarItemStyleGeneral = 0,
  ToolbarItemStyleAbout
} ToolbarItemStyle;

@interface ToolbarItemButton : NSToolbarItem

@property (nonatomic, assign) ToolbarItemStyle style;
@property (nonatomic, retain) NSButton *button;

+ (NSButton *)buttonFromStyle:(ToolbarItemStyle)style;
- (id)initWithItemIdentifier:(NSString *)itemIdentifier andStyle:(ToolbarItemStyle)style;

@end
