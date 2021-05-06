//
//  Medol.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/05.
//

import Foundation

//class 생성 - Momo
class Memo {
    //메모의 날짜와 내용을 저장할 속성
    //메모내용
    var content: String
    //날짜
    var insertDate: Date
    
    //속성을 초기화 하는 생성자
    init(content: String) {
        self.content = content
        insertDate = Date()
    }
    
    //테이블 뷰에 표시할 데이터를 배열에 미리 저장
    static var dummyMemoList = [
        Memo(content: "Lorem Ipsum"),
        Memo(content: "Subscribe" )
    ]
}
