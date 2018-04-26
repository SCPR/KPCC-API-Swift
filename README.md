## What Is This?

This is a native Swift tool for accessing the KPCC API.

It was designed to be used with iOS, macOS, watchOS, and tvOS targets. With some work it should also be usable for server-side Swift projects, such as [Vapor](https://vapor.codes/).

## License

This project is licensed under the MIT license.

## Installation

To integrate this framework into your Xcode project, clone (or otherwise download) it onto your development machine and drag the included _KPCCAPIClient.xcodeproj_ file into your project's file navigator in Xcode.

Once you have done so, drag the appropriate framework file from the _Products_ group into the Embedded Binaries section of the targets you wish to build it with. Then make sure to _import_ KPCCAPIClient at the top of any file(s) you wish to use it in.

## Basic Usage

Currently, the KPCC API only supports GET requests, used to retrieve information about the associated resource.

These calls are exposed in this API Client as static methods under the associated model struct (ie, `Program` or `Episode`), each beginning with the word `get` - so, for example, you can type "Program.get" and hit escape to display Xcode's autocompletion popover with methods for retrieving Programs.

A number of examples showing common usage are provided below.

## Model

The model layer exposed by this framework largely mirrors the KPCC server API in order to lessen confusion and make it easier to work with.

For instances of Program, Episode, Article, etc. we highly recommend referring to the server API documentation for further details. The properties for the model layer have been designed to adhere as closely as possible to that provided by the server API.

* [KPCC API v3](https://github.com/SCPR/api-docs/tree/master/KPCC/v3)

## Inline Documentation

Option-clicking any method name will provide 'Quick Help' inline documentation for that method. The same applies to instance properties for model objects such as Program, Episode, etc.

## Debug Level

You can modify the level of verbosity by setting a debug level to one of the following levels: `disabled`, `basic`, or `verbose`.

We recommend setting the debug level to `disabled` (the default) for production code.

```
KPCCAPIClient.shared.debugLevel    = .basic
```

## Retrieving Programs

Retrieve Program objects to get information about KPCC programs.

*Example:* The following method returns an array of both 'On Air' and 'Online Only' type Programs.

```
Program.get { (programs, error) in
    if let programs = programs {
        print(programs)
    }
}
```

*Example:* The following method returns an array of 'Online Only' type Programs.

```
Program.get(programsWithStatuses: [.onlineOnly]) { (programs, error) in
    if let programs = programs {
        print(programs)
    }
}
```

*Example:* The following method returns a Program associated with the '_airtalk_' slug.

```
Program.get(withProgramSlug: "airtalk") { (program, error) in
    if let program = program {
        print(program)
    }
}
```

## Retrieving Episodes

Retrieve Episode objects for individual on-demand episodes of KPCC programs.

*Example:* The following method returns an array _AirTalk_ Episodes.

```
Episode.get(withProgramSlug: "airtalk") { (episodes, error) in
    if let episodes = episodes {
        print(episodes)
    }
}
```

*Example:* The following method returns an array of up to _AirTalk_ Episodes (the first page of results).

```
Episode.get(withProgramSlug: "airtalk", limit: 8, page: 1) { (episodes, error) in
    if let episodes = episodes {
        print(episodes)
    }
}
```

*Example:* The following method an Episode with the ID '_123456_'.

```
Episode.get(withID: 123456) { (episode, error) in
    if let episode = episode {
        print(episode)
    }
}
```

## Retrieving Program Schedules

Retrieve ProgramSchedule objects to get information about what programs are or will be played during within a given span of time.

*Example:* The following method returns a ProgramSchedule starting at Monday of the current week and ending 1 week later.

```
ProgramSchedule.get { (programSchedule, error) in
    if let programSchedule = programSchedule {
        print(programSchedule)
    }
}
```

*Example:* The following method returns a ProgramSchedule starting at the current date and ending in 1 day.

```
ProgramSchedule.get(withStartDate: Date(), length: 86400) { (programSchedule, error) in
    if let programSchedule = programSchedule {
        print(programSchedule)
    }
}
```

## Retrieving Articles

Retrieve Article objects for news articles, blog posts, etc.

*Example:* The following method returns an array of 'Blog' or 'News' type Articles.

```
Article.get(withTypes: [.blogs, .news]) { (articles, error) in
    if let articles = articles {
        print(articles)
    }
}
```

*Example:* The following method returns an array of up to 10 'News' type Articles with the search query '_Steve Jobs_' and matching the tag of '_iphone_'.

```
Article.get(withTypes: [.news], date: nil, startDate: nil, endDate: nil, query: "Steve Jobs", categories: nil, tags: ["iphone"], limit: 20, page: nil) { (articles, error) in
    if let articles = articles {
        print(articles)
    }
}
```

*Example:* The following method returns an Article with a specified ID of '_asdf1234_'.

```
Article.get(withID: "asdf1234") { (article, error) in
    if let article = article {
        print(article)
    }
}
```

## Retrieving Events

Retrieve Event objects for live, in-person KPCC events.

*Example:* The following method returns an array of 'Community Engagement' or 'Town Hall' type Events.

```
Event.get(withTypes: [.communityEnagement, .townHall]) { (events, error) in
    if let events = events {
        print(events)
    }
}
```

*Example:* The following method returns an array of up to 10 Cultural type Events, with a start date starting now and an end date 30 days in the future.

```
Event.get(withTypes: [.cultural], startDate: Date(), endDate: Date().addingTimeInterval(86400 * 30), limit: 10) { (events, error) in
    if let events = events {
        print(events)
    }
}
```

## Retrieving Lists

Retrieve List objects for curated lists of Article, Program, or Episode objects.

*Example:* The following method returns an array of Lists, including those with the supplied context of '_ios_'.

```
List.get(withContext: "ios") { (lists, error) in
    if let lists = lists {
        print(lists)
    }
}
```

*Example:* The following method returns a List with the supplied ID of '_123456_'.

```
List.get(withID: 123456) { (lists, error) in
    if let lists = lists {
        print(lists)
    }
}
```

## Retrieving Members

Retrieve Member object.

*Example:* The following method returns a Member associated with the supplied pledge token '_asdf1234_'.

```
Member.get(withPledgeToken: "asdf1234") { (member, error) in
    if let member = member {
        print(member)
    }
}
```

## Retrieving Settings

Retrieve settings (returned as a Dictionary).

*Example:* The following method returns settings not associated with any context.

```
Settings.get(withContext: nil) { (settings, error) in
    if let settings = settings {
        print(settings)
    }
}
```
