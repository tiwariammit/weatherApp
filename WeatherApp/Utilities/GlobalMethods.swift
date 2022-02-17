//
//  GlobalMethods.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation
import UIKit

extension String {
    
    func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}


//MARK:-Delay
func delay(delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
