import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "RickAndMorty")
            container.loadPersistentStores { _, error in
                if let error {
                    fatalError("Error al cargar Core Data: \(error)")
                }
            }
            return container
        }()
    func saveContext() {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    fatalError("Error al guardar Core Data: \(error)")
                }
            }
        }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
