//
//  MemoListTableViewController.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/05.
//

import UIKit
 
class MemoListTableViewController: UITableViewController {
    //날짜 출력
    let formatter: DateFormatter = {
        let f = DateFormatter()
        //날짜 스타일
        f.dateStyle = .long
        //시간 스타일
        f.timeStyle = .short
        //국가,언어 설정
        f.locale = Locale(identifier: "Ko_kr")
        //리턴
        return f
    }()
    
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.shared.fetchMemo()
        tableView.reloadData()
        
         
        //reloadData : 데이터소스가 전달해주는 최신 데이터로 업로드
        //tableView.reloadData()
        //출력
        //print(#function)
    }
    
    //옵저버를 해제할때 사용하는 객체 리턴 (token)
    var token: NSObjectProtocol?
    
    //소멸자
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath =
            tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //notification에서 ComposeViewController 사용
       token = NotificationCenter.default.addObserver(
            forName: ComposeViewController.newMemoDidInsert,
            object: nil,
            //UI업데이트는 무조건 메인 스레드에서 수행
            queue: OperationQueue.main) { [weak self] (noti) in self?.tableView.reloadData()
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let target = DataManager.shared.memoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(for: target.insertDate)
        
        if #available(iOS 11.0, *){
        cell.detailTextLabel?.textColor = UIColor(named: "MyLabelColor")
        } else {
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        return cell  
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
        
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let target = DataManager.shared.memoList[indexPath.row]
            //deleteMemo를 호출하면 DB에서 메모가 삭제됨
            DataManager.shared.deleteMemo(target)
            //배열에서도 삭제
            DataManager.shared.memoList.remove(at: indexPath.row)
            
            //테이블 뷰에서 셀을 삭제 (메모 리스트 배열)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
