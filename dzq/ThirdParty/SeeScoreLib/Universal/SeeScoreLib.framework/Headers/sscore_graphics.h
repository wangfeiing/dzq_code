//
//  sscore_graphics.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_graphics_h
#define SeeScoreLib_sscore_graphics_h

#ifdef WIN32
#define EXPORT	__declspec( dllexport )
#else
#define EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif
	
	/*! @header
	 The C interface to the platform-independent wrapper around the platform graphics object
	 */
	
	/*!
	 @class sscore_graphics
	 @abstract a platform-independent wrapper around the OS graphics context
	 */
	typedef struct sscore_graphics sscore_graphics;

	/*!
	 @function sscore_graphics_dispose
	 @abstract dispose the graphics returned from sscore_graphics_create..
	 @param g graphics returned from sscore_graphics_create..
	 */
	EXPORT void sscore_graphics_dispose(sscore_graphics *g);

#ifdef __cplusplus
}
#endif


#endif
