//
//  CurrentlyPlayingViewController.m
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import "CurrentlyPlayingViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kSpotifyBundlePlayerInfoKey @"com.spotify.client.PlaybackStateChanged"
#define kiTunesBundlePlayerInfoKey @"com.apple.iTunes.playerInfo"
#define kiTunesArtistKey @"Artist"
#define kiTunesSongKey @"Name"
#define kiTunesAlbumKey @"Album"
#define kiTunesSongTotalTime @"Total Time"

@interface CurrentlyPlayingViewController (Private)
- (void)updateTrackInfoFromNote:(NSNotification *)note;
- (void)updateTrackInfoFromDictionary:(NSDictionary *)songDictionary;
- (NSImage *)getAlbumArtwork;
- (NSDictionary *)currentlyPlayingSongDictionary;
@end

@implementation CurrentlyPlayingViewController
@synthesize songTitleField = __songTitleField;
@synthesize artistAlbumTextField = __artistAlbumTextField;
@synthesize spotify = __spotify;
@synthesize albumArtImage = _albumArtImage;
@synthesize iTunes = __iTunes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
      [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfoFromNote:) name:kiTunesBundlePlayerInfoKey object:nil];
      [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfoFromNote:) name:kSpotifyBundlePlayerInfoKey object:nil];
    }  
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.view setFrame:NSMakeRect(0, 0, self.view.frame.size.width, 50)];
  self.iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
  self.spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
  [self updateTrackInfoFromDictionary:[self currentlyPlayingSongDictionary]];
  [self.albumArtImage setImage:[self getAlbumArtwork]];
}

#pragma mark - Setters For Different Programs
- (void)updateTrackInfoFromNote:(NSNotification *)note {
  [self updateTrackInfoFromDictionary:[note userInfo]];
  [self.albumArtImage setImage:[self getAlbumArtwork]];
}

- (void)updateTrackInfoFromDictionary:(NSDictionary *)songDictionary {
  NSFont *boldSmallFont = [NSFont boldSystemFontOfSize:13.0f];
  
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *tmp = [[[NSAttributedString alloc] initWithString:[songDictionary objectForKey:kiTunesArtistKey] attributes:[NSDictionary dictionaryWithObject:boldSmallFont forKey:NSFontAttributeName]] autorelease];
  [str appendAttributedString:tmp];
  
  NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
  
  NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:self.artistAlbumTextField.font, NSFontAttributeName, pStyle, NSParagraphStyleAttributeName, nil];  
  tmp = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@",[songDictionary objectForKey:kiTunesAlbumKey]] attributes:attribs] autorelease];
  [str appendAttributedString:tmp];
  
  [self.artistAlbumTextField setAttributedStringValue:str];
  [str release];
  
  [self.songTitleField setStringValue:[songDictionary objectForKey:kiTunesSongKey]];
}

#pragma mark - Actions
- (NSImage *)getAlbumArtwork {
  if ([self.iTunes isRunning] && self.iTunes.playerState == iTunesEPlSPlaying) {
    SBElementArray *art = [[self.iTunes currentTrack] artworks];
    if ([art count] >= 1) {
      iTunesArtwork *artwork = [art objectAtIndex:0];
      return artwork.data;
    }
  } else if ([self.spotify isRunning] && self.spotify.playerState == SpotifyEPlSPlaying) {
    if ([[self.spotify currentTrack] artwork]) {
      return [[self.spotify currentTrack] artwork];
    }
  }
  return nil;
}

- (NSDictionary *)currentlyPlayingSongDictionary {
  NSMutableDictionary *songDict = [NSMutableDictionary dictionaryWithCapacity:3];
  if ([self.iTunes isRunning] && self.iTunes.playerState == iTunesEPlSPlaying) {
    iTunesTrack *track = [self.iTunes currentTrack];
    [songDict setValue:track.artist forKey:kiTunesArtistKey];
    [songDict setValue:track.album forKey:kiTunesAlbumKey];
    [songDict setValue:track.name forKey:kiTunesSongKey];
  } else if ([self.spotify isRunning] && self.spotify.playerState == SpotifyEPlSPlaying) {
    SpotifyTrack *track = [self.spotify currentTrack];
    [songDict setValue:track.artist forKey:kiTunesArtistKey];
    [songDict setValue:track.album forKey:kiTunesAlbumKey];
    [songDict setValue:track.name forKey:kiTunesSongKey];
  }
  return songDict;
}

- (void)dealloc {
  [__iTunes release];
  [__spotify release];
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:kiTunesBundlePlayerInfoKey object:nil];
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:kSpotifyBundlePlayerInfoKey object:nil];
  [__songTitleField release];
  [__artistAlbumTextField release];
  [super dealloc];
}

@end
