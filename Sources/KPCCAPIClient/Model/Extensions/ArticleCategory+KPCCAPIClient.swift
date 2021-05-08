//
//  KPCC API Client
//
//	Category+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct CategoriesResponse: Codable {
	var categories:[ArticleCategory]	= []
}

struct CategoryResponse: Codable {
	var category:ArticleCategory
}

extension ArticleCategory {
	/// Retrieve all available categories.
	///
	/// # Example:
	/// Retrieving all categories:
	/// ```
	/// Category.get() { (categories, error) in
	///     print(categories)
	/// }
	/// ```
	/// - Parameters:
	///   - completion: A completion handler with categories and/or an error.
	///
	/// # Reference:
	///   [KPCC API Reference - Articles](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/categories.md)
	///
	/// - Author: Jeff Campbell
	public static func get(completion: @escaping ([ArticleCategory]?, KPCCAPIError?) -> Void) {
		guard let components = URLComponents(string: "categories") else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let categoriesResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(CategoriesResponse.self, from: data)
					let categories			= categoriesResponse.categories

					completion(categories, nil)
				} catch _ as DecodingError {
					completion(nil, .decodingError)
				} catch {
					completion(nil, .other)
				}
			} else {
				completion(nil, .dataUnavailable)
			}
		}
	}

	/// Retrieve a category by slug.
	///
	/// # Example:
	/// Retrieving a category with a slug of `health`:
	/// ```
	/// Article.get(withSlug: "health") { (category, error) in
	///     print(category)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Articles](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/categories.md)
	///
	/// - Parameters:
	///   - slug: The slug associated with the category being retrieved.
	///   - completion: A completion handler with a category and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withSlug slug:String, completion: @escaping (ArticleCategory?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%@", "categories", slug)
		guard let components = URLComponents(string: urlComponentString) else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let categoryResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(CategoryResponse.self, from: data)
					let category			= categoryResponse.category

					completion(category, nil)
				} catch _ as DecodingError {
					completion(nil, .decodingError)
				} catch {
					completion(nil, .other)
				}
			} else {
				completion(nil, .dataUnavailable)
			}
		}
	}
}
