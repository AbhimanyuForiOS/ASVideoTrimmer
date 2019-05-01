//
//  FrameModel.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 02/04/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import UIKit
class  FrameModel {
    var second:Int
    var frame:UIImage
    init(second:Int, frame:UIImage) {
        self.second = second
        self.frame   = frame
    }
}
