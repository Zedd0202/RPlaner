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
       
        
        static let completeOption = ["동안", "이내"]
        static let pickOption = ["1", "2", "3", "4", "5", "6", "7"]
         //picker 모듈화 하기 위해 구조체안에 열거형 선언
        
    }
    
    var todo: ToDo? = nil
    enum State: String {
        case Update = "수정"
        case Create = "생성"
    }
    //처음 생성됐을 때는 네비게이션 타이틀을 "생성"으로, 수정할 때는 "수정"으로
    var state: State = .Create
    //처음 state는 생성으로.
    
    @IBOutlet weak var todoMemo: UITextView?
    @IBOutlet weak var todoCompleteOptionTextField: UITextField?
    @IBOutlet weak var todoDaysTextField: UITextField?
    @IBOutlet weak var todoTitleTextField: UITextField?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //메모뷰 테두리를 둥글게.
        self.todoMemo?.layer.cornerRadius = 10;
        self.todoMemo?.layer.masksToBounds = true;
        
        
        
        //계획제목을 입력하는 텍스트 필드 테두리를 둥글게.
        self.todoTitleTextField?.layer.cornerRadius = 10
        self.todoTitleTextField?.layer.masksToBounds = true
        
        todoCompleteOptionTextField?.text = "동안"
        //처음 완료옵션은 동안으로 set.
        
        
        //텍스트필드와 텍스트뷰의 delegate의 대리자를 현재의 ViewController로.
        todoDaysTextField?.delegate = self
        todoTitleTextField?.delegate = self
        todoCompleteOptionTextField?.delegate = self
        todoDaysTextField?.delegate = self
        todoMemo?.delegate = self
        
        //텍스트필드를 눌렀을 때 picker가 나오도록 하기 위한 PickerView선언
        let deadLineNumberPicker = UIPickerView()
        let TimerOptionPicker : UIDatePicker = UIDatePicker()
        TimerOptionPicker.datePickerMode = UIDatePickerMode.time
        
        //PickerView의 delegate대리자를 현재의 ViewController로.        
        deadLineNumberPicker.delegate = self
        deadLineNumberPicker.dataSource = self
        
        
        //현재 기한을 3일로 set하고 가운데정렬함.
        todoDaysTextField?.text = "3"
        todoDaysTextField?.textAlignment = NSTextAlignment.center
        
        //텍스트필드에 inputView를 이용하여 눌렀을 때 PickerView가 나오게 한다.
        todoDaysTextField?.inputView = deadLineNumberPicker
        todoCompleteOptionTextField?.inputView = deadLineNumberPicker
        //timerPickerField.inputView = TimerOptionPicker
    
        
        //PickerView의 위치, 너비, 그리고 높이를 지정.
        let pickerView = UIPickerView(frame: CGRect(x : 0,y: 200, width : view.frame.width, height : 300))
        
        //PickerView의 Attribute지정.
        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        pickerView.selectRow(2, inComponent: Component.Section.days.rawValue, animated: false)
        
    
        //PickerView위에 나올 악세사리 뷰를 위한 Toolbar뷰선언.
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 122.0/255, blue: 255.0/255, alpha: 1.0)
        
        toolBar.sizeToFit()
        
        //done버튼 추가.
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(NewToDoCreateViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        //툴바에 위에서 선언한 done과 space버튼을 준다.
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //텍스트필드에 inputAccessoryView를 통해 위에서 선언한 툴바를 넣어준다.
        todoDaysTextField?.inputAccessoryView = toolBar
        todoCompleteOptionTextField?.inputAccessoryView = toolBar
        
        
       
        
        
        //paddingView. 텍스트필드에 가까이 입력되는게 아닌 어느정도 패딩을 가지고 입력하게 함.
        let paddingView = UIView(frame: CGRect(x : 0,y: 0, width : 10, height : (self.todoTitleTextField?.frame.height)!))
        todoTitleTextField?.leftView = paddingView
        todoTitleTextField?.leftViewMode = UITextFieldViewMode.always
        
        
        
        //todo가 nil이 아니면 텍스트필드와 데드라인과 메모를 사용자가 입력한 것으로 set. 또한 state를 "수정"모드로 바꿔 나중에 이 계획을 수정할 때 네비게이션 타이틀이 "수정"으로 된다.
        if todo != nil {
            self.todoTitleTextField?.text = todo?.planTitle
            self.todoDaysTextField?.text = todo?.deadLineNumber
            self.todoCompleteOptionTextField?.text = todo?.TimeOfCompletion
            self.todoMemo?.text = todo?.memo
            state = .Update
            //사용자가 입력을 하지 않은 상태면 placeholder를 지정해준다.
        } else {
            self.todoTitleTextField?.placeholder = "구체적인 계획을 입력해주세요."
            self.todoTitleTextField?.attributedPlaceholder = NSAttributedString(string: "구체적인 계획을 입력해주세요.",attributes: [NSForegroundColorAttributeName: UIColor.white])
        
            
            state = .Create
        }
        //현재 네비게이션 타이틀의 상태를 state의 원시값으로 입력해준다.
        self.navigationItem.title = state.rawValue

        
        
    }
    //취소버튼을 눌렀을 때 실행되는 함수.
    func onClickCancelButton(sender: UIBarButtonItem) {
            dismiss(animated: true, completion: nil)

    }
    //만약 계획을 입력하는 텍스트필드에 아무것도 입력하지 않으면 저장을 눌러도 저장이 되지 않게 된다.
    private func isValidate() -> Bool {
        if let name = todoTitleTextField?.text {
            if name.characters.count == 0 {
                return false
            }
        }
        else {
            return false
        }
        return true
    }
    
    //위의 PickerView에서 done버튼을 눌렀을 때 실행되는 함수. PickerView가 사라지게 된다.
    func donePicker() {
        todoDaysTextField?.endEditing(true)
        todoCompleteOptionTextField?.endEditing(true)
        
    }
    
    
    
    
    
    //취소버튼을 눌렀을 때 실행되는 함수. modal뷰가 사라지게 된다
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    //저장버튼을 눌렀을 때 실행되는 함수.
    @IBAction func saveButtonTapped(_ sender: Any) {
        //생성한 시간을 알아야 하기 때문에 저장한 시간을 저장해준다.
        var currentTime = Date()
        
        //텍스트필드가 비어있지 않은지 검사한다. 만약 비어있다면 저장버튼을 눌러도 저장이 되지 않음.
        if isValidate() == false {
            return
        }
        //state가 "생성"모드라면 실행되는 코드. ToDoList()의 배열에 Create함수를 불러온다.
        if state == .Create {
            ToDoList().create(name: (todoTitleTextField?.text!)!, deadline: (todoDaysTextField?.text!)!, completionOption : (todoCompleteOptionTextField?.text!)!, memoText: (todoMemo?.text)!, createdAt : currentTime)
            //"수정"모드라면 ToDoList()의 update함수를 불러온다.
        } else if state == .Update {
            //self.title = todoTitleTextField?.text
            ToDoList().update(todo: todo, name: (todoTitleTextField?.text!)!, deadline: (todoDaysTextField?.text!)!, completionOption : (todoCompleteOptionTextField?.text!)!, memoText: (todoMemo?.text)!)
        }
        //저장이 되면 내 계획 리스트들로 이동하게 된다. -> rewind세그 이용.
        self.performSegue(withIdentifier: "returnToDoList", sender: self)
    }
    
    //PickerView의 섹션을 2로 준다. 기한 선택, 완료옵션
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //PickerView설정 위에서 선언했던 열거형들의 카운트를 리턴한다.
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
    //PickerView의 row설정.
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
    
    //PickerView의 didSelectRow. 만약 그 row를 선택했을 시 그 선택한 row를 텍스트필드에 넣어준다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case Component.Section.days.rawValue:
            self.todoDaysTextField?.text = Component.pickOption[row]
        case Component.Section.completeOption.rawValue:
            self.todoCompleteOptionTextField?.text = Component.completeOption[row]
            
            
        default :
            return
        }
        
    }
    
    
   //ViewDidLoad다음에 수행되는 함수. 키보드 노티피케이션을 구독해주어야 한다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //키보드 노티 구독.
        subscribeToKeyboardNotifications()
        
        
    }
   
    //스크린 아무데나 터치를 하게 되면 키보드가 사라지는 기능.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    //뷰가 사라질 때 실행되는 함수. 키보드 노티 구독을 취소해주어야 한다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    //키보드가 화면에 나타날 때 수행되는 함수.
    func keyboardWillShow(_ notification:Notification) {
        
        if (todoMemo?.isFirstResponder)!{
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
        
    }
    //키보드가 사라질 때 수행되는 함수
    func keyboardWillHide(_ notification:Notification){
        if (todoMemo?.isFirstResponder)!{
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
    
 
    
}
