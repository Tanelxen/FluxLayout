//
//  FluxLayout+Margins.swift
//  Gorod
//
//  Created by Fedor Artemenkov on 16.09.2021.
//  Copyright © 2021 RTG Soft. All rights reserved.
//

import CoreGraphics

extension Flux
{
    @discardableResult
    public func margin(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Flux
    {
        topMargin = Margin(top, greaterOfEqual: false)
        leftMargin = Margin(left, greaterOfEqual: false)
        bottomMargin = Margin(bottom, greaterOfEqual: false)
        rightMargin = Margin(right, greaterOfEqual: false)
        return self
    }
    
    @discardableResult
    public func marginHorizontal(_ value: CGFloat) -> Flux
    {
        leftMargin = Margin(value, greaterOfEqual: false)
        rightMargin = Margin(value, greaterOfEqual: false)
        return self
    }
    
    @discardableResult
    public func marginVertical(_ value: CGFloat) -> Flux
    {
        topMargin = Margin(value, greaterOfEqual: false)
        bottomMargin = Margin(value, greaterOfEqual: false)
        return self
    }
    
    @discardableResult
    public func marginTop(_ value: CGFloat) -> Flux
    {
        topMargin = Margin(value, greaterOfEqual: false)
        return self
    }
    
    @discardableResult
    public func marginTopGreaterOrEqual(_ value: CGFloat) -> Flux
    {
        topMargin = Margin(value, greaterOfEqual: true)
        return self
    }
    
    @discardableResult
    public func marginLeft(_ value: CGFloat) -> Flux
    {
        leftMargin = Margin(value, greaterOfEqual: false)
        return self
    }
    
    @discardableResult
    public func marginBottom(_ value: CGFloat) -> Flux
    {
        bottomMargin = Margin(value, greaterOfEqual: false)
        return self
    }
    
    @discardableResult
    public func marginRight(_ value: CGFloat) -> Flux
    {
        rightMargin = Margin(value, greaterOfEqual: false)
        return self
    }
}
