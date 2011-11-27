//
//  main.m
//  git-tunes
//
//  Created by Brian Michel on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileOperationManager.h"
#import "GGGitTool.h"

#define kAppName @"GitTunes"

#define kInitArgument @"init"
#define kCommitArgument @"commit"
#define kPurgeArgument @"purge"

static void init();
static void purge();
static void usage();
static void commit();

int main (int argc, const char * argv[])
{
  @autoreleasepool {
    if (argc >= 2) {
      NSString *arg = [NSString stringWithUTF8String:argv[1]];
      if ([arg isEqualToString:kInitArgument]) {
        init();
      } else if ([arg isEqualToString:kCommitArgument]) {
        commit();
      } else if ([arg isEqualToString:kPurgeArgument]) {
        purge();
      } else {
        usage();
      }
    } else {
      usage();
    }
  }
  return 0;
}

void init()
{
  purge();
}

void commit()
{
  NSLog(@"About to commit");
  NSArray *entries = [[FileOperationManager sharedManager] readSongsAndPurge:NO forName:kAppName];
  
  NSLog(@"Number of entries: %i", [entries count]);
  for (NSString *entry in entries) {
    NSLog(@"%@", entry);
  }
  
  GGGitTool *git = [GGGitTool sharedGitTool];
  [git gitCommand:[NSArray arrayWithObjects:@"notes", @"add", @"-f", @"-F",[[FileOperationManager sharedManager] songsFileForName:kAppName],nil]];
  purge();
  NSLog(@"Finished commit");
}

void purge()
{
  BOOL success = [[FileOperationManager sharedManager] purgeSongsFileForName:kAppName];
  NSLog(@"You have %@ purged your song list.", success ? @"successfully" : @"unsuccessfully");
}

void usage()
{
  printf("usage: git-tunes [init|commit|purge]\n");
  printf("\tinit: start the process of collecting musical information.\n");
  printf("\tcommit: finalize the process of collecting musical information (this does a purge).\n");
  printf("\tpurge: start over with the process of collecting musical information.\n");
}

