//: Playground - noun: a place where people can play

import UIKit

func grabR(image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (var pixel) -> Pixel in
        pixel.R = pixel.R
        pixel.G = 0
        pixel.B = 0
        return pixel
    }
    return outImage
}

func grabG(image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (var pixel) -> Pixel in
        pixel.R = 0
        pixel.G = pixel.G
        pixel.B = 0
        return pixel
    }
    return outImage
}

func grabB(image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (var pixel) -> Pixel in
        pixel.R = 0
        pixel.G = 0
        pixel.B = pixel.B
        return pixel
    }
    return outImage
}


let rgba1 = RGBAImage(image: UIImage(named: "monet")!)!
let newImage = grabR(rgba1).toUIImage()

let rgba2 = RGBAImage(image: UIImage(named: "monet")!)!
grabG(rgba2).toUIImage()

let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
grabB(rgba3).toUIImage()

let result = RGBAImage.composite(rgba1, rgba2, rgba3)
result.toUIImage()
