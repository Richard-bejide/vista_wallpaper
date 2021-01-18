//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<downloads_path_provider_28/DownloadsPathProviderPlugin.h>)
#import <downloads_path_provider_28/DownloadsPathProviderPlugin.h>
#else
@import downloads_path_provider_28;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [DownloadsPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"DownloadsPathProviderPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
