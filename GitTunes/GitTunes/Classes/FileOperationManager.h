//
//  FileOperationManager.h
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOperationManager : NSObject

+ (FileOperationManager *)sharedManager;
- (BOOL)writeSongToLog:(NSDictionary *)dictionary;
- (NSArray *)readSongsAndPurge:(BOOL)purge;
- (NSArray *)readSongsAndPurge:(BOOL)purge forName:(NSString *)name;
- (BOOL)purgeSongsFile;
- (BOOL)purgeSongsFileForName:(NSString *)name;
- (NSString *)songsFile;
- (NSString *)songsFileForName:(NSString *)name;
@end
