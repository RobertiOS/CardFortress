//
//  SharedImages.swift
//
//
//  Created by Roberto Corrales on 11/2/23.
//

import UIKit
import SwiftUI

public struct SharedImages {
    public static let amex = CFImage(
        swiftUIImage: Image("amex", bundle: .module),
        uiImage:  UIImage(named: "amex", in: Bundle.module, compatibleWith: nil)!
    )
    
    public static let visa = CFImage(
        swiftUIImage: Image("visa", bundle: .module),
        uiImage:  UIImage(named: "visa", in: Bundle.module, compatibleWith: nil)!
    )
    
    public static let masterCard = CFImage(
        swiftUIImage: Image("masterCard", bundle: .module),
        uiImage:  UIImage(named: "masterCard", in: Bundle.module, compatibleWith: nil)!
    )
    
    public static let maestro = CFImage(
        swiftUIImage: Image("maestro", bundle: .module),
        uiImage:  UIImage(named: "maestro", in: Bundle.module, compatibleWith: nil)!
    )
    
    public static let discover = CFImage(
        swiftUIImage: Image("discover", bundle: .module),
        uiImage:  UIImage(named: "discover", in: Bundle.module, compatibleWith: nil)!
    )
    
    public static let chip = CFImage(
        swiftUIImage: Image("chip", bundle: .module),
        uiImage:  UIImage(named: "chip", in: Bundle.module, compatibleWith: nil)!
    )
    
    public static let copyImage = CFImage(
        swiftUIImage: Image("copyImage", bundle: .module),
        uiImage:  UIImage(named: "copyImage", in: Bundle.module, compatibleWith: nil)!
    )
}

public struct CFImage {
    public let swiftUIImage: Image
    public let uiImage: UIImage
}
