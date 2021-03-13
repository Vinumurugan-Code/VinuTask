//
//  APIService.swift
//  VinuTask
//
//  Created by Vinu on 12/03/21.
//
import Foundation
import UIKit

let imageUrl = "https://dummyimage.com/100x100/000/fff.png&text="

enum HTTPMethod: String {
    case GET
    case POST
}

class APIService: NSObject {
    
    static let shared = APIService()
    
    let session = URLSession(configuration: .default)
    
    func getResponse<T:Decodable>(_ method:HTTPMethod? = .GET ,pageNo:Int ,responseType: T.Type, completionHandler: @escaping(Result<T,Error>) -> Void) {
        
        var request = URLRequest(url:URL(string:"https://jsonplaceholder.typicode.com/posts/\(pageNo)/comments")!)
                                
        request.httpMethod = method?.rawValue
            
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let dataObj = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(dataObj))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            }
        }.resume()
    }
}
 

extension UIView {
    
    static var imageCatch:NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode, completion: @escaping(UIImage?) -> Void) {
        if let imageV = UIView.imageCatch.object(forKey: NSString.init(string: link)) {
            completion(imageV)
            return
        }
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    if let imageV = UIImage(data: data) {
                        UIView.imageCatch.setObject(imageV, forKey: NSString.init(string: link))
                        completion(imageV)
                        return
                    }
                    completion(nil)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        }).resume()
    }
}
