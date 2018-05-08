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

struct ArticleResponse: Codable {
	var article:Article
}

public enum ArticleRequestType:String, Codable {
	case news		= "news"
	case blogs		= "blogs"
	case segments	= "segments"
	case shells		= "shells"
	case external	= "external"
}

extension Article {
	/// Retrieve most recent articles associated with the (optional) given type(s).
	///
	/// # Example:
	/// Retrieving recent `news` and `blog` type articles:
	/// ```
	/// Article.get(withTypes: [.news, .blogs]) { (articles, error) in
	///     print(articles)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Articles](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/articles.md)
	///
	/// - Parameters:
	///   - types: The type(s) of articles to retrieve. A nil value retrieves articles matching a default set of types (news, blogs, and segments).
	///   - completion: A completion handler containing an array of articles and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withTypes types:[ArticleRequestType]?, completion: @escaping ([Article]?, KPCCAPIError?) -> Void) {
		self.get(withTypes:types, date:nil, startDate:nil, endDate:nil, query:nil, categories:nil, tags:nil, limit: nil, page:nil, completion: completion)
	}

	/// Retrieve most recent articles associated with (optional) type(s), with the option to specify a limit count.
	///
	/// # Example:
	/// Retrieving `news` and `blog` type articles matching the search query "Tim Cook", having the "iPhone" tag and limited to 20 results:
	/// ```
	/// Article.get(withTypes: [.news, .blogs], date: nil, startDate: nil, endDate: nil, query: "Tim Cook", categories: nil, tags: ["iPhone"], limit: 20, page: nil) { (articles, error) in
	///     print(articles)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Articles](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/articles.md)
	///
	/// - Parameters:
	///   - types: The type(s) of articles to retrieve. A nil value retrieves articles matching a default set of types (news, blogs, and segments).
	///   - date: The publish date by which to filter retrieved articles.
	///   - startDate: The earliest date by which to filter articles.
	///   - endDate: The latest date by which to filter articles. Note that startDate must _also_ be specified.
	///   - query: The query to search for (ie. "Tim Cook" or "Apple iPhone").
	///   - categories: The categories associated with the the retrieved articles.
	///   - tags: The tags associated with the the retrieved articles.
	///   - limit: The maximum number of articles to retrieve. A nil value will return the API default, (currently 4).
	///   - page: The page of articles. A nil value will return the first page.
	///   - completion: A completion handler containing an array of articles and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withTypes types:[ArticleRequestType]?, date:Date?, startDate:Date?, endDate:Date?, query:String?, categories:[String]?, tags:[String]?, limit:Int?, page:Int?, completion: @escaping ([Article]?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "articles") else {
			completion(nil, .buildComponentsError)
			return
		}

		var queryItems:[URLQueryItem] = []

		if let types = types {
			var typesString = ""
			for type in types {
				if typesString.count > 0 {
					typesString = typesString + ","
				}
				typesString = typesString + type.rawValue
			}

			queryItems.append(URLQueryItem(name: "types", value: typesString))
		}

		if startDate != nil || endDate != nil {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"

			if let startDate = startDate {
				let startDateString = dateFormatter.string(from: startDate)
				queryItems.append(URLQueryItem(name: "start_date", value: startDateString))
			}

			if let endDate = endDate {
				let endDateString = dateFormatter.string(from: endDate)
				queryItems.append(URLQueryItem(name: "end_date", value: endDateString))

				if startDate == nil {
					// The KPCC API requires a start date to use end_date, if one has not been provided. We'll provide one from the (relatively) distant past... - JAC
					queryItems.append(URLQueryItem(name: "start_date", value: "2001-01-01"))
				}
			}
		}

		if let query = query {
			let queryString = query.trimmingCharacters(in: .whitespacesAndNewlines)
			queryItems.append(URLQueryItem(name: "query", value: queryString))
		}

		if let categories = categories {
			var categoriesString = ""
			for category in categories {
				if categoriesString.count > 0 {
					categoriesString = categoriesString + ","
				}
				categoriesString = categoriesString + category.trimmingCharacters(in: .whitespacesAndNewlines)
			}

			queryItems.append(URLQueryItem(name: "categories", value: categoriesString))
		}

		if let tags = tags {
			var tagsString = ""
			for tag in tags {
				if tagsString.count > 0 {
					tagsString = tagsString + ","
				}
				tagsString = tagsString + tag.trimmingCharacters(in: .whitespacesAndNewlines)
			}

			queryItems.append(URLQueryItem(name: "tags", value: tagsString))
		}

		if let limit = limit {
			queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
		}

		if let page = page {
			components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
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

	/// Retrieve an article by ID.
	///
	/// # Example:
	/// Retrieving an article with the ID of `asdf1234`:
	/// ```
	/// Article.get(withID: "asdf1234") { (articles, error) in
	///     print(articles)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Articles](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/articles.md)
	///
	/// - Parameters:
	///   - articleID: The ID associated with the article being retrieved.
	///   - completion: A completion handler with an article and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withID articleID:String, completion: @escaping (Article?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%@", "articles", articleID)
		guard let components = URLComponents(string: urlComponentString) else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let articleResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ArticleResponse.self, from: data)
					let article			= articleResponse.article

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
