//
//  AlbumArtProgressView.h
//  GitTunes
//
//  Created by Brian Michel on 11/27/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AlbumArtProgressView : NSView

@property (nonatomic, retain) NSImageView *albumArt;
@property (nonatomic, retain) NSProgressIndicator *progressIndicator;

- (void)setImage:(NSImage *)image;

@end
