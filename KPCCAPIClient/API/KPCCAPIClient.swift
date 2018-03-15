//
//  KPCC API Client
//
//	Client for KPCC API v3.
//
//	Repository/Code Documentation:
//	  - https://github.com/SCPR/KPCC-API-Swift
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

/**
	API retrieval/decoding errors.
*/
public enum KPCCAPIError: Error {
	case buildComponentsError
	case decodingError
	case dataUnavailable
	case other
}

/**
	API Client for KPCC API v3.
*/
public class KPCCAPIClient {
	/**
	A centralized client for communicating with the KPCC API (v3).
	*/

	public enum DebugLevel: String {
		/// Display no debugging output.
		case disabled

		/// Display only basic/minimal debugging output.
		case basic

		/// Display all available debugging output.
		case verbose
	}

	/// The level of debugging output to display.
	public var debugLevel:DebugLevel = .disabled

	fileprivate var urlSession: URLSession = {
		return URLSession(configuration: URLSessionConfiguration.default)
	}()

	fileprivate var baseURL: URL?	= URL(string: "https://www.scpr.org/api/v3/")

	let jsonDecoder: JSONDecoder
	let jsonEncoder: JSONEncoder

	init() {
		let dateFormatter					= DateFormatter()
		dateFormatter.dateFormat			= "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

		// JSON Decoder...
		let jsonDecoder						= JSONDecoder()
		jsonDecoder.dateDecodingStrategy	= .formatted(dateFormatter)
		self.jsonDecoder					= jsonDecoder

		// JSON Encoder...
		let jsonEncoder						= JSONEncoder()
		jsonEncoder.dateEncodingStrategy	= .formatted(dateFormatter)
		self.jsonEncoder					= jsonEncoder
	}
}

extension KPCCAPIClient {
	public static let shared = KPCCAPIClient()
}

extension KPCCAPIClient {
	internal func get(withURLComponents urlComponents: URLComponents, completion: @escaping (Data?, KPCCAPIError?) -> Void) {
		if let url = urlComponents.url(relativeTo: self.baseURL) {
			if self.debugLevel != .disabled {
				print("KPCC API - get \(url.absoluteString)")
			}

			let myActivity = ProcessInfo.processInfo.beginActivity(options: ProcessInfo.ActivityOptions.background, reason: "KPCC API")
			print("Created Activity...")

			let dataTask = urlSession.dataTask(with: url) { data, _, _ in
				print("Data Task Complete...")
				if let data = data {
					if self.debugLevel == .basic || self.debugLevel == .verbose {
						if let dataString = String(bytes: data, encoding: .utf8) {
							print("KPCC API - data \(dataString)")
						}
					}

					completion(data, nil)
				} else {
					completion(nil, .dataUnavailable)
				}

				ProcessInfo.processInfo.endActivity(myActivity)
				print("Ended Activity...")
			}
			dataTask.resume()
		} else {
			completion(nil, .buildComponentsError)
		}
	}
}
