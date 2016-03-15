import UIKit

public struct Pixel {
    public var value: UInt32
    
    //red
    public var R: UInt8 {
        get { return UInt8(value & 0xFF) }
        set { value = UInt32(newValue) | (value & 0xFFFFFF00) }
    }
    
    //green
    public var G: UInt8 {
        get { return UInt8((value >> 8) & 0xFF) }
        set { value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF) }
    }
    
    //blue
    public var B: UInt8 {
        get { return UInt8((value >> 16) & 0xFF) }
        set { value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF) }
    }
    
    //alpha
    public var A: UInt8 {
        get { return UInt8((value >> 24) & 0xFF) }
        set { value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF) }
    }
    
    public var Rf: Double {
        get { return Double(self.R) / 255.0 }
        set {
            
            // overflow에 대한 방어 코드를 적어줘야 한다,
            if newValue < 0.0 {
                self.R = 0
            } else if newValue > 1.0 {
                self.R = 255
            } else {
                self.R = UInt8(newValue * 255.0)
            }
        }
    }
    
    public var Gf: Double {
        get { return Double(self.G) / 255.0 }
        set {
            if newValue < 0.0 {
                self.G = 0
            } else if newValue > 1.0 {
                self.G = 255
            } else {
                self.G = UInt8(newValue * 255.0)
            }
        }
    }
    
    public var Bf: Double {
        get { return Double(self.B) / 255.0 }
        set {
            
            if newValue < 0.0 {
                self.B = 0
            } else if newValue > 1.0 {
                self.B = 255
            } else {
                self.B = UInt8(newValue * 255.0)
            }
        }
    }
    
    public var Af: Double {
        get { return Double(self.A) / 255.0 }
        set {
            if newValue < 0.0 {
                self.A = 0
            } else if newValue > 1.0 {
                self.A = 255
            } else {
                self.A = UInt8(newValue * 255.0)
            }
        }
    }
}

public struct RGBAImage {
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        // CGImage로 변환이 가능해야 한다.
        guard let cgImage = image.CGImage else {
            return nil
        }
        
        // 주소 계산을 위해서 Float을 Int로 저장한다.
        width = Int(image.size.width)
        height = Int(image.size.height)
        
        // 4 * width * height 크기의 버퍼를 생성한다.
        let bytesPerRow = width * 4
        let imageData = UnsafeMutablePointer<Pixel>.alloc(width * height)
        
        // 색상공간은 Device의 것을 따른다
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // BGRA로 비트맵을 만든다
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitmapInfo = bitmapInfo | CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        
        // 비트맵 생성
        guard let imageContext = CGBitmapContextCreate(imageData, width, height, 8, bytesPerRow, colorSpace, bitmapInfo) else {
            return nil
        }
        
        // cgImage를 imageData에 채운다.
        CGContextDrawImage(imageContext, CGRect(origin: CGPointZero, size: image.size), cgImage)
        
        // 이미지 화소의 배열 주소를 pixels에 담는다
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    
    public init(width: Int, height: Int) {
        let image = RGBAImage.newUIImage(width: width, height: height)
        self.init(image: image)!
    }
    
    public func clone() -> RGBAImage {
        let cloneImage = RGBAImage(width: self.width, height: self.height)
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                cloneImage.pixels[index] = self.pixels[index]
            }
        }
        return cloneImage
    }
    
    public func toUIImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        let bytesPerRow = width * 4
        
        bitmapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        
        let imageContext = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, 8, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
        guard let cgImage = CGBitmapContextCreateImage(imageContext) else {
            return nil
        }
        
        let image = UIImage(CGImage: cgImage)
        return image
    }
    
    public func pixel(x : Int, _ y : Int) -> Pixel? {
        guard x >= 0 && x < width && y >= 0 && y < height else {
            return nil
        }
        
        let address = y * width + x
        return pixels[address]
    }
    
    public mutating func pixel(x : Int, _ y : Int, _ pixel: Pixel) {
        guard x >= 0 && x < width && y >= 0 && y < height else {
            return
        }
        
        let address = y * width + x
        pixels[address] = pixel
    }
    
    public mutating func process( functor : (Pixel -> Pixel) ) {
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                pixels[index] = functor(pixels[index])
            }
        }
    }
    
    public func enumerate( functor : (Int, Pixel) -> Void) {
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                functor(index, pixels[index])
            }
        }
    }
    
    private static func newUIImage(width width: Int, height: Int) -> UIImage {
        let size = CGSizeMake(CGFloat(width), CGFloat(height));
        UIGraphicsBeginImageContextWithOptions(size, true, 0);
        UIColor.blackColor().setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
    
    
    
    
}

