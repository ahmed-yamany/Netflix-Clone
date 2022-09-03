//
//  File.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 03/09/2022.
//

import Foundation
import UIKit

class NetworkLayer{
    // MARK: - TreandingMovies
    struct getTreandingMovies: APIRequest{
        typealias Response = TreandingShows
        
        var path: String = "/3/trending/movie/day"
    }
    
    // MARK: - TreandingTVs
    struct getTreandingTVs: APIRequest{
        typealias Response = TreandingShows
        
        var path: String = "/3/trending/tv/day"
    }
    
    // MARK: - UpcomingMovies
    struct getUpcomingMovies: APIRequest{
        typealias Response = TreandingShows
        
        var path: String = "/3/movie/upcoming"
        
        var queryItems: [URLQueryItem]? = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
    }
    
    // MARK: - PopularMovies
    struct getPopularMovies: APIRequest{
        typealias Response = TreandingShows
        
        var path: String = "/3/movie/popular"
        
        var queryItems: [URLQueryItem]? = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
    }
    
    // MARK: - TopRatedMovies
    struct getTopRatedMovies: APIRequest{
        typealias Response = TreandingShows
        
        var path: String = "/3/movie/top_rated"
        
        var queryItems: [URLQueryItem]? = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
    }
    
    struct getImage: APIRequest{
        typealias Response = UIImage

        var path: String
        
        var host:String = "image.tmdb.org"
        
        init(path:String){
            self.path = "/t/p/w500/\(path)"
            
            
        }
        
        
    }

    


}
