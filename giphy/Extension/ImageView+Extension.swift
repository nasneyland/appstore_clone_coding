//
//  ImageView+Extension.swift
//  giphy
//
//  Created by najin shin on 4/11/24.
//

import UIKit

class UrlImageView: UIImageView {
    
    var dataTask: URLSessionDataTask?
    
    func gifImageWithURL(_ gifUrl: String) {
        // 캐싱된 이미지 체크
        if let cachedImage = ImageCache.shared.object(forKey: gifUrl as NSString) {
            self.image = cachedImage
            return
        }

        let url = URL(string: gifUrl)
        
        self.dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }

            if let downloadedImage = self.gifImageWithData(data!) {
                ImageCache.shared.setObject(downloadedImage, forKey: gifUrl as NSString) //이미지 캐시 저장
                DispatchQueue.main.async(execute: {
                    self.image = downloadedImage
                })
                
            }
        })
        self.dataTask?.resume()
    }
    
    func cancleLoadingImage() {
        self.dataTask?.cancel()
        self.dataTask = nil
    }
}
    
extension UIImageView {
    
    func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return animatedImageWithSource(source)
    }
    
    private func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = 0.1
            delays.append(Int(delaySeconds * 1000.0))
        }
        
        let duration = delays.reduce(0) { $0 + $1 }
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        return animation
    }
    
    private func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else { return nil }
        let url = URL(fileURLWithPath: path)
        
        guard let gifData = try? Data(contentsOf: url), let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
    
    private func gcdForPair(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a % b
            
            if rest == 0 {
                return b
            } else {
                a = b
                b = rest
            }
        }
    }
    
    private func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        for val in array {
            gcd = gcdForPair(val, gcd)
        }
        
        return gcd
    }
}
