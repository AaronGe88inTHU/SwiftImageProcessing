//: Playground - noun: a place where people can play

import UIKit

let monet1 = RGBAImage(image: UIImage(named: "monet1")!)!
let monet2 = RGBAImage(image: UIImage(named: "monet2")!)!
let tiger  = RGBAImage(image: UIImage(named: "tiger")!)!

ImageProcess.blending(monet1, tiger, alpha: 0.5).toUIImage()


