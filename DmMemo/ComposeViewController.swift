//
//  ComposeViewController.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/06.
//

import UIKit

class ComposeViewController: UIViewController {
    
    //Cancel을 누르면 취소되는 메소드
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //텍스트 뷰창
    @IBOutlet weak var memoTextView: UITextView!
    
    //save 버튼을 누르면 저장되는 메소드
    @IBAction func save(_ sender: Any) {
        
        guard let memo = memoTextView.text,
              memo.count > 0 else {
            //메모를 입력하지 않으면 알람 생성
            alert(message: "메모를 입력하세요.")
            return
        }
        
        //메모 인스턴스 생성
        let newMemo = Memo(content: memo)
        
        Memo.dummyMemoList.append(newMemo)
        //화면을 닫기 전에 Notification 생성
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        
        //메모창 닫기
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
