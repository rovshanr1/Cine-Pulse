//
//  AspectRatio.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 19.10.25.
//

import Foundation

enum AspectRatio {
    case sixteenByNine
    case fourByThree
    case threeByTwo
    

    var value: CGFloat {
        switch self {
        case .sixteenByNine: return 9.0 / 16.0
        case .fourByThree: return 3.0 / 4.0
        case .threeByTwo: return 2.0 / 3.0
        }
    }

    func height(for width: CGFloat) -> CGFloat {
        return width * value
    }
}
