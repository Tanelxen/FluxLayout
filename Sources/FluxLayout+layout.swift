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
            
            if index == 0
            {
                let constant = item.topMargin.value
                
                if justifyContent == .center || justifyContent == .end
                {
                    constraints.append(itemView.topAnchor.constraint(greaterThanOrEqualTo: hostView.topAnchor, constant: constant))
                }
                else
                {
                    constraints.append(itemView.topAnchor.constraint(equalTo: hostView.topAnchor, constant: constant))
                }
            }
            else if let prev = items[index-1].view
            {
                let constant = item.topMargin.value + items[index-1].bottomMargin.value
                
                if justifyContent == .spaceBetween
                {
                    constraints.append(itemView.topAnchor.constraint(greaterThanOrEqualTo: prev.bottomAnchor, constant: constant))
                }
                else
                {
                    constraints.append(itemView.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: constant))
                }
            }
            
            if itemAlign == .stretch || itemAlign == .start
            {
                let constant = item.leftMargin.value
                constraints.append(itemView.leftAnchor.constraint(equalTo: hostView.leftAnchor, constant: constant))
            }
            else
            {
                let constant = item.leftMargin.value
                constraints.append(itemView.leftAnchor.constraint(greaterThanOrEqualTo: hostView.leftAnchor, constant: constant))
            }
            
            if itemAlign == .stretch || itemAlign == .end
            {
                let constant = -item.rightMargin.value
                constraints.append(itemView.rightAnchor.constraint(equalTo: hostView.rightAnchor, constant: constant))
            }
            else
            {
                let constant = -item.rightMargin.value
                constraints.append(itemView.rightAnchor.constraint(lessThanOrEqualTo: hostView.rightAnchor, constant: constant))
            }
            
            if index == lastItemIndex
            {
                if justifyContent == .center || justifyContent == .start
                {
                    let constant = -item.bottomMargin.value
                    constraints.append(itemView.bottomAnchor.constraint(lessThanOrEqualTo: hostView.bottomAnchor, constant: constant))
                }
                else
                {
                    let constant = -item.bottomMargin.value
                    constraints.append(itemView.bottomAnchor.constraint(equalTo: hostView.bottomAnchor, constant: constant))
                }
            }
            
            if itemAlign == .center
            {
                constraints.append(itemView.centerXAnchor.constraint(equalTo: hostView.centerXAnchor))
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
                
                if let lastGap = gapGuides.last
                {
                    constraints.append(lastGap.heightAnchor.constraint(equalTo: gap.heightAnchor))
                }
                
                if let prev = items[index-1].view
                {
                    constraints.append(gap.topAnchor.constraint(equalTo: prev.bottomAnchor))
                }
                
                constraints.append(gap.bottomAnchor.constraint(equalTo: itemView.topAnchor))
                
                hostView.addLayoutGuide(gap)
                gapGuides.append(gap)
            }
            
            if justifyContent == .center
            {
                if index == 0
                {
                    let gap = UILayoutGuide()
                    gap.identifier = "gapTop"
                    
                    constraints.append(hostView.topAnchor.constraint(equalTo: gap.topAnchor))
                    constraints.append(itemView.topAnchor.constraint(equalTo: gap.bottomAnchor))
                    
                    hostView.addLayoutGuide(gap)
                    gapGuides.append(gap)
                }
                else if index == lastItemIndex
                {
                    let gap = UILayoutGuide()
                    gap.identifier = "gapBottom"
                    
                    constraints.append(hostView.bottomAnchor.constraint(equalTo: gap.bottomAnchor))
                    constraints.append(itemView.bottomAnchor.constraint(equalTo: gap.topAnchor))
                    
                    if let lastGap = gapGuides.last
                    {
                        constraints.append(lastGap.heightAnchor.constraint(equalTo: gap.heightAnchor))
                    }
                    
                    hostView.addLayoutGuide(gap)
                    gapGuides.append(gap)
                }
            }
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
