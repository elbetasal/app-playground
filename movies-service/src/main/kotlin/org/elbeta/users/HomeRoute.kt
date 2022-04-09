package org.elbeta.users
import io.ktor.application.call
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.request.receive
import io.ktor.response.respondText
import io.ktor.routing.post
import jakarta.inject.Singleton
import io.micronaut.ktor.KtorRoutingBuilder
import javax.validation.ConstraintViolationException

@Singleton
class HomeRoute() : KtorRoutingBuilder({
    post("/") {
        val name = call.receive<NameRequest>().name
        try {
            call.respondText("Hello $name", contentType = ContentType.Text.Plain)
        } catch(e: ConstraintViolationException) {
            call.respondText(e.constraintViolations.joinToString(",") { c -> "${c.propertyPath.last().name} ${c.message}" }, contentType = ContentType.Text.Plain, status = HttpStatusCode.UnprocessableEntity)
        }
    }
})
data class NameRequest(val name: String)
