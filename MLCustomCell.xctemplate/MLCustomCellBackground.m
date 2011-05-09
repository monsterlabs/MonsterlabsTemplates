//
//  MLCustomCellBackground.m
//  TableDesignRevisited
//
//  Created by Matt Gallagher on 27/04/09.
//  Modified by Juan Germán Castañeda Echevarría on 2011/04/23
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import "MLCustomCellBackground.h"
#import "MLRoundRect.h"
#import <QuartzCore/QuartzCore.h>

CGGradientRef MLCustomCellBackgroundGradient(BOOL selected)
{
  static CGGradientRef backgroundGradient = NULL;
  static CGGradientRef selectedBackgroundGradient = NULL;

  if (!selected && !backgroundGradient ||
    selected && !selectedBackgroundGradient)
  {
    UIColor *contentColorTop;
    UIColor *contentColorBottom;
    if (selected)
    {
      contentColorTop = [UIColor colorWithRed:0.2 green:0.54 blue:0.98 alpha:1.0];
      contentColorBottom = [UIColor colorWithRed:0.0 green:0.34 blue:0.90 alpha:1.0];
    }
    else
    {
      contentColorTop = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
      contentColorBottom = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    }

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat backgroundColorComponents[2][4];
    memcpy(
      backgroundColorComponents[0],
      CGColorGetComponents(contentColorTop.CGColor),
      sizeof(CGFloat) * 4);
    memcpy(
      backgroundColorComponents[1],
      CGColorGetComponents(contentColorBottom.CGColor),
      sizeof(CGFloat) * 4);

    const CGFloat endpointLocations[2] = {0.0, 1.0};
    CGGradientRef gradient =
      CGGradientCreateWithColorComponents(
        colorspace,
        (const CGFloat *)backgroundColorComponents,
        endpointLocations,
        2);
    CFRelease(colorspace);

    if (selected)
    {
      selectedBackgroundGradient = gradient;
    }
    else
    {
      backgroundGradient = gradient;
    }
  }

  if (selected)
  {
    return selectedBackgroundGradient;
  }

  return backgroundGradient;
}

@implementation MLCustomCellBackground

@synthesize position;
@synthesize strokeColor;

//
// positionForIndexPath:inTableView:
//
// Parameters:
//    anIndexPath - the indexPath of a cell
//    aTableView; - the table view for the cell
//
// returns the MLCustomCellGroupPosition for the indexPath in the table view
//
+ (MLCustomCellGroupPosition)positionForIndexPath:(NSIndexPath *)anIndexPath
  inTableView:(UITableView *)aTableView;
{
  MLCustomCellGroupPosition result;

  if ([anIndexPath row] != 0)
  {
    result = MLCustomCellGroupPositionMiddle;
  }
  else
  {
    result = MLCustomCellGroupPositionTop;
  }

  id<UITableViewDataSource> tableViewController = [aTableView dataSource];
  if ([anIndexPath row] ==
    [tableViewController tableView:aTableView numberOfRowsInSection:anIndexPath.section] - 1)
  {
    if (result == MLCustomCellGroupPositionTop)
    {
      result = MLCustomCellGroupPositionTopAndBottom;
    }
    else
    {
      result = MLCustomCellGroupPositionBottom;
    }
  }
  return result;
}

//
// init
//
// Init method for the object.
//
- (id)initSelected:(BOOL)isSelected grouped:(BOOL)isGrouped
{
  self = [super init];
  if (self != nil)
  {
    selected = isSelected;
    groupBackground = isGrouped;
    self.strokeColor = [UIColor lightGrayColor];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  }
  return self;
}

//
// layoutSubviews
//
// On rotation/resize/rescale, we need to redraw.
//
- (void)layoutSubviews
{
  [super layoutSubviews];

  [self setNeedsDisplay];
}

//
// setPosition:
//
// Makes certain the view gets redisplayed when the position changes
//
// Parameters:
//    aPosition - the new position
//
- (void)setPosition:(MLCustomCellGroupPosition)aPosition
{
  if (position != aPosition)
  {
    position = aPosition;
    [self setNeedsDisplay];
  }
}

//
// drawRect:
//
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();

  const CGFloat MLCustomCellBackgroundRadius = 10.0;
  if (groupBackground)
  {
    if (position != MLCustomCellGroupPositionTop &&
      position != MLCustomCellGroupPositionTopAndBottom)
    {
      rect.origin.y -= MLCustomCellBackgroundRadius;
      rect.size.height += MLCustomCellBackgroundRadius;
    }

    if (position != MLCustomCellGroupPositionBottom && position != MLCustomCellGroupPositionTopAndBottom)
    {
      rect.size.height += MLCustomCellBackgroundRadius;
    }
  }

  rect = CGRectInset(rect, 0.5, 0.5);

  CGPathRef roundRectPath;

  if (groupBackground)
  {
    roundRectPath = NewPathWithRoundRect(rect, MLCustomCellBackgroundRadius);

    CGContextSaveGState(context);
    CGContextAddPath(context, roundRectPath);
    CGContextClip(context);
  }

  CGFloat visibleWidth = rect.size.width;
    CGFloat visibleHeight = rect.size.height;
  CGContextDrawLinearGradient(
    context,
    MLCustomCellBackgroundGradient(selected),
    CGPointMake(0.5 * visibleWidth, 0),
    CGPointMake(0.5 * visibleWidth, visibleHeight),
    0);

  if (groupBackground)
  {
    CGContextRestoreGState(context);

    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextAddPath(context, roundRectPath);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);

    CGPathRelease(roundRectPath);

    if (position != MLCustomCellGroupPositionTop && position != MLCustomCellGroupPositionTopAndBottom)
    {
      rect.origin.y += MLCustomCellBackgroundRadius;
      rect.size.height -= MLCustomCellBackgroundRadius;

      CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
      CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
      CGContextStrokePath(context);
    }
  }
  else
  {
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextStrokePath(context);
  }
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
  [strokeColor release];

  [super dealloc];
}

@end





