//
//  ToolbarItemButton.m
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import "ToolbarItemButton.h"

@implementation ToolbarItemButton

@synthesize style = __style;
@synthesize button = __button;

+ (NSButton *)buttonFromStyle:(ToolbarItemStyle)style {
  NSButton *button = [[[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 50, 50)] autorelease];
  NSImage *image = [NSImage imageNamed:@"template.pdf"];
  [image setTemplate:YES];
  [button setImage:image];
  [button setBordered:NO];
  [button setButtonType:NSToggleButton];

  return button;
}

- (id)initWithItemIdentifier:(NSString *)itemIdentifier andStyle:(ToolbarItemStyle)style {
  self = [super initWithItemIdentifier:itemIdentifier];
  if (self) {
    self.style = style;
    self.button = [ToolbarItemButton buttonFromStyle:style];
    [self setView:self.button];
    NSMenuItem *menuRep = [[NSMenuItem alloc] initWithTitle:@"Text" action:nil keyEquivalent:@""];
    [menuRep setTarget:self];
    [self setMenuFormRepresentation:menuRep];
    [menuRep release];
  }
  return self;
}

- (id)initWithItemIdentifier:(NSString *)itemIdentifier {
  return [self initWithItemIdentifier:itemIdentifier andStyle:ToolbarItemStyleAbout];
}

- (void)dealloc {
  [__button release];
  [super dealloc];
}

@end
