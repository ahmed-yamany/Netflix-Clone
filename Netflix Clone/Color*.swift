//
//  Color*.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 01/09/2022.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
