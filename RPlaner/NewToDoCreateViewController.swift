//
//  NewToDoCreateViewController.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit

class NewToDoCreateViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate {
    struct Component {
        
        enum Section: Int {
            case days = 0
            case completeOption = 1
        }
        
        static let completeOption = ["동안", "내내"]
        static let pickOption = ["1", "2", "3", "4", "5", "6", "7"]
    }
    
    var todo: ToDo? = nil
    enum State: String {
        case Update = "수정"
        case Create = "생성"
    }
    var state: State = .Create
    
    @IBOutlet weak var todoMemo: UITextView!
    @IBOutlet weak var todoCompleteOptionTextField: UITextField!
    @IBOutlet weak var todoDaysTextField: UITextField!
    @IBOutlet weak var todoTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todoMemo.layer.borderWidth = 1.0
        self.todoMemo.layer.borderColor = UIColor.black.cgColor
        todoCompleteOptionTextField.text = "동안"
        todoDaysTextField.delegate = self
        todoTitleTextField.delegate = self
        todoMemo.delegate = self
        let deadLineNumberPicker = UIPickerView()
        deadLineNumberPicker.delegate = self
        deadLineNumberPicker.dataSource = self
        todoDaysTextField.delegate = self
        todoDaysTextField.text = "3"
        todoDaysTextField.textAlignment = NSTextAlignment.center
        
        
        todoDaysTextField.inputView = deadLineNumberPicker
        todoCompleteOptionTextField.inputView = deadLineNumberPicker
        
        let pickerView = UIPickerView(frame: CGRect(x : 0,y: 200, width : view.frame.width, height : 300))
        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        pickerView.selectRow(2, inComponent: Component.Section.days.rawValue, animated: false)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 122.0/255, blue: 255.0/255, alpha: 1.0)
        
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(NewToDoCreateViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        todoDaysTextField.inputAccessoryView = toolBar
        todoCompleteOptionTextField.inputAccessoryView = toolBar
        //pickerView.selectRow(7, inComponent: 0, animated: true)
        
        
        
        let paddingView = UIView(frame: CGRect(x : 0,y: 0, width : 10, height : self.todoTitleTextField.frame.height))
        todoTitleTextField.leftView = paddingView
        todoTitleTextField.leftViewMode = UITextFieldViewMode.always
        
        
        
        
        
        
        
        if todo != nil {
            self.todoTitleTextField.text = todo?.planTitle
            self.todoDaysTextField.text = todo?.deadLineNumber
            self.todoCompleteOptionTextField.text = todo?.TimeOfCompletion
            self.todoMemo.text = todo?.memo
            state = .Update
        } else {
            self.todoTitleTextField.placeholder = "계획을 입력해주세요."
            
            state = .Create
        }
        self.title = state.rawValue
        
        let saveButton = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(NewToDoCreateViewController.onClickSaveButton(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        //        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(NewToDoCreateViewController.onClickCancelButton(sender:)))
        //        self.navigationItem.leftBarButtonItem = cancelButton
        // Do any additional setup after loading the view.
    }
    
    func onClickSaveButton(sender: UIBarButtonItem) {
        if isValidate() == false {
            return
        }
        if state == .Create {
            ToDoList().create(name: todoTitleTextField.text!, deadline: todoDaysTextField.text!, completionOption : todoCompleteOptionTextField.text!, memoText: todoMemo.text)
        } else if state == .Update {
            ToDoList().update(todo: todo, name: todoTitleTextField.text!, deadline: todoDaysTextField.text!, completionOption : todoCompleteOptionTextField.text!, memoText: todoMemo.text)
        }
        self.performSegue(withIdentifier: "returnToDoList", sender: self)
    }
    //    func onClickCancelButton(sender: UIBarButtonItem) {
    //        dismiss(animated: true, completion: nil)
    //
    //    }
    
    private func isValidate() -> Bool {
        if let name = todoTitleTextField.text {
            if name.characters.count == 0 {
                return false
            }
        } else {
            return false
        }
        return true
    }
    
    
    func donePicker() {
        todoDaysTextField.resignFirstResponder()
    }
    
    
    
    
    
    
    
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case Component.Section.days.rawValue:
            return Component.pickOption.count
        case Component.Section.completeOption.rawValue:
            return Component.completeOption.count
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case Component.Section.days.rawValue:
            return Component.pickOption[row]
        case Component.Section.completeOption.rawValue:
            return Component.completeOption[row]
            
        default :
            return nil
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        deadLineNumberPickTextField.text = pickOption[row]
        
        switch component {
        case Component.Section.days.rawValue:
            self.todoDaysTextField.text = Component.pickOption[row]
        case Component.Section.completeOption.rawValue:
            self.todoCompleteOptionTextField.text = Component.completeOption[row]
            
            
        default :
            return
        }
        
    }
    
    
    private func setupRPPlanCreateView(){
        self.todoMemo.layer.borderWidth = 1.0
        self.todoMemo.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        //키보드 노티 구독
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    func keyboardWillShow(_ notification:Notification) {
        if todoMemo.isFirstResponder{
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
        
    }
    //키보드가 사라질 때 수행되는 함수
    func keyboardWillHide(_ notification:Notification){
        if todoMemo.isFirstResponder{
            view.frame.origin.y = view.frame.origin.y + getKeyboardHeight(notification)
        }
    }
    
    //키보드의 높이를 가져오는 함수이다.
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    //키보드 노티피케이션을 구독하는 함수. viewWillAppear시 수행된다.
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        //위에서 정의한 keyboardWillShow,keyboardWillHide를 selector로 지정한다.
        
    }
    //키보드 노티에 관한 것을 구독 취소 해주는 함수 -> 꼭 해줘야한다.
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        //위에서 생성했던 옵저버를 삭제한다.
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
