//
//  FluxLayout.swift
//  Gorod
//
//  Created by Fedor Artemenkov on 05.09.2021.
//  Copyright © 2021 RTG Soft. All rights reserved.
//

import UIKit

public final class Flux
{
    internal weak var view: UIView?
    internal var items: [Flux] = []
    
    internal var itemsVisibilityMode: ItemsVisibilityMode = .ignore
    
    internal var axis: NSLayoutConstraint.Axis = .vertical
    internal var alignItems: Alignment = .stretch
    internal var alignSelf: Alignment?
    internal var justifyContent: JustifyContent = .start
    
    internal var position: Position = .relative
    
    internal var topMargin: Margin = .zero
    internal var leftMargin: Margin = .zero
    internal var bottomMargin: Margin = .zero
    internal var rightMargin: Margin = .zero
    
    internal var gapGuides: [UILayoutGuide] = []
    
    internal var width: CGFloat?
    internal var height: CGFloat?
    
    internal var observation: NSKeyValueObservation?
    
    internal var didHidden: ((Flux, Bool) -> Void)?
    
    internal var name: String?
    
    public init(_ view: UIView)
    {
        self.view = view
    }
    
    /// Описание дочерних элементов на манер SwiftUI
    public func addItems(@FluxLayoutBuilder builder: () -> [Flux])
    {
        guard let host = self.view else { return }
        
        for item in builder()
        {
            guard let itemView = item.view else { continue }
            
            host.addSubview(itemView)
            items.append(item)
            
            item.didHidden = { [weak self] flux, hidden in
                self?.item(flux, didHidden: hidden)
            }
        }
        
        layout()
    }

    /// Добавление нового элемента в иерархию
    @discardableResult
    public func addItem(_ item: UIView) -> Flux
    {
        if let host = self.view
        {
            host.addSubview(item)
            
            let itemFlux = Flux(item)
            
            items.append(itemFlux)
            
            itemFlux.didHidden = { [weak self] flux, hidden in
                self?.item(flux, didHidden: hidden)
            }
            
            return itemFlux
        }
        else
        {
            preconditionFailure("Trying to modify deallocated host view")
        }
    }
    
    /// Создать UIView и добавить в иерархию
    @discardableResult
    public func addItem() -> Flux
    {
        let view = UIView()
        return addItem(view)
    }
    
    /// Определить иерархию дочерних элементов
    @discardableResult
    public func define(_ closure: (_ flux: Flux) -> Void) -> Flux
    {
        closure(self)
        layout()
        
        return self
    }
    
    /// Отображаемое имя для Debug View Hierarchy
    @discardableResult
    public func name(_ name: String) -> Flux
    {
        self.name = name
        view?.accessibilityLabel = name
        
        return self
    }
    
    /// Реакция на изменение видимости дочерних элементов
    /// ignore - иерархия не адаптируется, используется построение на NSLayoutConstraint. Наиболее оптимальный. Используется по-умолчанию.
    /// observe - при скрытии дочернего элемента остальные подтягиваются. В иерархию добавляется UIStackView, а для дочерхих элементов создаются контейнеры для отступов
    @discardableResult
    public func itemsVisibility(_ value: ItemsVisibilityMode) -> Flux
    {
        itemsVisibilityMode = value
        return self
    }
    
    private func observeVisibility()
    {
        observation = view?.observe(\.isHidden, options: [.new])
        {
            [weak self] (_, change) in
            guard let self = self else { return }
            
            if let change = change.newValue
            {
                self.didHidden?(self, change)
            }
        }
    }
    

    
    private func item(_ item: Flux, didHidden value: Bool)
    {
//        item.marginContainer?.isHidden = value
    }
    
    deinit
    {
//        print("deinit Flux item for \(name ?? "")")
        observation?.invalidate()
    }
}

public extension Flux
{
    enum ItemsVisibilityMode
    {
        case ignore
        case observe
    }
    
    enum Direction
    {
        case column
        case row
    }
    
    enum Alignment
    {
        case stretch
        case start
        case end
        case center
    }
    
    enum JustifyContent
    {
        case start
        case center
        case end
        case spaceBetween
//        case spaceAround
//        case spaceEvenly
    }
    
    enum Position
    {
        case relative
        case absolute
    }
}

extension Flux
{
    /// Ось, по которой происходит построение иерархии
    /// Вертикальный список - column
    /// Горизонтальный список - row
    @discardableResult
    public func direction(_ value: Direction) -> Flux
    {
        axis = (value == .column) ? .vertical : .horizontal
        return self
    }
    
    /// Как выравнивать дочерние элементы. По-умолчанию растягиваются вдоль побочной оси.
    @discardableResult
    public func alignItems(_ value: Alignment) -> Flux
    {
        alignItems = value
        return self
    }
    
    @discardableResult
    public func alignSelf(_ value: Alignment) -> Flux
    {
        alignSelf = value
        return self
    }
    
    @discardableResult
    public func justifyContent(_ value: JustifyContent) -> Flux
    {
        justifyContent = value
        return self
    }
    
    @discardableResult
    public func position(_ value: Position) -> Flux
    {
        position = value
        return self
    }
}

extension Flux
{
    @discardableResult
    public func height(_ value: CGFloat) -> Flux
    {
        height = value
        return self
    }
    
    @discardableResult
    public func width(_ value: CGFloat) -> Flux
    {
        width = value
        return self
    }
}
    


extension Flux
{
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Flux
    {
        if let host = self.view
        {
            host.backgroundColor = color
            return self
        }
        else
        {
            preconditionFailure("Trying to modify deallocated host view")
        }
    }
    
    @discardableResult
    public func debugBorder(_ color: UIColor) -> Flux
    {
        if let host = self.view
        {
            host.layer.borderColor = color.cgColor
            host.layer.borderWidth = 0.5
            return self
        }
        else
        {
            preconditionFailure("Trying to modify deallocated host view")
        }
    }
}

private extension UIView
{
    var prev: UIView?
    {
        guard let parentSubviews = superview?.subviews else { return nil }
        
        guard let selfIndex = parentSubviews.firstIndex(of: self), selfIndex > 0 else { return nil }
        
        return parentSubviews[selfIndex - 1]
    }
}

@resultBuilder
public struct FluxLayoutBuilder
{
    static func buildBlock(_ components: Flux...) -> [Flux]
    {
        return components
    }
}

extension Flux
{
    struct Margin
    {
        var value: CGFloat = 0
        var greaterOfEqual: Bool = false
        
        init(_ value: CGFloat, greaterOfEqual: Bool)
        {
            self.value = value
            self.greaterOfEqual = greaterOfEqual
        }
        
        init(_ value: CGFloat)
        {
            self.value = value
            self.greaterOfEqual = false
        }
        
        static var zero: Margin = Margin(0, greaterOfEqual: false)
    }
    
    enum MarginRelation
    {
        case equal
        case greaterOrEqual
    }
}
