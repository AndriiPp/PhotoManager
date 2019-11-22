import Foundation

enum RequestAPI {
     case getPhotos
     case searchPhotos(query: String)
    
}
extension RequestAPI {
    
    //MARK :- Configuration url
    
    private var queryParams: [URLQueryItem] {
        var params: [URLQueryItem] = []
        params.append(URLQueryItem.init(name: "client_id", value: "4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"))
        params.append(URLQueryItem.init(name: "per_page", value: "18"))
        
        switch self {
        case .getPhotos:
            return params
        case .searchPhotos(let query):
            params.append(URLQueryItem.init(name: "query", value: query))
            return params
        }
    }
    
    private var componect : URLComponents {
        var componects = URLComponents()
        componects.scheme = "https"
        componects.host = "api.unsplash.com"
        
        switch self {
        case .getPhotos:
            componects.path = "/photos"
            componects.queryItems = queryParams
            return componects
        case .searchPhotos:
            componects.path = "/search/photos"
            componects.queryItems = queryParams
            return componects
        }
    }
    
    public var request : URLRequest {
        var request = URLRequest(url: componect.url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
