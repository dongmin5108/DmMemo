//
//  DetailViewController.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/06.
//

import UIKit

class DetailViewController: UIViewController {
    
    //메모 편집
    @IBOutlet weak var memoTableView: UITableView!
    
    //메모속성
    var memo: Memo?

    //날짜 출력 데이터포멧
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
    
    //공유해주는 메소드
    @IBAction func share(_ sender: UIBarButtonItem) {
        
        guard let memo = memo?.content else { return }
        
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
        
        if let pc = vc.popoverPresentationController {
            pc.barButtonItem = sender
        }
    }
    
    //삭제버튼
    @IBAction func deleteMemo(_ sender: Any) {
        //메모 삭제확인을 위한 메시지 출력
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제 할까요?", preferredStyle: .alert)
        
        //삭제를 클릭 했을 시
        //destructuive = 빨간색으로 출력됨
        let okAction = UIAlertAction(title: "삭제" , style: .destructive) { [weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo)
            self?.navigationController?.popViewController(animated: true)
            
        }
        alert.addAction(okAction)
        
        //취소를 클릭 했을 시
        //경고창을 닫는 코드는 직접구현하지 않아도 됨
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        //경고창 화면에 표시
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    var token: NSObjectProtocol?
    
    //옵저버 해제
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //옵저버 추가
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.memoTableView.reloadData()
        })

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

extension DetailViewController:
    UITableViewDataSource {
    //테이블 뷰가 셀 갯수를 물어볼때 호출하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //테이블 뷰가 어떤 셀을 표시할지 물어볼 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //dequeueReusableCell 메소드 호출
            let cell = tableView
                .dequeueReusableCell(
                //memoCell 전달
                withIdentifier: "memoCell",
                for: indexPath)
            
            //첫번째 셀 메모 표시
            cell.textLabel?.text = memo?.content
            
            //리턴
            return cell
            
        case 1:
            //dequeueReusableCell 메소드 호출
            let cell = tableView
                .dequeueReusableCell(
                //memoCell 전달
                withIdentifier: "dateCell",
                for: indexPath)
            
            //두번째 셀 날짜 표시
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            
            //리턴
            return cell
            
        default:
            fatalError()
        }
    }
}


