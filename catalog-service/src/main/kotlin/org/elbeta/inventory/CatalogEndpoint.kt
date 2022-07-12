package org.elbeta.inventory

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/catalog")
class CatalogEndpoint(var catalog: CatalogRepository) {

    @GetMapping("/")
    fun findAll() = catalog.find()

}
