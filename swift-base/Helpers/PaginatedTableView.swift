//
//  PaginatedTableView.swift
//  promptchal
//
//  Created by German Lopez on 3/22/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

protocol PaginatedTableViewDelegate: class {
  // Required - Should not call this method directly or you will need to take care of
  // page update and flags status. Call loadContentIfNeeded instead
  func loadData(page: Int, completion: (_ elementsAdded: Int, _ error: NSError?) -> Void)
}

enum PagingDirectionType: Int {
  case atBottom
  case atTop
}

class PaginatedTableView: UITableView {

  var currentPage = 1
  var isLoading = false
  //  This will be handled automatically taking into account newElements of updateDelegate completion
  //  call and elementsPerPage. If your uploadDelegate provides pagination data, you can take control
  //  over this flag to avoid unnecesary calls to your delegate.
  var hasMore = true
  var elementsPerPage = 10
  // Responsible for loading the content and call the completion with newElements count.
  weak var updateDelegate: PaginatedTableViewDelegate!
  // Tells when pagination calls occurs. Options are when the tableView reaches bottom(.AtBottom) or top(.AtTop)
  var direction: PagingDirectionType = .atBottom
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func loadContentIfNeeded() {
    guard hasMore && !isLoading else {
      return
    }
    isLoading = true
    updateDelegate.loadData(page: currentPage, completion: { (newElements, error) -> Void in
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
  
  func didScrollBeyondTop() -> Bool {
    return contentOffset.y < 0
  }
  
  func didScrollBeyondBottom() -> Bool {
    return contentOffset.y >= (contentSize.height - bounds.size.height)
  }
}

extension PaginatedTableView : UIScrollViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if direction == .atBottom {
      if didScrollBeyondTop() {
        return
      } else if didScrollBeyondBottom() {
        loadContentIfNeeded()
      }
    } else {
      if didScrollBeyondTop() {
        loadContentIfNeeded()
      }
    }
  }
  
}
