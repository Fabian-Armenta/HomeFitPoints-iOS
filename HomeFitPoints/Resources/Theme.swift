//
//  Theme.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 18/11/25.
//

import UIKit

struct Theme {
    struct Colors {
        static let primaryOrange = UIColor(red: 1.00, green: 0.48, blue: 0.00, alpha: 1.00) // #FF7A00
        static let primaryBlack = UIColor.black
        static let secondaryDarkGray = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.00) // #1C1C1E
        static let secondaryMediumGray = UIColor(red: 0.23, green: 0.23, blue: 0.24, alpha: 1.00) // #3A3A3C
        static let textWhite = UIColor.white
        static let background = UIColor.systemBackground
    }
    
    struct Fonts {
        static func title(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        static func body(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
}
