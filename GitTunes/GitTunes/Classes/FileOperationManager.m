//
//  FileOperationManager.m
//  GitTunes
//
//  Created by Brian Michel on 11/26/11.
//  Copyright (c) 2011 Foureyes.me. All rights reserved.
//

#import "FileOperationManager.h"
#import "NSFileManager+DirectoryLocations.h"

#define kSongsFileName @"Songs.sngz"

@implementation FileOperationManager

+ (FileOperationManager *)sharedManager {
  static dispatch_once_t once;
  static FileOperationManager *sharedManager;
  dispatch_once(&once, ^{sharedManager = [[self alloc] init];});
  return sharedManager;
}

- (BOOL)writeSongToLog:(NSDictionary *)dictionary {
  NSArray *stringsToJoin = [NSArray arrayWithObjects:[dictionary objectForKey:@"Artist"], [dictionary objectForKey:@"Album"], [dictionary objectForKey:@"Name"], nil];
  
  NSString *message = [NSString stringWithFormat:@"%f|%@\n", [[NSDate date] timeIntervalSince1970], [stringsToJoin componentsJoinedByString:@"|"]];
  NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
  NSString *sngzFilePath = [NSString stringWithFormat:@"%@/%@", appSupportPath, kSongsFileName];
  if (![[NSFileManager defaultManager] fileExistsAtPath:sngzFilePath]) {
    [[NSFileManager defaultManager] createFileAtPath:sngzFilePath contents:nil attributes:nil];
  }
  
  NSFileHandle *output = [NSFileHandle fileHandleForWritingAtPath:sngzFilePath];
  [output seekToEndOfFile];
  [output writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
  [output synchronizeFile];
  return YES;
}

- (NSArray *)readSongsAndPurge:(BOOL)purge {
  NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
  NSString *sngzFilePath = [NSString stringWithFormat:@"%@/%@", appSupportPath, kSongsFileName];
  
  NSError *error = nil;
  NSString *fileString = [NSString stringWithContentsOfFile:sngzFilePath encoding:NSUTF8StringEncoding error:&error];
  if (purge) {
    [self purgeSongsFile];
  }
  return [fileString componentsSeparatedByString:@"\n"];
}

- (BOOL)purgeSongsFile {
  NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
  NSString *sngzFilePath = [NSString stringWithFormat:@"%@/%@", appSupportPath, kSongsFileName];
  NSError *error = nil;
  
  [[NSFileManager defaultManager] removeItemAtPath:sngzFilePath error:&error];
  return error ? NO : YES;
}

- (BOOL)purgeSongsFileForName:(NSString *)name {
  NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectoryForName:name];
  NSString *sngzFilePath = [NSString stringWithFormat:@"%@/%@", appSupportPath, kSongsFileName];
  NSError *error = nil;
  
  [[NSFileManager defaultManager] removeItemAtPath:sngzFilePath error:&error];
  return error ? NO : YES;
}

- (NSArray *)readSongsAndPurge:(BOOL)purge forName:(NSString *)name {
  NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectoryForName:name];
  NSString *sngzFilePath = [NSString stringWithFormat:@"%@/%@", appSupportPath, kSongsFileName];
  
  NSError *error = nil;
  NSString *fileString = [NSString stringWithContentsOfFile:sngzFilePath encoding:NSUTF8StringEncoding error:&error];
  if (purge) {
    [self purgeSongsFileForName:name];
  }
  return [fileString componentsSeparatedByString:@"\n"];
}

- (NSString *)songsFile {
  NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
  return [NSString stringWithFormat:@"%@/%@", appSupportPath, kSongsFileName];
}

- (NSString *)songsFileForName:(NSString *)name {
  NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectoryForName:name];
  return [NSString stringWithFormat:@"%@/%@", appSupportPath, kSongsFileName];
}

@end
