//: Playground - noun: a place where people can play

import UIKit

func gray1(_ image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (pixel) -> Pixel in
        var pixel = pixel
        let result = pixel.Rf*0.2999 + pixel.Gf*0.587 + pixel.Bf*0.114
        pixel.Rf = result
        pixel.Gf = result
        pixel.Bf = result
        return pixel
    }
    return outImage
}

func gray2(_ image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (pixel) -> Pixel in
        var pixel = pixel
        let result = (pixel.Rf + pixel.Gf + pixel.Bf) / 3.0
        pixel.Rf = result
        pixel.Gf = result
        pixel.Bf = result
        return pixel
    }
    return outImage
}

func gray3(_ image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (pixel) -> Pixel in
        var pixel = pixel
        pixel.R = pixel.G
        pixel.G = pixel.G
        pixel.B = pixel.G
        return pixel
    }
    return outImage
}

func gray4(_ image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (pixel) -> Pixel in
        var pixel = pixel
        let result = pixel.Rf*0.212671 + pixel.Gf*0.715160 + pixel.Bf*0.071169
        pixel.Rf = result
        pixel.Gf = result
        pixel.Bf = result
        return pixel
    }
    return outImage
}

func gray5(_ image: RGBAImage) -> RGBAImage {
    var outImage = image
    outImage.process { (pixel) -> Pixel in
        var pixel = pixel
        let result = sqrt(pow(pixel.Rf, 2) + pow(pixel.Rf, 2) + pow(pixel.Rf, 2))/sqrt(3.0)
        pixel.Rf = result
        pixel.Gf = result
        pixel.Bf = result
        return pixel
    }
    return outImage
}



let rgba1 = RGBAImage(image: UIImage(named: "monet")!)!
gray1(rgba1).toUIImage()

let rgba2 = RGBAImage(image: UIImage(named: "monet")!)!
gray2(rgba2).toUIImage()

let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
gray3(rgba3).toUIImage()

let rgba4 = RGBAImage(image: UIImage(named: "monet")!)!
gray4(rgba4).toUIImage()

let rgba5 = RGBAImage(image: UIImage(named: "monet")!)!
gray5(rgba5).toUIImage()
