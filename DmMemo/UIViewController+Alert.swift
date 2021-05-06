//
//  UIViewController+Alert.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/06.
//

import UIKit

extension UIViewController {
    //경고창 제목과 메시지를 받는 메소드 생성
    func alert(title: String = "알림", message: String) {
        //인스턴스 생성
        let alert = UIAlertController(title: title,
                                      message: message,
                                      //경고창 스타일 설정
                                      preferredStyle:
                                        .alert)
        //경고창에 표시될 버튼 생성
        let okAction = UIAlertAction(title: "확인",
                                     //버튼의 스타일 default
                                     style: .default,
                                     //버튼을 클릭했을 때 실행 되는 코드 (없음)
                                     handler: nil)
        //
        alert.addAction(okAction)
        
        //경고창 생성
        present(alert, animated: true, completion: nil)
        
    }
}
