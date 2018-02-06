//
//  KPCC API Client
//
//	Developer(s): Jeff A. Campbell, Christopher Fuller
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

private let localeIdentifier	= "en_US_POSIX"
private let dateFormat			= "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

extension Date {
	fileprivate static let ISO8601StringFromDateFormatter: DateFormatter = {
		var dateFormatter			= DateFormatter()
		dateFormatter.locale		= Locale(identifier: localeIdentifier)
		dateFormatter.timeZone		= TimeZone(secondsFromGMT: 0)
		dateFormatter.dateFormat	= dateFormat

		return dateFormatter
	}()

	fileprivate static let ISO8601DateFromStringFormatter: DateFormatter = {
		var dateFormatter			= DateFormatter()
		dateFormatter.locale		= Locale(identifier: localeIdentifier)
		dateFormatter.timeZone		= TimeZone.autoupdatingCurrent
		dateFormatter.dateFormat	= dateFormat

		return dateFormatter
	}()

	var ISO8601StringFromDateFormatterISO8601StringFromDateFormatter: String {
		return Date.ISO8601StringFromDateFormatter.string(from: self)
	}

	init?(ISO8601String string: String) {
		guard let date = Date.ISO8601DateFromStringFormatter.date(from: string) else {
			return nil
		}

		self.init(timeInterval: 0, since: date)
	}
}
