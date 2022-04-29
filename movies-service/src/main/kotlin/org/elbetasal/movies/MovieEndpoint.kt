package org.elbetasal.movies

import io.ktor.application.*
import io.ktor.http.*
import io.ktor.response.*
import io.ktor.routing.*
import io.micronaut.ktor.KtorRoutingBuilder
import jakarta.inject.Singleton

@Singleton
class MovieEndpoint : KtorRoutingBuilder({
        get("/movies") {
            call.respondText("This is suppose to be a movie or not", contentType = ContentType.Text.Plain)

        }

})
