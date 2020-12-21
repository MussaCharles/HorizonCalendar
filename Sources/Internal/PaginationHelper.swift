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
  
  init(minimumOffset: CGFloat) {
    self.minimumOffset = minimumOffset
    lastPageOffset = minimumOffset
  }
  
  // MARK: Internal
  
  func nextPageOffset(
    forTargetOffset targetOffset: CGFloat,
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
    
    let lastPageOffset: CGFloat
    if self.lastPageOffset > 20_000 {
      lastPageOffset = self.lastPageOffset - 10_000
    } else if self.lastPageOffset < 10_000 {
      lastPageOffset = self.lastPageOffset + 10_000
    } else {
      lastPageOffset = self.lastPageOffset
    }
    
    let finalOffset: CGFloat
    switch paginationConfiguration.restingAffinity {
    case .atPositionsAdjacentToPrevious:
      if velocity > 0 {
        finalOffset = lastPageOffset + pageSize
      } else if velocity < 0 {
        finalOffset = lastPageOffset - pageSize
      } else {
        finalOffset = lastPageOffset + pageSize
      }
      
    case .atPositionsClosestToTargetOffset:
      finalOffset = targetOffset
//      let normalizedOffset = targetOffset - minimumOffset
//      finalOffset = minimumContentOffset + (round(normalizedOffset / pageSize) * pageSize)
    }
    
    print(finalOffset)
    
    self.lastPageOffset = finalOffset
    
    return finalOffset
  }
  
  // MARK: Private
  
  private var minimumOffset: CGFloat
  private var lastPageOffset: CGFloat
  
}
