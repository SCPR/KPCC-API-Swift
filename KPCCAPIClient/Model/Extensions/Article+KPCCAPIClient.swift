//
//  KPCC API Client
//
//	Article+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct ArticlesResponse: Codable {
	var articles:[Article]	= []
}

extension Article {
	public static func get(withTypes types:String?, limit:Int? = 8, completion: @escaping ([Article]?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "articles") else {
			completion(nil, .buildComponentsError)
			return
		}

		var queryItems:[URLQueryItem] = []

		if let limit = limit {
			queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
		}

		if let types = types {
			queryItems.append(URLQueryItem(name: "types", value: types))
		}

		components.queryItems = queryItems

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let articlesResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ArticlesResponse.self, from: data)
					let articles			= articlesResponse.articles
					
					DispatchQueue.main.async {
						completion(articles, nil)
					}
				} catch let foo as DecodingError {
					print("foo = \(foo)")
					DispatchQueue.main.async {
						completion(nil, .decodingError)
					}
				} catch {
					DispatchQueue.main.async {
						completion(nil, .other)
					}
				}
			} else {
				DispatchQueue.main.async {
					completion(nil, .dataUnavailable)
				}
			}
		}
	}

	public static func get(withID articleID:String, completion: @escaping (Article?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%@", "articles", articleID)
		guard let components = URLComponents(string: urlComponentString) else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let article	= try KPCCAPIClient.shared.jsonDecoder.decode(Article.self, from: data)

					DispatchQueue.main.async {
						completion(article, nil)
					}
				} catch _ as DecodingError {
					DispatchQueue.main.async {
						completion(nil, .decodingError)
					}
				} catch {
					DispatchQueue.main.async {
						completion(nil, .other)
					}
				}
			} else {
				DispatchQueue.main.async {
					completion(nil, .dataUnavailable)
				}
			}
		}
	}
}
