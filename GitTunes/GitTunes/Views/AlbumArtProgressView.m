//
//  AlbumArtProgressView.m
//  GitTunes
//
//  Created by Brian Michel on 11/27/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import "AlbumArtProgressView.h"

@interface AlbumArtProgressView (Private)
- (void)updateProgress:(NSTimer *)timer;
@end

@implementation AlbumArtProgressView

@synthesize albumArt = __albumArt;
@synthesize progressIndicator = __progressIndicator;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
      self.albumArt = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)] autorelease];
  
      self.progressIndicator = [[[NSProgressIndicator alloc] initWithFrame:NSInsetRect(frame, 15, 15)] autorelease];
      [self.progressIndicator setStyle:NSProgressIndicatorSpinningStyle];
      [self.progressIndicator setIndeterminate:NO];
      [self.progressIndicator setControlSize:NSMiniControlSize];
      [self.progressIndicator setControlTint:NSGraphiteControlTint];
      
      [self.progressIndicator setMinValue:0];
      [self.progressIndicator setMaxValue:100];
      self.progressIndicator.alphaValue = 0.0f;
      
      [self addSubview:self.albumArt];
      [self addSubview:self.progressIndicator];
      
      [self setWantsLayer:YES];
    }
    
    return self;
}

- (void)viewWillMoveToSuperview:(NSView *)newSuperview {
  NSTrackingArea *trackingArea = [[[NSTrackingArea alloc] initWithRect:newSuperview.frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingAssumeInside) owner:self userInfo:nil] autorelease];
  [self addTrackingArea:trackingArea];
}

- (void)viewDidMoveToSuperview {
  [self.progressIndicator setFrame:NSMakeRect(round(self.bounds.size.width/2 - self.progressIndicator.frame.size.width/2), round(self.bounds.size.height/2 - self.progressIndicator.frame.size.height/2), self.progressIndicator.frame.size.width, self.progressIndicator.frame.size.height)];
  [self.albumArt setFrame:self.bounds];
}

#pragma mark - Mouse Tracking
- (void)mouseEntered:(NSEvent *)theEvent {
  [[self.progressIndicator animator] setAlphaValue:1.0f];
  [[self.albumArt animator] setAlphaValue:0.1f];
}
- (void)mouseExited:(NSEvent *)theEvent {
  [[self.progressIndicator animator] setAlphaValue:0.0f];
  [[self.albumArt animator] setAlphaValue:1.0f];
}

#pragma mark - Setters
- (void)setImage:(NSImage *)image {
  [self.albumArt setImage:image];
}

#pragma mark - Action
- (void)updateProgress:(NSTimer *)timer {
  [self.progressIndicator incrementBy:1.0];
  [self.progressIndicator setNeedsDisplay:YES];
}

- (void)dealloc {
  [__albumArt release];
  [__progressIndicator release];
  [super dealloc];
}

@end
