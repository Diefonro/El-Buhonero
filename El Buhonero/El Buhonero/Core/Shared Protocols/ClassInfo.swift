//
//  ClassInfo.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 26/06/25.
//

import UIKit

protocol StoryboardInfo {
    static var storyboard: String { get }
    static var identifier: String { get }
}

protocol CellInfo {
    static var reuseIdentifier: String { get }
}

