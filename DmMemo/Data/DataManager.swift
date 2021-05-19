//
//  DataManager.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/12.
//

import Foundation
import CoreData

//DB 저장 구현4
class DataManager {
    //프로퍼티 (앱 전체에서 하나의 데이터를 공유할수 있음)
    static let shared = DataManager()
    private init() {
        // 싱글톤
        
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //배열
    var memoList = [Memo]()
    
    //데이터를 데이터베이스에서 읽어오는 fetchrequest
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate",
                                              ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        //데이터를 가져오기
        
        do {
            memoList = try mainContext.fetch(request)

        } catch {
            print(error)
        }
        
   
    }
    
    func addNewMemo(_ memo: String?) {
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        //저장할 메모를 리스트에 입력
        memoList.insert(newMemo, at: 0)
        
        saveContext()
        
    }
    
    //삭제 메소드 구현
    func deleteMemo(_ memo: Memo?) {
        if let memo = memo {
            mainContext.delete(memo)
            saveContext()
        }
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DmMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
