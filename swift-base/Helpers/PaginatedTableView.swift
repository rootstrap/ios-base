//
//  PaginatedTableView.swift
//  promptchal
//
//  Created by German Lopez on 3/22/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation

protocol PaginatedTableViewDelegate {
  
  // Required - Should not call this method directly or you will need to take care of
  // page update and flags status. Call loadContentIfNeeded instead
  func loadDataForPage(page: Int, completion: (elementsAdded: Int) -> Void)
}

enum PagingDirectionType: Int {
  case AtBottom
  case AtTop
}

class PaginatedTableView: UITableView {
  
  var currentPage: Int = 1
  var isLoading: Bool = false
  
  //  This will be handled automatically taking into account newElements of updateDelegate completion
  //  call and elementsPerPage. If your uploadDelegate provides pagination data, you can take control
  //  over this flag to avoid unnecesary calls to your delegate.
  var hasMore: Bool = true
  var elementsPerPage: Int = 10
  
  // Responsible for loading the content and call the completion with newElements count.
  var updateDelegate: PaginatedTableViewDelegate!
  
  // Tells when pagination calls occurs. Options are when the tableView reaches bottom(.AtBottom) or top(.AtTop)
  var direction: PagingDirectionType! = .AtBottom
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
  }
  
  func loadContentIfNeeded() {
    if hasMore && !isLoading {
      isLoading = true
      updateDelegate.loadDataForPage(currentPage, completion: { (newElements) -> Void in
        self.currentPage++
        self.hasMore = newElements == self.elementsPerPage
        self.isLoading = false
      })
    }
  }
  
  func reset() {
    currentPage = 1
    hasMore = true
  }
}

extension PaginatedTableView : UIScrollViewDelegate {

  func scrollViewDidScroll(scrollView: UIScrollView) {
    if direction == .AtBottom {
      if scrollView.contentOffset.y < 0 {
        return
      }else if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height) {
        loadContentIfNeeded()
      }
    }else {
      if scrollView.contentOffset.y < 0 {
        loadContentIfNeeded()
      }
    }
  }
  
}
