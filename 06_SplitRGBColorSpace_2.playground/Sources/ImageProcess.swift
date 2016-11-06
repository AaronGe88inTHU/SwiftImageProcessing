import Foundation

public class ImageProcess {
    
    public static func grabR(_ image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (pixel) -> Pixel in
            var pixel = pixel
            pixel.R = pixel.R
            pixel.G = 0
            pixel.B = 0
            return pixel
        }
        return outImage
    }
    
    public static func grabG(_ image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (pixel) -> Pixel in
            var pixel = pixel
            pixel.R = 0
            pixel.G = pixel.G
            pixel.B = 0
            return pixel
        }
        return outImage
    }
    
    public static func grabB(_ image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (pixel) -> Pixel in
            var pixel = pixel
            pixel.R = 0
            pixel.G = 0
            pixel.B = pixel.B
            return pixel
        }
        return outImage
    }
    
    public static func composite(_ rgbaImageList: RGBAImage...) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:rgbaImageList[0].width, height: rgbaImageList[0].height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                for rgba in rgbaImageList {
                    let rgbaPixel = rgba.pixels[index]
                    pixel.R = min(pixel.R + rgbaPixel.R, 255)
                    pixel.G = min(pixel.G + rgbaPixel.G, 255)
                    pixel.B = min(pixel.B + rgbaPixel.B, 255)
                }
                
                result.pixels[index] = pixel
            }
        }
        return result
    }

    
    public static func composite(_ byteImageList: ByteImage...) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:byteImageList[0].width, height: byteImageList[0].height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                for (imageIndex, byte) in byteImageList.enumerated() {

                    let bytePixel = byte.pixels[index]
                    switch imageIndex % 3 {
                    case 0:
                        pixel.R = min(pixel.R + bytePixel.C, 255)
                    case 1:
                        pixel.G = min(pixel.G + bytePixel.C, 255)
                    case 2:
                        pixel.B = min(pixel.B + bytePixel.C, 255)
                    default:
                        break
                    }
                }
                
                result.pixels[index] = pixel
            }
        }
        return result
    }
    
    public static func gray1(_ image: RGBAImage) -> RGBAImage {
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
    
    public static func gray2(_ image: RGBAImage) -> RGBAImage {
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
    
    public static func gray3(_ image: RGBAImage) -> RGBAImage {
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
    
    public static func gray4(_ image: RGBAImage) -> RGBAImage {
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
    
    public static func gray5(_ image: RGBAImage) -> RGBAImage {
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
    
    
    public static func splitRGB(_ rgba: RGBAImage) -> (ByteImage, ByteImage, ByteImage) {
        let R = ByteImage(width: rgba.width, height: rgba.height)
        let G = ByteImage(width: rgba.width, height: rgba.height)
        let B = ByteImage(width: rgba.width, height: rgba.height)
        
        rgba.enumerate { (index, pixel) -> Void in
            
            R.pixels[index] = pixel.R.toBytePixel()
            G.pixels[index] = pixel.G.toBytePixel()
            B.pixels[index] = pixel.B.toBytePixel()
        }

        return (R, G, B)
    }
}
