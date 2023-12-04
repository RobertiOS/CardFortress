//
//  UIHostingControllerWrapper.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/3/23.
//

import Foundation
import SwiftUI

final class UIHostingControllerWrapper<T: View>: UIHostingController<T> {
    
    override init(rootView: T) {
        super.init(rootView: rootView)
        debugPrint("initialied: \(T.self)" )
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("deinitialied: \(T.self)" )
    }
    
}
