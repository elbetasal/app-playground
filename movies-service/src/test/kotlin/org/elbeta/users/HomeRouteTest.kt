package org.elbeta.users

import io.micronaut.http.HttpRequest
import io.micronaut.http.client.HttpClient
import io.micronaut.http.client.annotation.Client
import io.micronaut.runtime.server.EmbeddedServer
import io.micronaut.test.extensions.junit5.annotation.MicronautTest
import jakarta.inject.Inject
import org.junit.Test
import org.junit.jupiter.api.Assertions.*

@MicronautTest
internal class HomeRouteTest {

    @Inject
    lateinit var server: EmbeddedServer

    @Inject
    @Client("/")
    lateinit var client: HttpClient

    @Test
    fun test() {
        val result = client.toBlocking().retrieve(HttpRequest.GET<String>("/"))
        assertEquals(result, "")
    }
}
