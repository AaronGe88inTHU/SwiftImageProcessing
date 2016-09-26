//: Playground - noun: a place where people can play

import UIKit


let rgba = RGBAImage(image: UIImage(named: "monet")!)!


var totalR = 0
var totalG = 0
var totalB = 0

rgba.process { (pixel) -> Pixel in
    totalR += Int(pixel.R)
    totalG += Int(pixel.G)
    totalB += Int(pixel.B)
    return pixel
}

let pixelCount = rgba.width * rgba.height
let avgR = totalR / pixelCount
let avgG = totalG / pixelCount
let avgB = totalB / pixelCount



func contrast(_ image: RGBAImage) -> RGBAImage {
    image.process { (var pixel) -> Pixel in
        let deltaR = Int(pixel.R) - avgR
        let deltaG = Int(pixel.G) - avgG
        let deltaB = Int(pixel.B) - avgB
        pixel.R = UInt8(max(min(255, avgR + 3 * deltaR), 0)) //clamp
        pixel.G = UInt8(max(min(255, avgG + 3 * deltaG), 0))
        pixel.B = UInt8(max(min(255, avgB + 3 * deltaB), 0))
        
        return pixel
    }
    return image
}

let newImage = contrast(rgba).toUIImage()


