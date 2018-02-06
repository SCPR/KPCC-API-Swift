//
//  KPCC API Client
//
//	ScheduleOccurrence
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct ScheduleOccurrence: Codable {
    public var title: String?
	public var publicURL:URL?
	public var dateRange: DateRange	= DateRange(start: Date(), end: Date())
	public var isRecurring: Bool?
	public var program:Program?

    public var normalizedDateRange: DateRange {
        return dateRange.dateRangeByAddingTimeIntervals(start: 0.0, end: -1.0)
    }

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(self.title, forKey: .title)
		try container.encode(self.publicURL, forKey: .publicURL)

		try container.encode(self.dateRange.start, forKey: .startsAt)
		try container.encode(self.dateRange.end, forKey: .endsAt)

		try container.encode(self.isRecurring, forKey: .isRecurring)
		try container.encode(self.program, forKey: .program)
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.title				= try? values.decode(String.self, forKey: .title)
		self.publicURL			= try? values.decode(URL.self, forKey: .publicURL)

		if let startsAt = try? values.decode(Date.self, forKey: .startsAt), let endsAt = try? values.decode(Date.self, forKey: .endsAt) {
			self.dateRange	= DateRange(start: startsAt, end: endsAt)
		}

		self.isRecurring		= try? values.decode(Bool.self, forKey: .isRecurring)
		self.program			= try? values.decode(Program.self, forKey: .program)
	}

	init() {
	}

	enum CodingKeys: String, CodingKey {
		case title				= "title"
		case publicURL			= "public_url"
		case startsAt			= "starts_at"
		case endsAt				= "ends_at"
		case isRecurring		= "is_recurring"
		case program			= "program"
	}
}

extension ScheduleOccurrence: Equatable {
	public static func ==(lhs: ScheduleOccurrence, rhs: ScheduleOccurrence) -> Bool {
		if lhs.dateRange.start.timeIntervalSince1970 == rhs.dateRange.start.timeIntervalSince1970 && lhs.dateRange.end.timeIntervalSince1970 == rhs.dateRange.end.timeIntervalSince1970 {
			return true
		}
		
		return false
	}
}
