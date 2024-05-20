//
//  CoreDataFavoriteDB.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import UIKit
import CoreData

class CoreDataFavoriteDB: FavoriteDBStrategy {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    func toggle(product: Product) throws {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteItem")
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let objects = objects, !objects.isEmpty {
            objects.forEach { context.delete($0) }
        } else {
            guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteItem", in: context) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])
            }
            let favoriteItem = NSManagedObject(entity: entity, insertInto: context)

            favoriteItem.setValue(product.id, forKey: "id")
            favoriteItem.setValue(product.name, forKey: "name")
            favoriteItem.setValue(product.image, forKey: "image")
            favoriteItem.setValue(product.price, forKey: "price")
            favoriteItem.setValue(product.description, forKey: "desc")
            favoriteItem.setValue(product.model, forKey: "model")
            favoriteItem.setValue(product.brand, forKey: "brand")
            favoriteItem.setValue(product.createdAt, forKey: "createdAt")
        }

        // Değişiklikleri kaydet
        try context.save()
    }

    func fetchAll() throws -> [Product] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteItem")
        let result = try context.fetch(fetchRequest) as? [NSManagedObject] ?? []

        return result.map {
            Product(
                id: $0.value(forKey: "id") as? String,
                name: $0.value(forKey: "name") as? String,
                image: $0.value(forKey: "image") as? String,
                price: $0.value(forKey: "price") as? String,
                description: $0.value(forKey: "desc") as? String,
                model: $0.value(forKey: "model") as? String,
                brand: $0.value(forKey: "brand") as? String,
                createdAt: $0.value(forKey: "createdAt") as? String
            )
        }
    }
}
