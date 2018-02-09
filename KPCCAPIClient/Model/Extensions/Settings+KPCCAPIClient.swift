//
//  KPCC API Client
//
//	Settings+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

extension Settings {
	/// Retrieve settings.
	///
	/// # Example:
	/// Retrieving settings without a context:
	/// ```
	/// Settings.get(withContext:nil) { (settings, error) in
	///    print(settings)
	/// }
	/// ```
	///
	/// - Important: The settings returned from this method are mainly intended for internal KPCC use and are subject to change at any time.
	///
	/// # Reference:
	///   [KPCC API Reference - Settings](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/settings.md)
	///
	/// - Parameters:
	///   - context: An optional context that the settings are associated with. A nil value returns only non-contextual settings.
	///   - completion: A completion handler with a dictionary containing settings and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withContext context:String?, completion: @escaping ([String:Any]?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%@", "settings", context!)
		guard let components = URLComponents(string: urlComponentString) else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					guard let responseDictionary	= try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
						DispatchQueue.main.async {
							completion(nil, .other)
						}
						return
					}

					if let settingsDictionary = responseDictionary["settings"] as? [String:Any] {
						DispatchQueue.main.async {
							completion(settingsDictionary, nil)
						}
					} else {
						DispatchQueue.main.async {
							completion(nil, .other)
						}
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
