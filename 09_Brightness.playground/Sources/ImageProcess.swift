import Foundation

public class ImageProcess {
    
    public static func grabR(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            pixel.R = pixel.R
            pixel.G = 0
            pixel.B = 0
            return pixel
        }
        return outImage
    }
    
    public static func grabG(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            pixel.R = 0
            pixel.G = pixel.G
            pixel.B = 0
            return pixel
        }
        return outImage
    }
    
    public static func grabB(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            pixel.R = 0
            pixel.G = 0
            pixel.B = pixel.B
            return pixel
        }
        return outImage
    }
    
    public static func composite(rgbaImageList: RGBAImage...) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:rgbaImageList[0].width, height: rgbaImageList[0].height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                for rgba in rgbaImageList {
                    let rgbaPixel = rgba.pixels[index]
                    pixel.Rf = min(pixel.Rf + rgbaPixel.Rf, 1.0)
                    pixel.Gf = min(pixel.Gf + rgbaPixel.Gf, 1.0)
                    pixel.Bf = min(pixel.Bf + rgbaPixel.Bf, 1.0)
                }
                
                result.pixels[index] = pixel
            }
        }
        return result
    }
    
    public static func composite(functor : (Double, Double) -> Double, rgbaImageList: RGBAImage...) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:rgbaImageList[0].width, height: rgbaImageList[0].height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                for rgba in rgbaImageList {
                    let rgbaPixel = rgba.pixels[index]
                    pixel.Rf = min(functor(pixel.Rf, rgbaPixel.Rf), 1.0)
                    pixel.Gf = min(functor(pixel.Gf, rgbaPixel.Gf), 1.0)
                    pixel.Bf = min(functor(pixel.Bf, rgbaPixel.Bf), 1.0)
                }
                
                result.pixels[index] = pixel
            }
        }
        return result
    }

    
    public static func composite(byteImageList: ByteImage...) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:byteImageList[0].width, height: byteImageList[0].height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                for (imageIndex, byte) in byteImageList.enumerate() {

                    let bytePixel = byte.pixels[index]
                    switch imageIndex % 3 {
                    case 0:
                        pixel.Rf = min(pixel.Rf + bytePixel.Cf, 1.0)
                    case 1:
                        pixel.Gf = min(pixel.Gf + bytePixel.Cf, 1.0)
                    case 2:
                        pixel.Bf = min(pixel.Bf + bytePixel.Cf, 1.0)
                    default:
                        break
                    }
                }
                
                result.pixels[index] = pixel
            }
        }
        return result
    }
    
    public static func composite(functor : (Double, Double) -> Double, byteImageList: ByteImage...) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:byteImageList[0].width, height: byteImageList[0].height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                for (imageIndex, byte) in byteImageList.enumerate() {
                    
                    let bytePixel = byte.pixels[index]
                    switch imageIndex % 3 {
                    case 0:
                        pixel.Rf = min(functor(pixel.Rf, bytePixel.Cf), 1.0)
                    case 1:
                        pixel.Gf = min(functor(pixel.Gf, bytePixel.Cf), 1.0)
                    case 2:
                        pixel.Bf = min(functor(pixel.Bf, bytePixel.Cf), 1.0)
                    default:
                        break
                    }
                }
                
                result.pixels[index] = pixel
            }
        }
        return result
    }
    
    public static func gray1(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            let result = pixel.Rf*0.2999 + pixel.Gf*0.587 + pixel.Bf*0.114
            pixel.Rf = result
            pixel.Gf = result
            pixel.Bf = result
            return pixel
        }
        return outImage
    }
    
    public static func gray2(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            let result = (pixel.Rf + pixel.Gf + pixel.Bf) / 3.0
            pixel.Rf = result
            pixel.Gf = result
            pixel.Bf = result
            return pixel
        }
        return outImage
    }
    
    public static func gray3(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            pixel.R = pixel.G
            pixel.G = pixel.G
            pixel.B = pixel.G
            return pixel
        }
        return outImage
    }
    
    public static func gray4(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            let result = pixel.Rf*0.212671 + pixel.Gf*0.715160 + pixel.Bf*0.071169
            pixel.Rf = result
            pixel.Gf = result
            pixel.Bf = result
            return pixel
        }
        return outImage
    }
    
    public static func gray5(image: RGBAImage) -> RGBAImage {
        var outImage = image
        outImage.process { (var pixel) -> Pixel in
            let result = sqrt(pow(pixel.Rf, 2) + pow(pixel.Rf, 2) + pow(pixel.Rf, 2))/sqrt(3.0)
            pixel.Rf = result
            pixel.Gf = result
            pixel.Bf = result
            return pixel
        }
        return outImage
    }
    
    
    public static func splitRGB(rgba: RGBAImage) -> (ByteImage, ByteImage, ByteImage) {
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
    
    // +, -, *, /
    public static func op(functor : (Double, Double) -> Double, rgbaImage: RGBAImage, factor: Double) -> RGBAImage {
        var outImage = rgbaImage
        outImage.process { (var pixel) -> Pixel in
            pixel.Rf = min(functor(pixel.Rf, factor), 1.0)
            pixel.Gf = min(functor(pixel.Gf, factor), 1.0)
            pixel.Bf = min(functor(pixel.Bf, factor), 1.0)
            return pixel
        }
        return outImage
    }
    
    public static func op(functor : (Double, Double) -> Double, rgbaImage1: RGBAImage, rgbaImage2: RGBAImage) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:rgbaImage1.width, height: rgbaImage1.height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                let rgba1Pixel = rgbaImage1.pixels[index]
                let rgba2Pixel = rgbaImage2.pixels[index]
                
                
                pixel.Rf = min(functor(rgba1Pixel.Rf, rgba2Pixel.Rf), 1.0)
                pixel.Gf = min(functor(rgba1Pixel.Gf, rgba2Pixel.Gf), 1.0)
                pixel.Bf = min(functor(rgba1Pixel.Bf, rgba2Pixel.Bf), 1.0)
                
                result.pixels[index] = pixel
            }
        }
        return result

    }
    
    public static func op(functor : (Double, Double) -> Double, byteImage: ByteImage, factor: Double) -> ByteImage {
        var outImage = byteImage
        outImage.process { (var pixel) -> BytePixel in
            pixel.Cf = min(functor(pixel.Cf, factor), 1.0)
            return pixel
        }
        return outImage
    }
    
    public static func op(functor : (Double, Double) -> Double, byteImage1: ByteImage, byteImage2: ByteImage) -> ByteImage {
        let result : ByteImage = ByteImage(width:byteImage1.width, height: byteImage1.height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                let byte1Pixel = byteImage1.pixels[index]
                let byte2Pixel = byteImage2.pixels[index]
                
                
                pixel.Cf = min(functor(byte1Pixel.Cf, byte2Pixel.Cf), 1.0)
                result.pixels[index] = pixel
            }
        }
        return result
        
    }
    
    
    // MARK:- RGBA
    
    
    public static func add(rgba: RGBAImage, factor: Double) -> RGBAImage {
        return op((+), rgbaImage: rgba, factor: factor)
    }
    
    public static func add(rgba1: RGBAImage, _ rgba2: RGBAImage) -> RGBAImage {
        return op((+), rgbaImage1: rgba1, rgbaImage2: rgba2)
    }
    
    public static func sub(rgba: RGBAImage, factor: Double) -> RGBAImage {
        return op((-), rgbaImage: rgba, factor: factor)
    }
    
    public static func sub(rgba1: RGBAImage, _ rgba2: RGBAImage) -> RGBAImage {
        return op((-), rgbaImage1: rgba1, rgbaImage2: rgba2)
    }
    
    public static func mul(rgba: RGBAImage, factor: Double) -> RGBAImage {
        return op((*), rgbaImage: rgba, factor: factor)
    }
    
    public static func mul(rgba1: RGBAImage, _ rgba2: RGBAImage) -> RGBAImage {
        return op((*), rgbaImage1: rgba1, rgbaImage2: rgba2)
    }
    
    
    public static func div(rgba: RGBAImage, factor: Double) -> RGBAImage {
        if factor == 0.0 {
            return rgba
        }
        return op((/), rgbaImage: rgba, factor: factor)
    }
    
    // 0으로 나누면 안되기 때문에 따로 만듦
    public static func div(rgba1: RGBAImage, _ rgba2: RGBAImage) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:rgba1.width, height: rgba1.height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                let rgba1Pixel = rgba1.pixels[index]
                let rgba2Pixel = rgba2.pixels[index]
                
                
                pixel.Rf = min(rgba1Pixel.Rf / (rgba2Pixel.Rf <= 0.0 ? 1.0 : rgba2Pixel.Rf), 1.0)
                pixel.Gf = min(rgba1Pixel.Gf / (rgba2Pixel.Gf <= 0.0 ? 1.0 : rgba2Pixel.Gf), 1.0)
                pixel.Bf = min(rgba1Pixel.Bf / (rgba2Pixel.Bf <= 0.0 ? 1.0 : rgba2Pixel.Bf), 1.0)
                
                result.pixels[index] = pixel
            }
        }
        return result

    }
    
    
    // MARK:- BYTE
    public static func add(img: ByteImage, factor: Double) -> ByteImage {
        return op((+), byteImage: img, factor: factor)
    }
    
    public static func add(img1: ByteImage, _ img2: ByteImage) -> ByteImage {
        return op((+), byteImage1: img1, byteImage2: img2)
    }
    
    public static func sub(img: ByteImage, factor: Double) -> ByteImage {
        return op((-), byteImage: img, factor: factor)
    }
    
    public static func sub(img1: ByteImage, _ img2: ByteImage) -> ByteImage {
        return op((-), byteImage1: img1, byteImage2: img2)
    }
    
    public static func mul(img: ByteImage, factor: Double) -> ByteImage {
        return op((*), byteImage: img, factor: factor)
    }
    
    public static func mul(img1: ByteImage, _ img2: ByteImage) -> ByteImage {
        return op((*), byteImage1: img1, byteImage2: img2)
    }
    
    
    public static func div(img: ByteImage, factor: Double) -> ByteImage {
        if factor == 0.0 {
            return img
        }
        return op((/), byteImage: img, factor: factor)
    }
    
    // 0으로 나누면 안되기 때문에 따로 만듦
    public static func div(img1: ByteImage, _ img2: ByteImage) -> ByteImage {
        let result : ByteImage = ByteImage(width:img1.width, height: img1.height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                let pixel1 = img1.pixels[index]
                let pixel2 = img2.pixels[index]
                
                
                pixel.Cf = min(pixel1.Cf / (pixel2.Cf <= 0.0 ? 1.0 : pixel2.Cf), 1.0)
                result.pixels[index] = pixel
            }
        }
        return result
        
    }

    // MARK:- RGBA Blending
    public static func blending(img1: RGBAImage, _ img2: RGBAImage, alpha: Double) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:img1.width, height: img1.height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                let pixel1 = img1.pixels[index]
                let pixel2 = img2.pixels[index]
                
                
                pixel.Rf = min( alpha * pixel1.Rf + (1.0 - alpha) * pixel2.Rf, 1.0)
                pixel.Gf = min( alpha * pixel1.Gf + (1.0 - alpha) * pixel2.Gf, 1.0)
                pixel.Bf = min( alpha * pixel1.Bf + (1.0 - alpha) * pixel2.Bf, 1.0)
                
                result.pixels[index] = pixel
            }
        }
        return result
    }
    
    // MARK: - Brightness
    public static func brightness(img1: RGBAImage, contrast: Double, brightness: Double) -> RGBAImage {
        let result : RGBAImage = RGBAImage(width:img1.width, height: img1.height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                let pixel1 = img1.pixels[index]
                
                pixel.Rf = min( pixel1.Rf * contrast + brightness, 1.0)
                pixel.Gf = min( pixel1.Gf * contrast + brightness, 1.0)
                pixel.Bf = min( pixel1.Bf * contrast + brightness, 1.0)
                
                result.pixels[index] = pixel
            }
        }
        return result
    }
    
    public static func brightness(img1: ByteImage, contrast: Double, brightness: Double) -> ByteImage {
        let result : ByteImage = ByteImage(width:img1.width, height: img1.height)
        for y in 0..<result.height {
            for x in 0..<result.width {
                
                let index = y * result.width + x
                var pixel = result.pixels[index]
                
                let pixel1 = img1.pixels[index]
                pixel.Cf = min( pixel1.Cf * contrast + brightness, 1.0)
                
                result.pixels[index] = pixel
            }
        }
        return result
    }
    
}