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


let b_component = ImageProcess.grabB(rgba1.clone())
b_component.toUIImage()

ImageProcess
    .composite(r_component, g_component, b_component)
    .toUIImage()

ImageProcess
    .composite(b_component, g_component)
    .toUIImage()





// 색상분할을 다르게
//let image3 = rgba1.clone()
//let R = ByteImage(width: image3.width, height: image3.height)
//let G = ByteImage(width: image3.width, height: image3.height)
//let B = ByteImage(width: image3.width, height: image3.height)
//
//image3.enumerate { (index, pixel) -> Void in
//
//    R.pixels[index] = pixel.R.toBytePixel()
//    G.pixels[index] = pixel.G.toBytePixel()
//    B.pixels[index] = pixel.B.toBytePixel()
//}
//
//R.toUIImage()
//G.toUIImage()
//B.toUIImage()
//
//
//
//ImageProcess.composite(R, G, B).toUIImage()

let (R, G, B) = ImageProcess.splitRGB(rgba1.clone())
R.toUIImage()
G.toUIImage()
B.toUIImage()

ImageProcess.composite(R, G, B).toUIImage()




