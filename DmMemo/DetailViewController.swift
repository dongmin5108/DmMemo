//
//  DetailViewController.swift
//  DmMemo
//
//  Created by Walter yun on 2021/05/06.
//

import UIKit

class DetailViewController: UIViewController {

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
            //리턴
            return cell
            
        case 1:
            //dequeueReusableCell 메소드 호출
            let cell = tableView
                .dequeueReusableCell(
                //memoCell 전달
                withIdentifier: "dateCell",
                for: indexPath)
            //리턴
            return cell
            
        default:
            fatalError()
        }
    }
}

