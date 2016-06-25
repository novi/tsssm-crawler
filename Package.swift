import PackageDescription

let package = Package(
    name: "tsssm_crawler",
    dependencies: [
        .Package(url: "https://github.com/novi/mysql-swift.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/IBM-Swift/BlueSocket.git", majorVersion: 0, minor: 5),
    ],
    exclude: ["Xcode", "Sources/CrawlerManager"],
    targets: [
                Target(name: "RSSCrawler", dependencies: ["CrawlerBase", "CrawlerConfig"]),
                 Target(name: "CrawlerBase"),
                 Target(name: "CrawlerConfig")
                 ]
)
