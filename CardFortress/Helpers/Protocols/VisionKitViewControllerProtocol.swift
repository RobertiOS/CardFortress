//
//  VisionKitViewControllerProtocol.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/17/23.
//

import VisionKit
import Foundation

protocol VisionKitViewControllerProtocol: UIViewController {
    var delegate: VNDocumentCameraViewControllerDelegate? { get set }
}

final class VisionKitViewController: VNDocumentCameraViewController, VisionKitViewControllerProtocol {
}
