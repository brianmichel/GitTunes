//
//  AppDelegate.h
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CurrentlyPlayingViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate, NSToolbarDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSWindow *preferencesWindow;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) IBOutlet NSToolbar *toolbar;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) NSDictionary *currentlyPlayingDictionary;
@property (nonatomic, retain) NSMenuItem *playingItem;
@property (nonatomic, retain) CurrentlyPlayingViewController *cpvc;

@end
