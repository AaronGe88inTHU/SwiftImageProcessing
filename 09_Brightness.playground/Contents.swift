//: Playground - noun: a place where people can play

import UIKit

let monet1 = RGBAImage(image: UIImage(named: "monet1")!)!
let monet2 = RGBAImage(image: UIImage(named: "monet2")!)!
let tiger  = RGBAImage(image: UIImage(named: "tiger")!)!

ImageProcess.brightness(monet1, contrast: 0.3, brightness: 0.8).toUIImage()


