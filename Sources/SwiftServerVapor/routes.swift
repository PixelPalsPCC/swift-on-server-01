import Fluent
import Vapor
func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
        //http://localhost:8080/
    }
    app.get("hello") { req async -> String in
        "Hello, world!"
        // http://localhost:8080/hello
    }
    app.get("hello", ":name") { req async throws -> String in
        let name = try req.parameters.require("name")
        //http://localhost:8080/hello/george
        return "Hello, \(name.capitalized)!"
    }
    app.get("json", ":name") { req async throws -> UserResponse in
        let name = try req.parameters.require("name")
        let message = "Hello, \(name.capitalized)!"
        //http://localhost:8080/json/george
        return UserResponse(message: message)
    }
    app.post("user-info") { req async throws -> UserResponse in
        // 2
        let userInfo = try req.content.decode(UserInfo.self)
        // 3
        let message = "Hello, \(userInfo.name.capitalized)! You are \(userInfo.age) years old."
        /*
            curl http://localhost:8080/user-info -X POST -d '{"name": "Tim", "age": 99}' 
               -H "Content-Type: application/json"
               {"message":"Hello, Tim! You are 99 years old."}
        */
        return UserResponse(message: message)
    }
    try app.register(collection: TodoController())
}
struct UserResponse: Content {
    let message: String
}
struct UserInfo: Content {
    let name: String
    let age: Int
}
