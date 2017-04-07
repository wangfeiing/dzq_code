//
//  sscore_graphics_mac+ios.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_graphics_mac_h
#define SeeScoreLib_sscore_graphics_mac_h

#include "sscore_graphics.h"
#include <CoreGraphics/CoreGraphics.h>

#ifdef __cplusplus
extern "C" {
#endif
	
	/*! @header
	 The C interface to creation of the sscore_graphics for OS X and iOS
	 */

	/*!
	 @function sscore_graphics_create
	 @abstract create a platform-independent wrapper around the OS graphics context
	 @discussion must call sscore_graphics_dispose when complete
	 @return a platform independent sscore_graphics wrapper around the platform graphics context
	 obtained in a UI draw call
	 */
	sscore_graphics *sscore_graphics_create(CGContextRef ctx);

	/*!
	 @function sscore_graphics_native_context
	 @abstract access the platform graphics context
	 @param graph the graphics context returned from sscore_graphics_create...
	 @return the iOS or OS X CGContextRef
	 */
	CGContextRef sscore_graphics_native_context(const sscore_graphics *graph);

#ifdef __cplusplus
}
#endif

#endif
