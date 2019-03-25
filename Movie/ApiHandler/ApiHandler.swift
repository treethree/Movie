//
//  ApiHandler.swift
//  Movie
//
//  Created by SHILEI CUI on 3/21/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

var urlString1 : String?

import Foundation
import UIKit

class Apihandler: NSObject {
    static let  sharedInstance = Apihandler()
    private override init() {}
    
    func getApiForMovies(searchQuery : String, page : Int,completion: @escaping (_ arrayMovie: [Result]?, _ error: Error?) -> Void){
        urlString1 = "https://api.themoviedb.org/3/search/movie?api_key=666aa825f0d99807924178bbc46fe117&language=en-US&query=\(searchQuery)&page=\(page)&include_adult=false"
        
        let url = URL(string: urlString1!)
        URLSession.shared.dataTask(with : url!){ (data, response, error) in
                    if error == nil{
                        do{
                            let welcome = try? JSONDecoder.init().decode(Welcome.self, from: data!)
                                 completion(welcome?.results,nil)
                        }
                        catch{
                            completion(nil,error)
                        }
                    }
            }.resume()
    }
}

