//
//  MyTodo.swift
//  MyTodoList
//
//  Created by Naoki on 2022/07/30.
//

import Foundation

class MyTodo: NSObject, NSSecureCoding{
    
    //ToDoのタイトル
    var todoTitle: String?
    //ToDoを完了したかどうかを表すフラグ
    var todoDone: Bool = false
    //コンストラクタ
    override init(){
    }
    
    static var supportsSecureCoding: Bool{
        return true
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(todoTitle,forKey: "todoTitle")
        coder.encode(todoDone,forKey: "todoDone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
}
