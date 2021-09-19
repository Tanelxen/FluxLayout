//
//  Builder.swift
//  FluxLayout
//
//  Created by Fedor Artemenkov on 18.09.2021.
//

extension Flux
{
    /// Описание дочерних элементов на манер SwiftUI
    public func addItems(@FluxLayoutBuilder builder: () -> [Flux])
    {
        guard let host = self.view else { return }
        
        for item in builder()
        {
            guard let itemView = item.view else { continue }
            
            host.addSubview(itemView)
            items.append(item)
            
//            item.didHidden = { [weak self] flux, hidden in
//                self?.item(flux, didHidden: hidden)
//            }
        }
        
        layout()
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
