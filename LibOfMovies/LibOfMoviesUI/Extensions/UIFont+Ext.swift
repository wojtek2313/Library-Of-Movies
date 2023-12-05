//
//  UIFont+Ext.swift
//  LibOfMoviesUI
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import UIKit

public extension UIFont {
    static var smallAvenirHeavyOpaque: UIFont {
        return UIFont(name: "Avenir-HeavyOblique", size: 10) ?? UIFont()
    }
    
    static var avenirHeavyOpaqueTitle: UIFont {
        return UIFont(name: "Avenir-HeavyOblique", size: 15) ?? UIFont()
    }
    
    static var avenirBlackOpaqueMinimalized: UIFont {
        return UIFont(name: "Avenir-BlackOblique", size: 10) ?? UIFont()
    }
}
