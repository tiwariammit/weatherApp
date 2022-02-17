//
//  TableView.swift
//  HighlightsNepal
//
//  Created by Amrit Tiwari on 4/30/18.
//  Copyright © 2018 tiwariammit@gmail.com. All rights reserved.
//

import Foundation
import UIKit


extension UITableView {
    
    enum AnimationDirection {
        case left
        case right
        case top
        case roll
        case LeftAndRight
        
    }
 

    var indexesOfVisibleSections: [Int] {
        // Note: We can't just use indexPathsForVisibleRows, since it won't return index paths for empty sections.
        var visibleSectionIndexes = [Int]()
        
        for i in 0..<numberOfSections {
            var headerRect: CGRect?
            // In plain style, the section headers are floating on the top, so the section header is visible if any part of the section's rect is still visible.
            // In grouped style, the section headers are not floating, so the section header is only visible if it's actualy rect is visible.
            if (self.style == .plain) {
                headerRect = rect(forSection: i)
            } else {
                headerRect = rectForHeader(inSection: i)
            }
            if headerRect != nil {
                // The "visible part" of the tableView is based on the content offset and the tableView's size.
                let visiblePartOfTableView: CGRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: bounds.size.width, height: bounds.size.height)
                if (visiblePartOfTableView.intersects(headerRect!)) {
                    visibleSectionIndexes.append(i)
                }
            }
        }
        return visibleSectionIndexes
    }
    
    var visibleSectionHeaders: [UITableViewHeaderFooterView] {
        var visibleSects = [UITableViewHeaderFooterView]()
        
            for sectionIndex in self.indexesOfVisibleSections {
                if let sectionHeader = self.headerView(forSection: sectionIndex) {
                    visibleSects.append(sectionHeader)
                }
            }
        return visibleSects
    }

    fileprivate func translate(_ view:UIView,toDirection from:AnimationDirection) {
        
        let tableView = self
        let tableHeight: CGFloat = tableView.bounds.size.height
        let tableWidth:CGFloat = tableView.bounds.size.width
        
        switch from{
        case .left:
            view.transform = CGAffineTransform(translationX: -2*tableWidth, y: 0)//-2*tableHeight)
        case .right:
            view.transform = CGAffineTransform(translationX: 2*tableWidth, y: 0)//-2*tableHeight)
        case .top:
            //cell.alpha = 0
            view.backgroundColor = .white
            view.transform = CGAffineTransform(translationX: 0, y: -2*tableHeight)
        case .roll:
            break
        case .LeftAndRight:
            break
        }
    }
    
    
    func reload(_ from:AnimationDirection = .top, animationType:UIView.AnimationOptions = UIView.AnimationOptions.layoutSubviews,withTableViewHidden hidden:Bool = false, andAnimationTime duration : TimeInterval = 0.5, usingSpringWithDamping damping : CGFloat = 0.8){
      
        let tableView = self
//        let tableHeight: CGFloat = tableView.bounds.size.height
//        let tableWidth:CGFloat = tableView.bounds.size.width
        
        UIView.transition(with: self,
                          duration:0,
                          options:animationType,
                          animations:{() -> Void in
                            
                            if hidden {
                                self.tableFooterView?.isHidden = hidden
                                self.tableFooterView?.alpha = hidden ? 0 : 1
                                self.tableHeaderView?.alpha = hidden ? 0 : 1
                            }
                            
                            self.reloadData()
        })  { completed in
            
            let cells = tableView.visibleCells
            
            guard cells.count > 0 else  {
                return
            }
            
            var origionalBgColors:[UIColor] = [UIColor]()
            
            for cell in cells  {
                
                origionalBgColors.append(cell.backgroundColor ?? .white)
                self.translate(cell, toDirection: from)
            }
            
            for header in self.visibleSectionHeaders{
                
                self.translate(header, toDirection: from)
            }
            
            var index = 0
            
            for i in 0...cells.count-1 {
                
                //for a in cells {
                let cell: UITableViewCell = cells[i]
                UIView.animate(withDuration: duration, delay: 0.05 * Double(index), usingSpringWithDamping:damping, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    //cell.alpha = 1
                    self.alpha = 1
                    if i == cells.count-1 {
                        tableView.isHidden = false
                    }
                    
                    cell.transform = CGAffineTransform(translationX: 0, y: 0);
                    
                }){(check) in
                    // self.indicator.stopAnimating()
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.backgroundColor = origionalBgColors[i]
                        
                        if hidden {
                            self.tableHeaderView?.isHidden = false
                            self.tableFooterView?.isHidden = false

                            self.tableFooterView?.alpha = 1
                            self.tableHeaderView?.alpha = 1
                        }
                    })
                }
                
                index += 1
            }

            let headerCount = self.visibleSectionHeaders.count
            guard headerCount > 0 else{
                return
            }
            for i in 0...headerCount-1 {
                
                //for a in cells {
                
                let headers = self.visibleSectionHeaders[i]
                UIView.animate(withDuration: duration, delay: 0.05 * Double(index), usingSpringWithDamping:damping, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    //cell.alpha = 1
                    self.alpha = 1
                    if i == self.visibleSectionHeaders.count-1 {
                        tableView.isHidden = false
                    }
                    
                    headers.transform = CGAffineTransform(translationX: 0, y: 0);
                    
                }){(check) in
                    // self.indicator.stopAnimating()
                    UIView.animate(withDuration: 0.3, animations: {
                        headers.backgroundColor = origionalBgColors[i]
                        
                        if hidden {
                            self.tableFooterView?.alpha = 1
                            self.tableFooterView?.isHidden = false
                        }
                    })
                }
                
                index += 1
            }
        }
    }
    
    
   
//
//    public func reloadData(effect: AnimationDirection) {
//        self.reloadData()
//
//        switch effect {
//        case .roll:
//            roll()
//            break
//        case .LeftAndRight:
//            leftAndRightMove()
//            break
//        }
//
//    }
//
//    private func roll() {
//        let cells = self.visibleCells
//
//        let tableViewHeight = self.bounds.height
//
//        for cell in cells {
//            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
//        }
//
//        var delayCounter = 0
//
//        for cell in cells {
//            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//            delayCounter += 1
//        }
//    }
//
//    private func leftAndRightMove() {
//        let cells = self.visibleCells
//
//        let tableViewWidth = self.bounds.width
//
//        var alternateFlag = false
//
//        for cell in cells {
//            cell.transform = CGAffineTransform(translationX: alternateFlag ? tableViewWidth : tableViewWidth * -1, y: 0)
//            alternateFlag = !alternateFlag
//        }
//
//        var delayCounter = 0
//
//        for cell in cells {
//            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//            delayCounter += 1
//        }
//    }

}



extension UITableView {
    
    public enum EffectEnum {
        case roll
        case LeftAndRight
    }
    
    public func reloadData(effect: EffectEnum) {
        self.reloadData()
        
        switch effect {
        case .roll:
            roll()
            break
        case .LeftAndRight:
            leftAndRightMove()
            break
        }
        
    }
    
    private func roll() {
        let cells = self.visibleCells
        
        let tableViewHeight = self.bounds.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    private func leftAndRightMove() {
        let cells = self.visibleCells
        
        let tableViewWidth = self.bounds.width

        var alternateFlag = false
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: alternateFlag ? tableViewWidth : tableViewWidth * -1, y: 0)
            
            alternateFlag = !alternateFlag
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

