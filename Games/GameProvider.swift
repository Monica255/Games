//
//  GameProvider.swift
//  Games
//
//  Created by Monica Sucianto on 29/12/23.
//

import Foundation
import CoreData
import SwiftUI

class GameProvider{
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameModel")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                print("Unresolved error \(error!)")
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    
    func isFavorite(_ id: Int, completion: @escaping(_ isFav: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = GameModel.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
            
            do {
                if let result = try taskContext.fetch(fetchRequest).first{
                    let id2 = result.value(forKeyPath: "id") as? Int
                    if id == id2 {
                        completion(true)
                    }
                }
            } catch let error as NSError {
                completion(false)
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
    func favGame(
        _ favgame:FavGame,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "GameModel", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(favgame.id, forKeyPath: "id")
                game.setValue(favgame.name, forKeyPath: "name")
                game.setValue(favgame.released, forKeyPath: "released")
                game.setValue(favgame.bgImage, forKeyPath: "bgImage")
                game.setValue(favgame.rating, forKeyPath: "rating")
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func deleteFav(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameModel")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
    
    
    func getAllGames(completion: @escaping(_ games: [FavGame]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = GameModel.fetchRequest()
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [FavGame] = []
                for result in results {
                    let game = FavGame(
                        id: result.value(forKeyPath: "id") as? Int ?? 0,
                        name: result.value(forKeyPath: "name") as? String,
                        released: result.value(forKeyPath: "released") as? String,
                        bgImage: result.value(forKeyPath: "bgImage") as? String,
                        rating: result.value(forKeyPath: "rating") as? Double
                    )
                    
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
}
