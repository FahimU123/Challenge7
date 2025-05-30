//
//  StatCardModel.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import Foundation
import SwiftUI

struct StatCardModel {
    var image: String
    var title: String
    var stat: String
    let viewProvider: () -> AnyView
}
