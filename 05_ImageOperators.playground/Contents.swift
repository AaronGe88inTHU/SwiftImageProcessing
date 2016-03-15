//: Playground - noun: a place where people can play

import UIKit

let rgba1 = RGBAImage(image: UIImage(named: "monet")!)!
ImageProcess
    .gray1(rgba1.clone())
    .toUIImage()

let rgba2 = RGBAImage(image: UIImage(named: "monet")!)!
ImageProcess
    .gray2(rgba1.clone())
    .toUIImage()

let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
ImageProcess
    .gray3(rgba1.clone())
    .toUIImage()

let rgba4 = RGBAImage(image: UIImage(named: "monet")!)!
ImageProcess
    .gray4(rgba1.clone())
    .toUIImage()

let rgba5 = RGBAImage(image: UIImage(named: "monet")!)!
ImageProcess
    .gray5(rgba1.clone())
    .toUIImage()


let image1 = RGBAImage(image: UIImage(named: "monet")!)!
let r_component = ImageProcess.grabR(rgba1.clone())
r_component.toUIImage()

let image2 = RGBAImage(image: UIImage(named: "monet")!)!
let g_component = ImageProcess.grabG(rgba1.clone())
g_component.toUIImage()

let image3 = RGBAImage(image: UIImage(named: "monet")!)!
let b_component = ImageProcess.grabB(rgba1.clone())
b_component.toUIImage()

ImageProcess
    .composite(r_component, g_component, b_component)
    .toUIImage()

ImageProcess
    .composite(b_component, g_component)
    .toUIImage()
