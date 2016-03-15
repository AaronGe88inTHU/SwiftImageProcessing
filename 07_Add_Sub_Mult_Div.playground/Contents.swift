//: Playground - noun: a place where people can play

import UIKit

let monet1 = RGBAImage(image: UIImage(named: "monet1")!)!
let monet2 = RGBAImage(image: UIImage(named: "monet2")!)!
let tiger  = RGBAImage(image: UIImage(named: "tiger")!)!

ImageProcess.composite(monet1.clone(), monet2.clone(), tiger.clone()).toUIImage()
ImageProcess.add(monet1.clone(), monet2.clone()).toUIImage()
ImageProcess.sub(monet1.clone(), monet2.clone()).toUIImage()
ImageProcess.mul(monet1.clone(), monet2.clone()).toUIImage()
ImageProcess.sub(ImageProcess.div(tiger.clone(), monet2.clone()), factor: 0.5).toUIImage()

let factor = 0.3
ImageProcess.add(monet1.clone(), factor: factor).toUIImage()
ImageProcess.sub(monet1.clone(), factor: factor).toUIImage()
ImageProcess.mul(monet1.clone(), factor: factor).toUIImage()
ImageProcess.div(monet1.clone(), factor: factor).toUIImage()


let R1 = ImageProcess.gray5(monet1.clone())
let img1 = ImageProcess.add(R1.clone(), factor: 0.5)
let img2 = ImageProcess.sub(R1.clone(), factor: 0.7)
ImageProcess.sub(img1.clone(), img2.clone()).toUIImage()


