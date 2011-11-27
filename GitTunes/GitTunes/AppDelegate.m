//
//  AppDelegate.m
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ToolbarItemButton.h"


@interface AppDelegate (Private)
- (void)updateTrackInfo:(NSNotification *)note;
- (NSString *)currentlyPlayingString;
- (void)quitAction:(id)sender;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize statusItem = __statusItem;
@synthesize statusMenu = __statusMenu;
@synthesize playingItem = __playingItem;
@synthesize toolbar = __toolbar;
@synthesize currentlyPlayingDictionary = __currentlyPlayingDictionary;
@synthesize cpvc = __cpvc;
@synthesize preferencesWindow = __preferencesWindow;

- (void)dealloc
{
  [__statusItem release];
  [__statusMenu release];
  [__toolbar release];
  [__currentlyPlayingDictionary release];
  [__preferencesWindow release];
  [__cpvc release];
  [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application

}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]; 
  [self.statusItem setMenu:self.statusMenu];
  [self.statusItem setTitle:@"GT"];
  [self.statusItem setHighlightMode:YES];
  
  self.cpvc = [[[CurrentlyPlayingViewController alloc] initWithNibName:@"CurrentlyPlayingView" bundle:nil] autorelease];
}

#pragma mark - NSMenu Delegate
- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu {
  return 5;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel {
  switch (index) {
    case 0:
      [item setTitle:@"Preferences"];
      [item setAction:@selector(showPreferences:)];
      break;
    case 2:
      [item setView:self.cpvc.view];
      break;
    case 4:
      [item setTitle:@"Quit GitTunes"];
      [item setAction:@selector(quitAction:)];
      break;
    default:
      break;
  }
  return YES;
}

#pragma mark - Toolbar Delegate
- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
  return [NSArray arrayWithObjects:@"general", @"about", nil];
}

- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
  return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem*)toolbar:(NSToolbar*)toolbar itemForItemIdentifier:(NSString*)str willBeInsertedIntoToolbar:(BOOL)flag {
  if ([str isEqualToString:@"general"] || [str isEqualToString:@"about"]) {
    ToolbarItemButton* item = [[ToolbarItemButton alloc] initWithItemIdentifier:str];
    return [item autorelease];  
  }
  return nil;
}

#pragma mark - Actions
- (void)quitAction:(id)sender {
  [[NSApplication sharedApplication] terminate:nil];
}

- (void)showPreferences:(id)sender {
  [self.preferencesWindow makeKeyAndOrderFront:self];
}

@end
