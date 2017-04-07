//
//  SSSystemView.h
//  SeeScore for iOS
//
// No warranty is made as to the suitability of this for any purpose
//
// This is used by SSScrollView and manages and draws a single system of music using the SeeScoreLib framework
//

#import <UIKit/UIKit.h>

#include <SeeScoreLib/SeeScoreLib.h>

//@class SSScore;
//@class SSSystem;
//@class SSColourRender;

/*!
 * @interface SSSystemView
 * @abstract used by SSScrollView, manages and draws a single system of music using the SeeScoreLib framework
 */
@interface SSSystemView : UIView

/*!
 * @property height
 * @abstract the height of this system view in CGContext units
 */
@property (nonatomic,readonly) float height;

/*!
 * @property locked
 * @abstract set while drawing in background
 */
@property (atomic) bool locked;

/*!
 * @property colourRender
 * @abstract any current colour rendering (used to define coloured items in the score)
 */
@property (nonatomic) SSColourRender *colourRender;

/*!
 * @property system
 * @abstract the SSSystem which this is displaying
 */
@property (nonatomic,readonly) SSSystem *system;

/*!
 * @property systemIndex
 * @abstract the index of the system that this is displaying - 0 is the top system
 */
@property (nonatomic, readonly) int systemIndex;

/*!
 * @method initWithBackgroundColour
 * @abstract initialise defining a background colour
 * @param bgcol the background colour
 * @return the SSSystemView
 */
- (instancetype)initWithBackgroundColour:(UIColor*)bgcol;

/*!
 * @method setSystem
 * @abstract setup with the system
 * @param system the system
 * @param score the score
 */
-(void)setSystem:(SSSystem*)system
		   score:(SSScore*)score;

/*!
 * @method clearColourRender
 * @abstract clear all coloured rendering
 */
-(void)clearColourRender;

/*!
 * @method clearColourRenderForBarRange:
 * @abstract clear any coloured rendering in the bar range
 * @param barrange the range of bars defined by a start index and number of bars
 */
-(void)clearColourRenderForBarRange:(const sscore_barrange*)barrange;

/*!
 * @method requestBackgroundDraw:
 * @abstract schedule a repaint of the backing image on a background thread and return immediately
 * @discussion we draw the system into an image on a background thread so that we only draw an image (quickly)
 * in the foreground thus ensuring scrolling is as smooth as possible. completion() is called on the main thread on completion
 * @param background_draw_queue the thread queue to handle the work
 * @param completion any completion function to be called when the work is finished
 */
-(void)requestBackgroundDraw:(dispatch_queue_t)background_draw_queue completion:(void (^)())completion;

/*!
 * @method showCursorAtBar
 * @abstract show the bar cursor at the given bar
 * @param barIndex the index of the bar
 * @param pre if true show a single vertical line cursor at the start of the bar, else a rectangle around the bar
 */
-(void)showCursorAtBar:(int)barIndex pre:(BOOL)pre;

/*!
 * @method showCursorAtXpos
 * @abstract show the vertical line cursor at the given xpos in the system
 * @param xpos the x position of the cursor within the system
 * @param barIndex the index of the bar which the cursor is to be displayed within
 */
-(void)showCursorAtXpos:(float)xpos barIndex:(int)barIndex;

/*!
 * @method hideCursor
 * @abstract hide the cursor
 */
-(void)hideCursor;

/*!
 * @method zoomUpdate
 * @abstract call for interactive zooming (magnifies backImage)
 * @param z the zoom magnification
 */
-(void)zoomUpdate:(float)z;

/*!
 * @method zoomComplete
 * @abstract finish interactive zooming - system is redrawn at new magnification
 */
-(void)zoomComplete;

@end
