package org.elbeta.inventory

import org.springframework.stereotype.Repository

@Repository
class CatalogRepository {
    val items : List<String> = listOf("ITEM1", "ITEM2")

    fun find() = items

}
