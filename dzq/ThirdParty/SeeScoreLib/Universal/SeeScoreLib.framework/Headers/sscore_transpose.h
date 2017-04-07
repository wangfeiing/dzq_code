//
//  sscore_transpose.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_transpose_h
#define SeeScoreLib_sscore_transpose_h

#include "sscore.h"

#ifdef __cplusplus
extern "C" {
#endif
	
/*! @header
	 The C interface to transpose the score
	 NB LICENCING:
	 All functions here require the transpose_capable licence
*/

#define sscore_tr_kMaxPartStaffClefChange 64
#define sscore_tr_kAllPartsPartIndex -1 // special value for partindex
#define sscore_tr_kAllStaffsStaffIndex -1 // special value for staffindex

/*!
 @enum sscore_tr_cleftype
 @abstract clef types which can be substituted
 */
enum sscore_tr_cleftype
{
	sscore_tr_trebleclef,		// G clef
	sscore_tr_treblesub8clef,	// G clef with 8 underneath
	sscore_tr_treblesuper8clef, // G clef with 8 on top
	sscore_tr_altoclef,			// C clef on middle line of staff
	sscore_tr_tenorclef,		// C clef on line above middle line of staff
	sscore_tr_bassclef,			// F clef
	sscore_tr_undefined
};
	
/*!
 @struct sscore_tr_clefconversion
 @abstract define a clef substitution
 */
typedef struct sscore_tr_clefconversion
{
	enum sscore_tr_cleftype fromclef;	// convert any clef of type fromclef..
	enum sscore_tr_cleftype toclef;		// .. into toclef
} sscore_tr_clefconversion;

/*!
 @struct sscore_tr_staffclefchange
 @abstract define a clef substitution for a part/staff
 */
typedef struct sscore_tr_staffclefchange
{
	int partindex; // use sscore_tr_kAllPartsPartIndex to apply to all parts
	int staffindex; // use sscore_tr_kAllStaffsStaffIndex to apply to all staves in part
	sscore_tr_clefconversion conv; // the required clef substitution
	unsigned dummy[8];
} sscore_tr_staffclefchange;

/*!
 @struct sscore_tr_clefchangedef
 @abstract define clef substitutions for any parts
 */
typedef struct sscore_tr_clefchangedef
{
	int num;
	sscore_tr_staffclefchange staffchange[sscore_tr_kMaxPartStaffClefChange];
	unsigned dummy[8];
} sscore_tr_clefchangedef;
	

/*!
 @function sscore_set_transpose
 @abstract set the current transpose
 @discussion this requires the transpose_capable licence
 @param sc the score from sscore_create
 @param semitones the number of semitones to transpose [-12..+12]. 0 is reset to normal pitch
 @return any error
 */
EXPORT enum sscore_error sscore_set_transpose(sscore *sc, int semitones);

/*!
 @function sscore_current_transpose
 @abstract get the current transpose value
 @discussion this requires the transpose_capable licence
 @param sc the score from sscore_create
 @return the number of semitones previously set in sscore_set_transpose
 */
EXPORT int sscore_current_transpose(sscore *sc);

/*!
 @function sscore_tr_setclefchange
 @abstract set the current clef change for each part/staff
 @discussion this requires the transpose_capable licence
 @param sc the score from sscore_create
 @param clefchange the clef change required
 @return any error
 */
EXPORT enum sscore_error sscore_tr_setclefchange(sscore *sc, const sscore_tr_clefchangedef *clefchange);

/*!
 @function sscore_tr_clearclefchange
 @abstract clear any current clef change for all parts
 @discussion this requires the transpose_capable licence
 @param sc the score from sscore_create
 */
EXPORT void sscore_tr_clearclefchange(sscore *sc);

#ifdef __cplusplus
}
#endif

#endif
