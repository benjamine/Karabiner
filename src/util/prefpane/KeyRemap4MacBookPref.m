/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "KeyRemap4MacBookPref.h"
#import "Common.h"
#import "SysctlWrapper.h"

@implementation KeyRemap4MacBookPref

static NSString* sysctl_ctl = @"/Library/org.pqrs/KeyRemap4MacBook/bin/KeyRemap4MacBook_sysctl_ctl";
static NSString* launchUninstallerCommand = @"/Library/org.pqrs/KeyRemap4MacBook/extra/launchUninstaller.sh";

/* ---------------------------------------------------------------------- */
- (void) drawVersion
{
  NSString* version = [BUNDLEPREFIX(SysctlWrapper) getString:@"keyremap4macbook.version"];
  if (! version) {
    version = @"-.-.-";
  }
  [_versionText setStringValue:version];
}

/* ---------------------------------------------------------------------- */
- (void) setStatusBarState
{
  NSString* result = [BUNDLEPREFIX(Common) getExecResult:sysctl_ctl args:[NSArray arrayWithObjects:@"statusbar", nil]];
  if (! result) return;

  if ([result intValue] == 1) {
    [_checkbox_statusbar setState:NSOnState];
  } else {
    [_checkbox_statusbar setState:NSOffState];
  }
}

- (void) startStatusBar
{
  NSString* killall = @"/usr/bin/killall";
  NSArray* args = [NSArray arrayWithObjects:@"KeyRemap4MacBook_statusbar", nil];
  NSTask* task_killall = [NSTask launchedTaskWithLaunchPath:killall arguments:args];
  [task_killall waitUntilExit];

  NSString* app = @"/Library/org.pqrs/KeyRemap4MacBook/app/KeyRemap4MacBook_statusbar.app";
  [[NSWorkspace sharedWorkspace] launchApplication:app];
}

- (IBAction) toggleStatusBar:(id)sender
{
  [BUNDLEPREFIX(Common) getExecResult:sysctl_ctl args:[NSArray arrayWithObjects:@"toggle_statusbar", nil]];
  [self setStatusBarState];
  [self startStatusBar];
}

/* ---------------------------------------------------------------------- */
- (void) setCheckUpdateState
{
  NSString* result = [BUNDLEPREFIX(Common) getExecResult:sysctl_ctl args:[NSArray arrayWithObjects:@"checkupdate", nil]];
  if (! result) return;

  [_popup_checkupdate selectItemAtIndex:[result intValue]];
}

- (IBAction) changeCheckUpdate:(id)sender
{
  NSString* selectedIndex = [[[NSString alloc] initWithFormat:@"%d", [_popup_checkupdate indexOfSelectedItem]] autorelease];

  [BUNDLEPREFIX(Common) getExecResult:sysctl_ctl args:[NSArray arrayWithObjects:@"set_checkupdate", selectedIndex, nil]];
  [self setCheckUpdateState];
}

/* ---------------------------------------------------------------------- */
- (IBAction) launchUninstaller:(id)sender
{
  [BUNDLEPREFIX(Common) getExecResult:launchUninstallerCommand args:[NSArray arrayWithObjects:@"force", nil]];
}

- (IBAction) launchEventViewer:(id)sender
{
  [[NSWorkspace sharedWorkspace] launchApplication:@"/Library/org.pqrs/KeyRemap4MacBook/app/KeyDump.app"];
}

/* ---------------------------------------------------------------------- */
- (void) mainViewDidLoad
{
  [self drawVersion];
  [self setStatusBarState];
  [self setCheckUpdateState];
}

@end
