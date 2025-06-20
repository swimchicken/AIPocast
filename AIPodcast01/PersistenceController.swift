import CoreData

struct PersistenceController {
    // 單例模式
    static let shared = PersistenceController()
    
    // 預覽用的記憶體儲存
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // 建立測試資料
        // 注意：這裡先註解掉，等建立好 Entity 後再啟用
        /*
        let newPodcast = Podcast(context: viewContext)
        newPodcast.title = "測試播客"
        newPodcast.timestamp = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("預覽資料錯誤: \(nsError)")
        }
        */
        return result
    }()
    
    // Core Data 容器
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        // 注意：這裡的名稱必須與您的 .xcdatamodeld 檔案名稱一致
        container = NSPersistentContainer(name: "AIPodcast")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data 載入失敗: \(error), \(error.userInfo)")
            }
        }
        
        // 自動合併變更
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
