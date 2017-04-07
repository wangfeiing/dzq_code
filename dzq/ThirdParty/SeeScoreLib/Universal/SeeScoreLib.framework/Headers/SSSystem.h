//
//  SSSystem.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_mac_SSSystem_h
#define SeeScoreLib_mac_SSSystem_h

#import <CoreGraphics/CoreGraphics.h>

#include "sscore.h"
#include "sscore_contents.h"

@class SSScore;

/*!
 @header SSystem.h
 @abstract interface to a SeeScore System (ie a sequence of bars of page width)
 */

/*!
 @struct SSCursorRect
 @abstract information required for drawing a bar cursor returned from getCursorRect
 */
typedef struct
{
	/*!
	 true if the required bar is in the system
	 */
	bool bar_in_system;
	
	/*!
	 the outline of the bar in the system (if bar_in_system = true)
	 */
	CGRect rect;
} SSCursorRect;


/*!
 @interface SSComponent
 @abstract information about a component returned from hitTest and componentsForItem
 */
@interface SSComponent : NSObject

/*!
 @property type
 @abstract the type of component
 */
@property enum sscore_component_type_e type;

/*!
 @property partIndex
 @abstract the 0-based index of the part containing this
 */
@property int partIndex;

/*!
 @property barIndex
 @abstract the 0-based index of the bar containing this
 */
@property int barIndex;

/*!
 @property rect
 @abstract the minimum rectangle around this item in the layout
 */
@property CGRect rect;

/*!
 @property layout_h
 @abstract the unique identifier for the atomic drawn element in the layout (notehead,stem,accidental,rest etc)
 */
@property sscore_layout_handle layout_h;

/*!
 @property item_h
 @abstract the unique identifier for the parent item in the score (note,rest,clef,time signature etc)
 */
@property sscore_item_handle item_h;

@end


/*!
 @interface SSColouredItem
 @abstract define colouring of an object in drawWithContext: at: magnification: colourRender:
 */
@interface SSColouredItem : NSObject

/*!
 @property item_h
 @abstract unique identifier of the item to colour
 */
@property sscore_item_handle item_h;

/*!
 @property colour
 @abstract the colour to use
 */
@property CGColorRef colour;

/*!
 @property coloured_render
 @abstract use sscore_dopt_colour_render_flags_e to define exactly what part of an item should be coloured
 */
@property unsigned coloured_render;

/*!
 @method initWithItem:
 @abstract initialise SSColouredItem
 @param item_h unique identifier of the item to colour
 @param colour the colour to use
 @param coloured_render use sscore_dopt_colour_render_flags_e to define exactly what part of an item should be coloured
 */
-(instancetype)initWithItem:(sscore_item_handle)item_h colour:(CGColorRef)colour render:(unsigned)coloured_render;
@end


/*!
 @interface SSColourRender
 @abstract define colouring of objects in drawWithContext: at: magnification: colourRender:
 */
@interface SSColourRender : NSObject

/*!
 @property flags
 @abstract normally 0 (sscore_dopt_flags_e)
 */
@property unsigned flags;
 
/*!
 @property colouredItems
 @abstract array of SSColouredItem
 */
@property NSArray *colouredItems;

/*!
 @method initWithItems:
 @abstract initialise SSColourRender
 @param items array of SSColouredItem
 */
-(instancetype)initWithItems:(NSArray*)items;

/*!
 @method initWithFlags:
 @abstract unused at present
 */
-(instancetype)initWithFlags:(unsigned)flags items:(NSArray*)items;
@end


/*!
 @interface SSSystem
 @abstract interface to a SeeScore System
 @discussion A System is a range of bars able to draw itself in a CGContextRef, and is a product of calling SScore layoutXXX:
 <p>
 drawWithContext draws the system into a CGContextRef, the call with colourRender argument allowing item colouring (and requiring an additional licence)
 <p>
 partIndexForYPos, barIndexForXPos can be used to locate the bar and part under the cursor/finger
 <p>
 hitTest is used to find the exact layout components (eg notehead, stem, beam) at a particular location (requiring a contents licence)
 <p>
 componentsForItem is used to find all the layout components of a particular score item (requiring a contents licence)
 */
@interface SSSystem : NSObject

