//
//  CoreDataCartDB.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import CoreData
import UIKit

class CoreDataCartDB: CartDBStrategy {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    func insert(product: Product) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let cartItem = objects?.first {
            let currentQuantity = cartItem.value(forKey: "quantity") as? Int16 ?? 0
            cartItem.setValue(currentQuantity + 1, forKey: "quantity")
        } else {
            guard let entity = NSEntityDescription.entity(forEntityName: "CartItem", in: context) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])
            }
            let cartItem = NSManagedObject(entity: entity, insertInto: context)

            cartItem.setValue(product.id, forKey: "id")
            cartItem.setValue(product.name, forKey: "name")
            cartItem.setValue(product.image, forKey: "image")
            cartItem.setValue(product.price, forKey: "price")
            cartItem.setValue(product.description, forKey: "desc")
            cartItem.setValue(product.model, forKey: "model")
            cartItem.setValue(product.brand, forKey: "brand")
            cartItem.setValue(product.createdAt, forKey: "createdAt")
            cartItem.setValue(1, forKey: "quantity")
        }

        try context.save()
    }

    func delete(product: Product) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let cartItem = objects?.first {
            let currentQuantity = cartItem.value(forKey: "quantity") as? Int16 ?? 0
            if currentQuantity > 1 {
                cartItem.setValue(currentQuantity - 1, forKey: "quantity")
            } else {
                context.delete(cartItem)
            }
            try context.save()
        }
    }

    func fetchAll() throws -> [Product] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
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
                createdAt: $0.value(forKey: "createdAt") as? String,
                quantity: $0.value(forKey: "quantity") as? Int
            )
        }
    }
}
