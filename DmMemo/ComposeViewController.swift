//
//  ComposeViewController.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/06.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    var originalMemoContent: String?
    
    
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
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            DataManager.shared.addNewMemo(memo)
            //화면을 닫기 전에 Notification 생성
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
            
        }
        

        //메모창 닫기
        dismiss(animated: true, completion: nil)
    }
    
    var willShowToken : NSObjectProtocol?
    var willHideToken : NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
            
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }

        memoTextView.delegate = self
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            //notification으로 전달된 값으로 높이값을 구함
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?
                NSValue {
                //height 속성에 키보드 높이
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                //변경한 inset을 content inset에 저장
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
                
            }
        })
        
        //키보드가 사라질때 여백을 제거하는 코드
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //메모장을 클릭했을시 키보드를 바로 출력
        memoTextView.becomeFirstResponder()
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //입력포커스가 제거되고 키보드가 사라짐
        memoTextView.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil
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

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집할 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self]
            (action) in
            self?.save(action)
        }
        alert.addAction(okAction)
        
        //취소
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self]
            (action) in
            self?.close(action)
        }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
         
    }
}

//notification 이름 설정
extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
