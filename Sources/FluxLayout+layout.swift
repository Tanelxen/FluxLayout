//
//  FluxLayout+layout.swift
//  FluxLayout
//
//  Created by Fedor Artemenkov on 17.09.2021.
//

import UIKit

extension Flux
{
    internal func layout()
    {
        if items.isEmpty { return }
        
        let lastItemIndex = items.count - 1
        
        var constraints: [NSLayoutConstraint] = []
        
        for (index, item) in items.enumerated()
        {
            guard let itemView = item.view, let hostView = self.view else { continue }
            
            let itemAlign = item.alignSelf ?? self.alignItems
            
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            let prevItem = index > 0 ? items[index-1] : nil
            
            if let start = Flux.makeMainStart(item: item, prevItem: prevItem, hostItem: self)
            {
                constraints.append(start)
            }
            
            if index == lastItemIndex
            {
                if let end = Flux.makeMainEnd(item: item, hostItem: self)
                {
                    constraints.append(end)
                }
            }
            
            if let start = Flux.makeCrossStart(item: item, hostItem: self)
            {
                constraints.append(start)
            }
            
            if let end = Flux.makeCrossEnd(item: item, hostItem: self)
            {
                constraints.append(end)
            }
            
            if itemAlign == .center, let center = Flux.makeCrossCenter(item: item, hostItem: self)
            {
                constraints.append(center)
            }
            
            if let width = item.width
            {
                constraints.append(itemView.widthAnchor.constraint(equalToConstant: width))
            }
            
            if let height = item.height
            {
                constraints.append(itemView.heightAnchor.constraint(equalToConstant: height))
            }
            
            if justifyContent == .spaceBetween, index > 0, items.count > 2
            {
                let gap = UILayoutGuide()
                gap.identifier = "gap-\(index-1)-\(index)"
                
                let isVertical = (self.axis == .vertical)
                
                if let lastGap = gapGuides.last
                {
                    let attribute: NSLayoutConstraint.Attribute = isVertical ? .height : .width
                    
                    constraints.append(NSLayoutConstraint(item: lastGap, attribute: attribute,
                                                          relatedBy: .equal,
                                                          toItem: gap, attribute: attribute,
                                                          multiplier: 1, constant: 0))
                }
                
                if let prev = prevItem?.view
                {
                    let attribute1: NSLayoutConstraint.Attribute = isVertical ? .top : .left
                    let attribute2: NSLayoutConstraint.Attribute = isVertical ? .bottom : .right
                    
                    constraints.append(NSLayoutConstraint(item: gap, attribute: attribute1,
                                                          relatedBy: .equal,
                                                          toItem: prev, attribute: attribute2,
                                                          multiplier: 1, constant: 0))
                }
                
                let attribute1: NSLayoutConstraint.Attribute = isVertical ? .bottom : .right
                let attribute2: NSLayoutConstraint.Attribute = isVertical ? .top : .left
                
                constraints.append(NSLayoutConstraint(item: gap, attribute: attribute1,
                                                      relatedBy: .equal,
                                                      toItem: itemView, attribute: attribute2,
                                                      multiplier: 1, constant: 0))
                
                hostView.addLayoutGuide(gap)
                gapGuides.append(gap)
            }
            
            if justifyContent == .center
            {
                let isVertical = (self.axis == .vertical)
                
                if index == 0
                {
                    let gap = UILayoutGuide()
                    gap.identifier = isVertical ? "gapTop" : "gapLeft"
                    
                    let attribute1: NSLayoutConstraint.Attribute = isVertical ? .top : .left
                    let attribute2: NSLayoutConstraint.Attribute = isVertical ? .bottom : .right
                    
                    constraints.append(NSLayoutConstraint(item: hostView, attribute: attribute1,
                                                          relatedBy: .equal,
                                                          toItem: gap, attribute: attribute1,
                                                          multiplier: 1, constant: 0))
                    
                    constraints.append(NSLayoutConstraint(item: itemView, attribute: attribute1,
                                                          relatedBy: .equal,
                                                          toItem: gap, attribute: attribute2,
                                                          multiplier: 1, constant: 0))
                    
                    hostView.addLayoutGuide(gap)
                    gapGuides.append(gap)
                }
                else if index == lastItemIndex
                {
                    let gap = UILayoutGuide()
                    gap.identifier = isVertical ? "gapBottom" : "gapRight"
                    
                    let attribute1: NSLayoutConstraint.Attribute = isVertical ? .bottom : .right
                    let attribute2: NSLayoutConstraint.Attribute = isVertical ? .top : .left
                    
                    constraints.append(NSLayoutConstraint(item: hostView, attribute: attribute1,
                                                          relatedBy: .equal,
                                                          toItem: gap, attribute: attribute1,
                                                          multiplier: 1, constant: 0))
                    
                    constraints.append(NSLayoutConstraint(item: itemView, attribute: attribute1,
                                                          relatedBy: .equal,
                                                          toItem: gap, attribute: attribute2,
                                                          multiplier: 1, constant: 0))
                    
                    
                    if let lastGap = gapGuides.last
                    {
                        let attribute: NSLayoutConstraint.Attribute = isVertical ? .height : .width
                        
                        constraints.append(NSLayoutConstraint(item: lastGap, attribute: attribute,
                                                              relatedBy: .equal,
                                                              toItem: gap, attribute: attribute,
                                                              multiplier: 1, constant: 0))
                    }
                    
                    hostView.addLayoutGuide(gap)
                    gapGuides.append(gap)
                }
            }
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func mainStartMargin(for hostAxis: NSLayoutConstraint.Axis) -> CGFloat
    {
        return (hostAxis == .vertical) ? topMargin.value : leftMargin.value
    }
    
    private func mainEndMargin(for hostAxis: NSLayoutConstraint.Axis) -> CGFloat
    {
        return (hostAxis == .vertical) ? bottomMargin.value : rightMargin.value
    }
    
    private func crossStartMargin(for hostAxis: NSLayoutConstraint.Axis) -> CGFloat
    {
        return (hostAxis == .horizontal) ? topMargin.value : leftMargin.value
    }
    
    private func crossEndMargin(for hostAxis: NSLayoutConstraint.Axis) -> CGFloat
    {
        return (hostAxis == .horizontal) ? bottomMargin.value : rightMargin.value
    }
    
    // Констрейнт начала по основной оси.
    // Для column это top, для row - left
    private class func makeMainStart(item: Flux, prevItem: Flux?, hostItem: Flux) -> NSLayoutConstraint?
    {
        guard let itemView = item.view, let hostView = hostItem.view else { return nil }
        
        let isVertical = (hostItem.axis == .vertical)
        
        if let prevItem = prevItem, let prevItemView = prevItem.view
        {
            let constant = item.mainStartMargin(for: hostItem.axis) + prevItem.mainEndMargin(for: hostItem.axis)
            var relation: NSLayoutConstraint.Relation = .equal
            
            let attribute1: NSLayoutConstraint.Attribute = isVertical ? .top : .left
            let attribute2: NSLayoutConstraint.Attribute = isVertical ? .bottom : .right
            
            if hostItem.justifyContent == .spaceBetween
            {
                relation = .greaterThanOrEqual
            }
            
            return NSLayoutConstraint(item: itemView, attribute: attribute1,
                                      relatedBy: relation,
                                      toItem: prevItemView, attribute: attribute2,
                                      multiplier: 1, constant: constant)
        }
        else
        {
            let constant = item.mainStartMargin(for: hostItem.axis)
            var relation: NSLayoutConstraint.Relation = .equal
            
            let attribute1: NSLayoutConstraint.Attribute = isVertical ? .top : .left
            let attribute2: NSLayoutConstraint.Attribute = isVertical ? .top : .left
            
            if hostItem.justifyContent == .center || hostItem.justifyContent == .end
            {
                relation = .greaterThanOrEqual
            }
            
            return NSLayoutConstraint(item: itemView, attribute: attribute1,
                                      relatedBy: relation,
                                      toItem: hostView, attribute: attribute2,
                                      multiplier: 1, constant: constant)
        }
    }
    
    // Констрейнт конца последнего элемента по основной оси.
    // Для column это bottom, для row - right
    private class func makeMainEnd(item: Flux, hostItem: Flux) -> NSLayoutConstraint?
    {
        guard let itemView = item.view, let hostView = hostItem.view else { return nil }
        
        let isVertical = (hostItem.axis == .vertical)
        
        let constant = -item.mainEndMargin(for: hostItem.axis)
        
        var relation: NSLayoutConstraint.Relation = .equal
        
        let attribute1: NSLayoutConstraint.Attribute = isVertical ? .bottom : .right
        let attribute2: NSLayoutConstraint.Attribute = isVertical ? .bottom : .right
        
        if hostItem.justifyContent == .center || hostItem.justifyContent == .start
        {
            relation = .lessThanOrEqual
        }
        
        return NSLayoutConstraint(item: itemView, attribute: attribute1,
                                  relatedBy: relation,
                                  toItem: hostView, attribute: attribute2,
                                  multiplier: 1, constant: constant)
    }
    
    // Констрейнт начала элемента по побочной оси.
    // Для column это left, для row - top
    private class func makeCrossStart(item: Flux, hostItem: Flux) -> NSLayoutConstraint?
    {
        guard let itemView = item.view, let hostView = hostItem.view else { return nil }
        
        let isVertical = (hostItem.axis == .vertical)
        
        let constant = item.crossStartMargin(for: hostItem.axis)
        
        var relation: NSLayoutConstraint.Relation = .greaterThanOrEqual
        
        let attribute1: NSLayoutConstraint.Attribute = isVertical ? .left : .top
        let attribute2: NSLayoutConstraint.Attribute = isVertical ? .left : .top
        
        let itemAlign = item.alignSelf ?? hostItem.alignItems
        
        if itemAlign == .stretch || itemAlign == .start
        {
            relation = .equal
        }
        
        return NSLayoutConstraint(item: itemView, attribute: attribute1,
                                  relatedBy: relation,
                                  toItem: hostView, attribute: attribute2,
                                  multiplier: 1, constant: constant)
    }
    
    // Констрейнт конца элемента по побочной оси.
    // Для column это right, для row - bottom
    private class func makeCrossEnd(item: Flux, hostItem: Flux) -> NSLayoutConstraint?
    {
        guard let itemView = item.view, let hostView = hostItem.view else { return nil }
        
        let isVertical = (hostItem.axis == .vertical)
        
        let constant = -item.crossEndMargin(for: hostItem.axis)
        
        var relation: NSLayoutConstraint.Relation = .lessThanOrEqual
        
        let attribute1: NSLayoutConstraint.Attribute = isVertical ? .right : .bottom
        let attribute2: NSLayoutConstraint.Attribute = isVertical ? .right : .bottom
        
        let itemAlign = item.alignSelf ?? hostItem.alignItems
        
        if itemAlign == .stretch || itemAlign == .end
        {
            relation = .equal
        }
        
        return NSLayoutConstraint(item: itemView, attribute: attribute1,
                                  relatedBy: relation,
                                  toItem: hostView, attribute: attribute2,
                                  multiplier: 1, constant: constant)
    }
    
    // Констрейнт центрирования элемента по побочной оси.
    // Для column это centerX, для row - centerY
    private class func makeCrossCenter(item: Flux, hostItem: Flux) -> NSLayoutConstraint?
    {
        guard let itemView = item.view, let hostView = hostItem.view else { return nil }
        
        let isVertical = (hostItem.axis == .vertical)
        
        let attribute1: NSLayoutConstraint.Attribute = isVertical ? .centerX : .centerY
        let attribute2: NSLayoutConstraint.Attribute = isVertical ? .centerX : .centerY
        
        return NSLayoutConstraint(item: itemView, attribute: attribute1,
                                  relatedBy: .equal,
                                  toItem: hostView, attribute: attribute2,
                                  multiplier: 1, constant: 0)
    }
}