/*!
 @property index
 @abstract the index of this system from the top of the score. Index 0 is the topmost.
 */
@property (nonatomic,readonly) int index;

/*!
 @property barRange
 @abstract the start bar index and number of bars for this system.
 */
@property (nonatomic,readonly) sscore_barrange barRange;

/*!
 @property defaultSpacing
 @abstract a default value for vertical system spacing
 */
@property (nonatomic,readonly) float defaultSpacing;

/*!
 @property bounds
 @abstract the bounding box of this system.
 */
@property (nonatomic,readonly) CGSize bounds;

/*!
 @method includesBar:
 @abstract does this system include the bar?
 @return true if this system includes the bar with given index
 */
-(bool)includesBar:(int)barIndex;

/*!
 @method includesBarRange:
 @abstract does this system include the bar range?
 @return true if this system includes any bars in barrange
 */
-(bool)includesBarRange:(const sscore_barrange*)barrange;

/*!
 @method drawWithContext:
 @abstract draw this system at the given point.
 @param ctx the CGContextRef to draw into
 @param tl the coordinate at which to place the top left of the system
 @param magnification the scale to draw at. NB This is normally 1, except during active zooming.
 The overall magnification is set in sscore_layout
 */
-(void)drawWithContext:(CGContextRef)ctx
					at:(CGPoint)tl
		 magnification:(float)magnification;

/*!
 @method drawWithContext:
 @abstract draw this system at the given point allowing optional colouring of particular items/components in the layout.
 @param ctx the CGContextRef to draw into
 @param tl the coordinate at which to place the top left of the system
 @param magnification the scale to draw at. NB This is normally 1, except during active zooming.
 The overall magnification is set in sscore_layout
 @param colourRender each SSRenderItem object in the array defines special colouring of a particular score item
 */
-(enum sscore_error)drawWithContext:(CGContextRef)ctx
								 at:(CGPoint)tl
					  magnification:(float)magnification
					   colourRender:(SSColourRender*)colourRender;

/*!
 @method printTo:
 @abstract draw this system at the given point with optimisation for printing (ie without special pixel alignment).
 @param ctx the CGContextRef to draw into
 @param tl the coordinate at which to place the top left of the system
 @param magnification (normally 1.0) the scale to draw at.
 */
-(void)printTo:(CGContextRef)ctx
			at:(CGPoint)tl
 magnification:(float)magnification;

/*!
 @method cursorRectForBar:context:
 @abstract get the cursor rectangle for a particular system and bar
 @param barIndex the index of the bar in the system
 @param ctx a graphics context only for text measurement eg a bitmap context
 @return the bar rectangle which can be used for a cursor
 */
-(SSCursorRect)cursorRectForBar:(int)barIndex context:(CGContextRef)ctx;

/*!
 @method partIndexForYPos:
 @abstract get the part index of the part enclosing the given y coordinate in this system
 @param ypos the y coord
 @return the 0-based part index
 */
-(int)partIndexForYPos:(float)ypos;

/*!
 @method barIndexForXPos:
 @abstract get the bar index of the bar enclosing the given x coordinate in this system
 @param xpos the x coord
 @return the 0-based bar index
 */
-(int)barIndexForXPos:(float) xpos;

/*!
 @method hitTest:
 @abstract get an array of components which intersect a given a point in this system
 @discussion a contents licence is required
 @param p the point
 @return array of intersecting SSComponent - empty if unlicensed
 */
-(NSArray *)hitTest:(CGPoint)p;

/*!
 @method componentsForItem:
 @abstract get an array of layout components which belong to a particular score item in this system
 @discussion a contents licence is required
 @param item_h the unique identifier for an item (eg note) in the score
 @return array of SSComponent - empty if unlicensed
 */
-(NSArray*)componentsForItem:(sscore_item_handle)item_h;

/*!
 @method boundsForItem:
 @abstract get a bounding box which encloses all layout components for a score item in this system
 @discussion a contents licence is required
 @param item_h
 @return the bounds of (all components of) the item - empty if not licensed
 */
-(CGRect)boundsForItem:(sscore_item_handle)item_h;

// internal use only
@property sscore_libkeytype *key;

// internal use only
-(instancetype)initWithSystem:(sscore_system*)sy score:(SSScore*)sc;

@end

#endif
