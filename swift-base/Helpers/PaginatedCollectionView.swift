//
//  PaginatedCollectionView.swift
//  promptchal
//
//  Created by German Lopez on 3/22/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

protocol PaginatedCollectionViewDelegate {
  
  // Required - Should not call this method directly or you will need to take care of
  // page update and flags status. Call loadContentIfNeeded instead
  func loadDataForPage(page: Int, completion: (elementsAdded: Int, error: NSError?) -> Void)
}

class PaginatedCollectionView: UICollectionView {
  
  var currentPage: Int = 1
  var isLoading: Bool = false
  
  //  This will be handled automatically taking into account newElements of updateDelegate completion
  //  call and elementsPerPage. If your uploadDelegate provides pagination data, you can take control
  //  over this flag to avoid unnecesary calls to your delegate.
  var hasMore: Bool = true
  var elementsPerPage: Int = 10
  
  // Responsible for loading the content and call the completion with newElements count.
  var updateDelegate: PaginatedCollectionViewDelegate!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }
  
  func loadContentIfNeeded() {
    guard hasMore && !isLoading else {
      return
    }
    isLoading = true
    updateDelegate.loadDataForPage(currentPage, completion: { (newElements, error) -> Void in
      self.isLoading = false
      guard error == nil else {
        return
      }
      self.currentPage += 1
      self.hasMore = newElements == self.elementsPerPage
    })
  }
  
  func reset() {
    currentPage = 1
    hasMore = true
    isLoading = false
  }
  
  
  //MARK: Normal Scroll
  func didScrollBeyondTop() -> Bool {
    return contentOffset.y < 0
  }
  
  func didScrollBeyondBottom() -> Bool {
    return contentOffset.y >= (contentSize.height - bounds.size.height)
  }
  
  func didScrollBeyondLeft() -> Bool {
    return contentOffset.x < 0
  }
  
  func didScrollBeyondRight() -> Bool {
    return contentOffset.x >= (contentSize.width - bounds.size.width)
  }
  
  //MARK: Paged Scroll
  func didReachLastVerticalPage() -> Bool {
    return contentOffset.y >= (contentSize.height/frame.size.height - 1)*frame.size.height
  }
  
  func didReachLastHorizontalPage() -> Bool {
    return contentOffset.x >= (contentSize.width/frame.size.width - 1)*frame.size.width
  }
  
}

extension PaginatedCollectionView : UIScrollViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
      if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
        let direction = layout.scrollDirection
        if direction == .Vertical {
          if pagingEnabled {
            if didReachLastVerticalPage() {
              loadContentIfNeeded()
            }
          }else {
            if didScrollBeyondTop() {
              return
            }else if didScrollBeyondBottom() {
              loadContentIfNeeded()
            }
          }
        }else {
          if pagingEnabled {
            if didReachLastHorizontalPage() {
              loadContentIfNeeded()
            }
          }else {
            if didScrollBeyondLeft() {
              return
            }else if didScrollBeyondRight() {
              loadContentIfNeeded()
            }
          }
        }
      }
    }
}
