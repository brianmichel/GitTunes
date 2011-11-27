//
//  CurrentlyPlayingViewController.m
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import "CurrentlyPlayingViewController.h"
#import "FileOperationManager.h"
#import <QuartzCore/QuartzCore.h>

#define kSpotifyBundlePlayerInfoKey @"com.spotify.client.PlaybackStateChanged"
#define kiTunesBundlePlayerInfoKey @"com.apple.iTunes.playerInfo"
#define kArtistKey @"Artist"
#define kSongKey @"Name"
#define kAlbumKey @"Album"
#define kiTunesSongTotalTime @"Total Time"
#define kSpotifySongTotalTime @"Duration"
#define kMaxValueKey @"maxValue"
#define kCurrentSongKey @"currentSong"
#define kPercentagePlayedNeeded 0.25

@interface CurrentlyPlayingViewController (Private)
- (void)updateTrackInfoFromNote:(NSNotification *)note;
- (void)updateTrackInfoFromDictionary:(NSDictionary *)songDictionary;
- (NSImage *)getAlbumArtwork;
- (NSDictionary *)currentlyPlayingSongDictionary;
- (void)resetAndStartProgressUpdateTimerWithMax:(double)max andSong:(NSDictionary *)song;
@end

@implementation CurrentlyPlayingViewController
@synthesize songTitleField = __songTitleField;
@synthesize artistAlbumTextField = __artistAlbumTextField;
@synthesize songProgressTimer = __songProgressTimer;
@synthesize spotify = __spotify;
@synthesize albumArtImage = _albumArtImage;
@synthesize iTunes = __iTunes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
      [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfoFromNote:) name:kiTunesBundlePlayerInfoKey object:nil];
      [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfoFromNote:) name:kSpotifyBundlePlayerInfoKey object:nil];
      self.iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
      self.spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    }  
    return self;
}

- (void)loadView {
  [super loadView];
  [self updateTrackInfoFromDictionary:[self currentlyPlayingSongDictionary]];
  [self.albumArtImage setImage:[self getAlbumArtwork]];
}

#pragma mark - Update Track Information
- (void)updateTrackInfoFromNote:(NSNotification *)note {
  [self updateTrackInfoFromDictionary:[note userInfo]];
  double maxValue = 0.0;
  if ([note.name isEqualToString:kiTunesBundlePlayerInfoKey]) {
    int totalTime = [(NSNumber *)[[note userInfo] objectForKey:kiTunesSongTotalTime] intValue];
    maxValue = (totalTime / 1000) * kPercentagePlayedNeeded;
  } else {
    int totalTime = [(NSNumber *)[[note userInfo] objectForKey:kSpotifySongTotalTime] intValue];
    maxValue = totalTime * kPercentagePlayedNeeded;
  }
  [self resetAndStartProgressUpdateTimerWithMax:maxValue andSong:[note userInfo]];
  [self.albumArtImage setImage:[self getAlbumArtwork]];
}

- (void)updateTrackInfoFromDictionary:(NSDictionary *)songDictionary {
  NSFont *boldSmallFont = [NSFont boldSystemFontOfSize:13.0f];
  
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *tmp = [[[NSAttributedString alloc] initWithString:[songDictionary objectForKey:kArtistKey] attributes:[NSDictionary dictionaryWithObject:boldSmallFont forKey:NSFontAttributeName]] autorelease];
  [str appendAttributedString:tmp];
  
  NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
  
  NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:self.artistAlbumTextField.font, NSFontAttributeName, pStyle, NSParagraphStyleAttributeName, nil];  
  [pStyle release];
  
  tmp = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@",[songDictionary objectForKey:kAlbumKey]] attributes:attribs] autorelease];
  [str appendAttributedString:tmp];
  
  [self.artistAlbumTextField setAttributedStringValue:str];
  [str release];
  
  [self.songTitleField setStringValue:[songDictionary objectForKey:kSongKey]];
}

#pragma mark - Actions
- (void)resetAndStartProgressUpdateTimerWithMax:(double)max andSong:(NSDictionary *)song {
  [self.albumArtImage.progressIndicator setDoubleValue:0];
  [self.albumArtImage.progressIndicator setMaxValue:round(max)];
  [self.songProgressTimer invalidate];
  self.songProgressTimer = nil;
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:song, kCurrentSongKey, [NSNumber numberWithDouble:round(max)], kMaxValueKey, nil];
  self.songProgressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgress:) userInfo:dictionary repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:self.songProgressTimer forMode:NSEventTrackingRunLoopMode];
}

- (void)updateProgress:(NSTimer *)timer {
  static double counter;
  counter += 1;
  
  NSNumber *maxValue = [[timer userInfo] valueForKey:kMaxValueKey];
  NSDictionary *song = [[timer userInfo] valueForKey:kCurrentSongKey];
  
  [self.albumArtImage.progressIndicator incrementBy:1.0];
  if ([maxValue doubleValue] == counter) {
    [[FileOperationManager sharedManager] writeSongToLog:song];
    [timer invalidate];
    counter = 0;
  }
}

- (NSImage *)getAlbumArtwork {
  NSImage *returnImage = nil;
  if ([self.iTunes isRunning] && self.iTunes.playerState == iTunesEPlSPlaying) {
    SBElementArray *art = [[self.iTunes currentTrack] artworks];
    if ([art count] >= 1) {
      iTunesArtwork *artwork = [art objectAtIndex:0];
      returnImage = artwork.data;
    }
  } else if ([self.spotify isRunning] && self.spotify.playerState == SpotifyEPlSPlaying) {
    if ([[self.spotify currentTrack] artwork]) {
      returnImage = [[self.spotify currentTrack] artwork];
    }
  }
  return (returnImage && [returnImage isKindOfClass:[NSImage class]]) ? returnImage : [NSImage imageNamed:@"record"];
}

- (NSDictionary *)currentlyPlayingSongDictionary {
  NSMutableDictionary *songDict = [NSMutableDictionary dictionaryWithCapacity:3];
  if ([self.iTunes isRunning] && self.iTunes.playerState == iTunesEPlSPlaying) {
    iTunesTrack *track = [self.iTunes currentTrack];
    [songDict setValue:track.artist forKey:kArtistKey];
    [songDict setValue:track.album forKey:kAlbumKey];
    [songDict setValue:track.name forKey:kSongKey];
  } else if ([self.spotify isRunning] && self.spotify.playerState == SpotifyEPlSPlaying) {
    SpotifyTrack *track = [self.spotify currentTrack];
    [songDict setValue:track.artist forKey:kArtistKey];
    [songDict setValue:track.album forKey:kAlbumKey];
    [songDict setValue:track.name forKey:kSongKey];
  }
  return songDict;
}

- (void)dealloc {
  [__iTunes release];
  [__spotify release];
  [__songTitleField release];
  [__songProgressTimer release];
  [__artistAlbumTextField release];
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:kiTunesBundlePlayerInfoKey object:nil];
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:kSpotifyBundlePlayerInfoKey object:nil];
  [super dealloc];
}

@end
