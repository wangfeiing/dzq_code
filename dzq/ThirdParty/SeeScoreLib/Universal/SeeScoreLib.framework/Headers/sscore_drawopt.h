//
//  sscore_drawopt.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_drawopt_h
#define SeeScoreLib_sscore_drawopt_h

#include "sscore.h"

#ifdef __cplusplus
extern "C" {
#else
#include <stdbool.h>
#endif
	
#if WIN32
#define EXPORT	__declspec( dllexport )
#else
#define EXPORT
#endif

/*! @header
 The C interface to drawing the score with special options
 NB LICENCING:
 All functions here require a licence as specified
 */

#define sscore_kMaxRenderItems 256
	
/*! sscore_dopt_colour_render_flags_e
	@abstract flags to define which items or parts of item are coloured in sscore_system_draw_opt
 */
enum sscore_dopt_colour_render_flags_e
{
	sscore_dopt_colour_notehead	= 0x1,
	sscore_dopt_colour_stem		= 0x2,
	sscore_dopt_colour_beam		= 0x4,
	sscore_dopt_colour_accidental = 0x8,
	sscore_dopt_colour_dot		= 0x10,
	sscore_dopt_colour_rest		= 0x20,
	sscore_dopt_colour_notation	= 0x40,
	sscore_dopt_colour_lyric	= 0x80,
	sscore_dopt_colour_ledger	= 0x100,
	sscore_dopt_colour_clef		= 0x200,
	sscore_dopt_colour_timesig	= 0x400,
	sscore_dopt_colour_keysig	= 0x800,
	sscore_dopt_colour_direction_text = 0x1000,
	sscore_dopt_colour_harmony	= 0x2000,
	sscore_dopt_colour_all		= 0xFFFFFFFF
};

/*! sscore_dopt_flags_e
 @abstract generic flags to use in sscore_drawoptions.flags
 */
enum sscore_dopt_flags_e
{
	sscore_dopt_showbezierhandles = 0x1
};
	
/*! sscore_drawoptions
	@abstract define special options for rendering individual score items (note/clef/timesig/keysig) in a system.
	Used in sscore_dopt_system_draw
 */
typedef struct sscore_drawoptions
{
	int num_render_items;
	struct
	{
		sscore_item_handle item_h;	// define the item for special rendering
		sscore_colour_alpha colour;	// the colour to render this item
		unsigned coloured_render;	// set of flags defining parts of item to colour
		unsigned dummy[6]; // for future. Set to zero
	} render_items[sscore_kMaxRenderItems];
	
	unsigned flags; // sscore_dopt_flags_e
	
	unsigned dummy[31]; // for future. Set to zero
} sscore_drawoptions;

/*!
 @function sscore_dopt_system_draw
 @abstract draw the system at the given point with options to render individual items with different colours
 @discussion licence item_colour_capable and contents_capable/contents_detail_capable are required to use this function
 @param graphics the graphics context returned from sscore_graphics_create
 @param sys the system to draw
 @param tl the top left point of the system rectangle
 @param magnification the scale to draw it at
 @param opt options to draw with
 @param key the licence key which needs item_colour_capable licence
 @return any error
 */
EXPORT enum sscore_error sscore_dopt_system_draw(sscore_graphics *graphics,
												const sscore_system *sys,
												const sscore_point *tl, float magnification,
												const sscore_drawoptions *opt,
												const sscore_libkeytype *key);

#ifdef __cplusplus
}
#endif

#endif
