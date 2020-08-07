package org.developer.elbeta

import io.ktor.server.netty.NettyApplicationEngine
import io.micronaut.ktor.KtorApplication
import io.micronaut.ktor.runApplication
import javax.inject.Singleton

@Singleton
class KtorApp : KtorApplication<NettyApplicationEngine.Configuration>({
})

object Application {
    @JvmStatic
    fun main(args: Array<String>) {
        runApplication(args)
    }
}

