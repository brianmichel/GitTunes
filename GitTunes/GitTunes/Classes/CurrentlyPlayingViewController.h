//
//  CurrentlyPlayingViewController.h
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "Spotify.h"
#import "AlbumArtProgressView.h"

@interface CurrentlyPlayingViewController : NSViewController

@property (assign) IBOutlet NSTextField *songTitleField;
@property (assign) IBOutlet NSTextField *artistAlbumTextField;
@property (nonatomic, retain) NSTimer *songProgressTimer;
@property (nonatomic, retain) iTunesApplication *iTunes;
@property (nonatomic, retain) SpotifyApplication *spotify;
@property (assign) IBOutlet AlbumArtProgressView *albumArtImage;

@end
