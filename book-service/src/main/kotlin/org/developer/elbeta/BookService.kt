package org.developer.elbeta

import javax.inject.Singleton

@Singleton
class BookService {

    private var books = mutableListOf(
        Book("ISBN1", "Harry Potter")
    )

    fun books() = books

}

data class Book(var isbn: String, var title: String)
