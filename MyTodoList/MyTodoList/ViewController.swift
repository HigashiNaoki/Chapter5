//
//  ViewController.swift
//  MyTodoList
//
//  Created by Naoki on 2022/07/10.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var todoList = [MyTodo]()
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data
        {
            do{
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(
                    ofClasses: [NSArray.self, MyTodo.self],
                    from: storedTodoList) as? [MyTodo]
                {
                    todoList.append(contentsOf: unarchiveTodoList)
                }
            }catch{
                //処理なし
            }
        }
    }

    @IBAction func tapAddButton(_ sender: Any) {
        //アラートダイアログを生成
        let alertController = UIAlertController(title:"ToDo追加",message:"Todoを追加してください",preferredStyle: UIAlertController.Style.alert)
        
        //テキストエリアを追加
        alertController.addTextField(configurationHandler: nil)
        
        //OKボタンを追加
        let okAction = UIAlertAction(title:"OK",style: UIAlertAction.Style.default){(action:UIAlertAction) in
            //OKボタンがタップされた時の処理
            if let textField = alertController.textFields?.first{
                //ToDoの配列に入力値を挿入。先頭に挿入する
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo,at: 0)
                //テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row:0,section:0)], with: UITableView.RowAnimation.right)
                
                // ToDoの保存処理
                let userDefaults = UserDefaults.standard
                //Data型にシリアライズする
                do{
                    let data = try NSKeyedArchiver.archivedData(
                        withRootObject: self.todoList, requiringSecureCoding: true)
                    userDefaults.set(data,forKey: "todoList")
                    userDefaults.synchronize()
                }catch{
                    //処理なし
                }
            }
        }
        
        //OKボタンがタップされた時の処理
        alertController.addAction(okAction)
        //CANCELボタンがタップされた時の処理
        let cancelBotton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        //CANCELボタンを追加
        alertController.addAction(cancelBotton)
        
        //アラートダイアログを表示
        present(alertController,animated: true,completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //ToDoの配列の長さを返却する
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //StoryBoardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        //行番号にあったToDoの情報を取得
        let myTodo = todoList[indexPath.row]
        //セルのラベルにTodoのタイトルをセット
        cell.textLabel?.text = myTodo.todoTitle
        //セルのチェックマーク状態をセット
        if myTodo.todoDone{
            //チェックあり
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            //チェックなし
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        if myTodo.todoDone{
            //完了済みの場合は未完了に変更
            myTodo.todoDone = false
        }else{
            //未完了の場合は完了済みに変更
            myTodo.todoDone = true
        }
        
        //セルの状態を変更
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        //データ保存。Data型にシリアライズする
        do{
            let data:Data = try NSKeyedArchiver.archivedData(withRootObject: todoList, requiringSecureCoding: true)
                //UserDefaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data,forKey: "todoList")
            userDefaults.synchronize()
        }catch{
            //処理なし
        }
    }
}

