package org.developer.elbeta

import io.ktor.application.call
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.request.receive
import io.ktor.response.respond
import io.ktor.response.respondText
import io.ktor.routing.get
import io.ktor.routing.post
import javax.inject.Singleton
import io.micronaut.ktor.KtorRoutingBuilder
import javax.validation.ConstraintViolationException

@Singleton
class HomeRoute(private val bookService: BookService) : KtorRoutingBuilder({
    get("/") {
        call.respondText("Ok")
    }
    get("/book") {
        call.respond(bookService.books())
    }
})
