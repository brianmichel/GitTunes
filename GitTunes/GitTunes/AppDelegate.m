//
//  AppDelegate.m
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (Private)
- (void)updateTrackInfo:(NSNotification *)note;
- (NSString *)currentlyPlayingString;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize statusItem = __statusItem;
@synthesize statusMenu = __statusMenu;
@synthesize playingItem = __playingItem;
@synthesize currentlyPlayingDictionary = __currentlyPlayingDictionary;
@synthesize cpvc = __cpvc;

- (void)dealloc
{
  [super dealloc];
  [__statusItem release];
  [__statusMenu release];
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

- (void)updateTrackInfo:(NSNotification *)note {
  self.currentlyPlayingDictionary = [note userInfo];
  [self.playingItem setTitle:[self currentlyPlayingString]];
}

#pragma mark - NSMenu Delegate
- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu {
  return 5;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel {
  switch (index) {
    case 0:
      [item setTitle:@"Preferences"];
      [item setAction:@selector(action:)];
      break;
    case 2:
      [item setView:self.cpvc.view];
      break;
    case 4:
      [item setTitle:@"Quit"];
      break;
    default:
      break;
  }
  return YES;
}

- (void)action:(id)sender {
  NSLog(@"OH HAI");
}

@end
