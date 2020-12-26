//
//  PaginationScrollMetricsMutator.swift
//  HorizonCalendar
//
//  Created by Bryan Keller on 12/22/20.
//  Copyright © 2020 Airbnb. All rights reserved.
//

import CoreGraphics

final class PaginationHelper {
  
  // MARK: Lifecycle
  
  init(initialValidOffset: CGFloat) {
    lastOffset = initialValidOffset
  }
  
  // MARK: Internal
  
  func nextPageOffset(
    forTargetOffset targetOffset: CGFloat,
    originalOffset: CGFloat,
    velocity: CGFloat,
    paginationConfiguration: HorizontalMonthsLayoutOptions.PaginationBehavior.Configuration,
    monthWidth: CGFloat,
    interMonthSpacing: CGFloat,
    boundsWidth: CGFloat)
    -> CGFloat
  {
    let pageSize: CGFloat
    switch paginationConfiguration.restingPosition {
    case .leadingMonthEdge: pageSize = monthWidth + interMonthSpacing
    case .boundsWidth: pageSize = boundsWidth
    }
    
    let finalOffset: CGFloat
    switch paginationConfiguration.restingAffinity {
    case .atPositionsAdjacentToPrevious:
      finalOffset = targetOffset
//      if velocity > 0 {
//        finalOffset = lastPageOffset + pageSize
//      } else if velocity < 0 {
//        finalOffset = lastPageOffset - pageSize
//      } else {
//        finalOffset = lastPageOffset + pageSize
//      }
      
    case .atPositionsClosestToTargetOffset:
      let offsetDelta = targetOffset - originalOffset
      finalOffset = lastOffset + (round(offsetDelta / pageSize) * pageSize)
    }

    print("LO: \(lastOffset) -> FO: \(finalOffset)")

    lastOffset = finalOffset
    
    return finalOffset
  }
  
  func didLoopScrollPosition(by offset: CGFloat, isDecelerating: Bool) {
    loopOffsetTotal += offset
    
    if isDecelerating {
      lastOffset += loopOffsetTotal
      loopOffsetTotal = 0
    }
  }
  
  // MARK: Private
  
  private var lastOffset: CGFloat
  private var loopOffsetTotal = CGFloat(0)
  
}
