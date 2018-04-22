//: Playground - noun: a place where people can play

import UIKit

let monet1 = RGBAImage(image: UIImage(named: "monet1")!)!
let monet2 = RGBAImage(image: UIImage(named: "monet2")!)!
let tiger  = RGBAImage(image: UIImage(named: "tiger")!)!

// Brightness
ImageProcess.brightness(monet1, contrast: 0.8, brightness: 0.5).toUIImage()

// Split
let (R,G,B) = ImageProcess.splitRGB(monet1)
R.toUIImage()

// Sharpening
let m1 = Array2D(cols:3, rows:3, elements:
    [ 0.0/5.0, -1.0/5.0, 0.0/5.0,
     -1.0/5.0,  9.0/5.0,-1.0/5.0,
      0.0/5.0, -1.0/5.0, 0.0/5.0])
ImageProcess.convolution(R.clone(), mask: m1).toUIImage()

// Blur3x3
let m2 = Array2D(cols: 3, rows: 3, elements:
    [
         1.0/9.0, 1.0/9.0, 1.0/9.0,
         1.0/9.0, 1.0/9.0, 1.0/9.0,
         1.0/9.0, 1.0/9.0, 1.0/9.0,
    ]
)
ImageProcess.convolution(R.clone(), mask: m2).toUIImage()







