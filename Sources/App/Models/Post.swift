import Vapor
import Fluent
import Foundation

struct Post: Model {
  var id: Node?
  var uuid: String
  var title: String
  var markdown: String
  var html: String
  var status: String
  var language: String

  var createdAt: Date?
  var createdBy: Int
  var updatedAt: Date?
  var updatedBy: Int
  var publishedAt: Date?
  var publishedBy: Int?
  var author: Int
  var url: String

  // used by fluent internally
  var exists: Bool = false

  init(title: String, markdown: String, html: String, status: String, language: String,
       createdAt: Date, createdBy: Int, updatedAt: Date, updatedBy: Int,
       publishedAt: Date?, publishedBy: Int?, author: Int, url: String) {
    self.id = nil
    self.uuid = UUID().uuidString
    self.title = title
    self.markdown = markdown
    self.html = html
    self.status = status
    self.language = language

    self.createdAt = createdAt
    self.createdBy = createdBy
    self.updatedAt = updatedAt
    self.updatedBy = updatedBy
    self.publishedAt = publishedAt
    self.publishedBy = publishedBy
    self.author = author
    self.url = url
  }

  // NodeInitializable
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    uuid = try node.extract("uuid")
    title = try node.extract("title")
    markdown = try node.extract("markdown")
    html = try node.extract("html")
    status = try node.extract("status")
    language = try node.extract("language")

    createdAt = try node.extract("created_at", transform: Date.fromTimestamp)
    createdBy = try node.extract("created_by")
    updatedAt = try node.extract("updated_at", transform: Date.fromTimestamp)
    updatedBy = try node.extract("updated_by")
    publishedAt = try node.extract("published_at", transform: Date.fromTimestamp)
    publishedBy = try node.extract("published_by")
    author = try node.extract("author")
    url = try node.extract("url")
  }

  // NodeRepresentable
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "uuid": uuid,
      "title": title,
      "markdown": markdown,
      "html": html,
      "status": status,
      "language": language,
      "created_at": createdAt?.toString(),
      "created_by": createdBy,
      "updated_at": updatedAt?.toString(),
      "updated_by": updatedBy,
      "published_at": publishedAt?.toString(),
      "published_by": publishedBy,
      "author": author,
      "url": url
      ])
  }
}

extension Post: Preparation {
  static func prepare(_ database: Database) throws {
    //
  }

  static func revert(_ database: Database) throws {
    //
  }
}

extension Date {
  static var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    return dateFormatter
  }

  static func fromTimestamp(_ timestamp: String?) -> Date? {
    guard let timestamp = timestamp else {
      return nil
    }

    return dateFormatter.date(from: timestamp)
  }

  func toString() -> String? {
    return Date.dateFormatter.string(from: self)
  }
}
