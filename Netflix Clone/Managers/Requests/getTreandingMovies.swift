//
//  File.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 03/09/2022.
//

import Foundation

class NetworkLayer{
    
    struct getTreandingMovies: APIRequest{
        typealias Response = TreandingShows
        
        var path: String = "/3/trending/movie/day"
    }

    struct getTreandingTVs: APIRequest{
        typealias Response = TreandingShows
        
        var path: String = "/3/trending/tv/day"
    }


}

