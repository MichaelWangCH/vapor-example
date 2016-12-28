import Vapor
import Fluent
import Foundation

struct Post: Model {
    var id: Node?
    var title: String
    var markdown: String
    var html: String
    var author: String
    var status: String

    // used by fluent internally
    var exists: Bool = false
    
    init(title: String, markdown: String, html: String, author: String, status: String) {
        self.id = UUID().uuidString.makeNode()
        self.title = title
        self.markdown = markdown
        self.html = html
        self.author = author
        self.status = status
    }

    // NodeInitializable
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        markdown = try node.extract("markdown")
        html = try node.extract("html")
        author = try node.extract("author")
        status = try node.extract("status")
    }

    // NodeRepresentable
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "markdown": markdown,
            "html": html,
            "author": author,
            "status": status
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
