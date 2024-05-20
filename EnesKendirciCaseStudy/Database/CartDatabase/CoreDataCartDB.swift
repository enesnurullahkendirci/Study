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
    private let entityName = "CartItem"

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    func add(product: Product) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])
        }
        let cartItem = NSManagedObject(entity: entity, insertInto: context)

        cartItem.setValue(product.id, forKey: ProductKey.id.rawValue)
        cartItem.setValue(product.name, forKey: ProductKey.name.rawValue)
        cartItem.setValue(product.image, forKey: ProductKey.image.rawValue)
        cartItem.setValue(product.price, forKey: ProductKey.price.rawValue)
        cartItem.setValue(product.description, forKey: ProductKey.description.rawValue)
        cartItem.setValue(product.model, forKey: ProductKey.model.rawValue)
        cartItem.setValue(product.brand, forKey: ProductKey.brand.rawValue)
        cartItem.setValue(product.createdAt, forKey: ProductKey.createdAt.rawValue)
        cartItem.setValue(product.quantity, forKey: ProductKey.quantity.rawValue)

        try context.save()
    }

    func update(product: Product) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let cartItem = objects?.first {
            cartItem.setValue(product.quantity, forKey: ProductKey.quantity.rawValue)
            try context.save()
        }
    }

    func delete(product: Product) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let cartItem = objects?.first {
            context.delete(cartItem)
            try context.save()
        }
    }

    func fetchAll() throws -> [Product] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let result = try context.fetch(fetchRequest) as? [NSManagedObject] ?? []

        return result.map {
            Product(
                id: $0.value(forKey: ProductKey.id.rawValue) as? String,
                name: $0.value(forKey: ProductKey.name.rawValue) as? String,
                image: $0.value(forKey: ProductKey.image.rawValue) as? String,
                price: $0.value(forKey: ProductKey.price.rawValue) as? String,
                description: $0.value(forKey: ProductKey.description.rawValue) as? String,
                model: $0.value(forKey: ProductKey.model.rawValue) as? String,
                brand: $0.value(forKey: ProductKey.brand.rawValue) as? String,
                createdAt: $0.value(forKey: ProductKey.createdAt.rawValue) as? String,
                quantity: $0.value(forKey: ProductKey.quantity.rawValue) as? Int
            )
        }
    }
}
