import Vapor
import HTTP
import Foundation

class BlogController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Blog.all().makeNode().converted(to: JSON.self)
    }

    func makeResource() -> Resource<Blog> {
        return Resource(index: index)
    }
}
