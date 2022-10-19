//
//  ViewController.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/10/20.
//

import UIKit

class ViewController: UIViewController {
    //Page view controller
    
    @IBOutlet weak var contentView: UIView!
    
    var dataSource = ["View Controller One", "View Controller Two", "View Controller Three", "View Controller Four"]
    var slideTitle = ["Step one", "Step Two", "Step Three", "Step Four"]
    
    var currentViewControllerIndex = 0
    
    func configurePageViewController(){
        // for saving to custom page view controller
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else{
            return
        }

        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        //This is to create a child view class
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        //Programatically adding constraints
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.view.backgroundColor = UIColor.cyan
        contentView.addSubview(pageViewController.view)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: pageViewController.view as Any, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewController.view as Any, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewController.view as Any, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewController.view as Any, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
                    ])
        
        //let views: [String: Any] = ["pageView": pageViewController]
        //puts the view flush horizontally
        //contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H: |-0-[pageView]-0|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        //puts the view flush vertically
        //contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V: |-70-[pageView]-50|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else{
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    
    func detailViewControllerAt(index: Int) -> DataViewController?{
        //if we are overstepping our index
        if index >= dataSource.count || dataSource.count == 0{
            return nil
        }
        guard let dataViewController = storyboard?.instantiateViewController(identifier: String(describing: DataViewController.self)) as? DataViewController else{
            return nil
        }
        //putting array into the label
        dataViewController.index = index
        dataViewController.displayText = dataSource[index]
        return dataViewController
    }
    
    
    @IBOutlet weak var consoleOput: UILabel!
    @IBAction func userInputUpdated(_ sender: Any) {
        switch selector.selectedSegmentIndex {
        case 0 :
            userInputValue.text = userInputValue.text
            convertAssemblyCode()

        case 1 :
            userInputValue.text = userInputValue.text
            convertMachineCode()

        default:
            print("default select switch statement")
            userInputValue.text = userInputValue.text
            convertMachineCode()
            break
        }
        configurePageViewController()
    }
    
    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var userInputValue: UITextField!
    
    @IBAction func selector(_ sender: Any) {
       
    }
    
    @IBAction func IndexChanged(_ sender: Any) {
        print ("changed selector \(selector.selectedSegmentIndex)")
        
        switch selector.selectedSegmentIndex {
        case 0 :
            userInputValue.text = userInputValue.text
            convertAssemblyCode()

        case 1 :
            userInputValue.text = userInputValue.text
            convertMachineCode()

        default:
            print("default select switch statement")
            userInputValue.text = userInputValue.text
            convertMachineCode()
            break
        }
    }
    
    var activeTextField: UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //pageViewController call
        configurePageViewController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        // default to convertMachineCode but need to update for the selector
        switch selector.selectedSegmentIndex {
        case 0 :
            userInputValue.text = userInputValue.text
            convertAssemblyCode()

        case 1 :
            userInputValue.text = userInputValue.text
            convertMachineCode()

        default:
            print("Here at load view")
            userInputValue.text = userInputValue.text
            convertMachineCode()
            break
        }
    }
    
    func convertMachineCode() {
        // Add the following lines for debugging. Change the tempMC to user input
        let myString = userInputValue.text ?? "0"
        let tempMC : UInt32 = UInt32(myString, radix: 16) ?? 0
        let myInstruction = Instruction(instruction: tempMC)
        let myOpCode : UInt8 = myInstruction.opCode
        let myTable = OpTable()
        
        // Clear out the slide sets
        dataSource = []
        
        // Set the first page
        var myOutput : String = ""
        myOutput = "OpCode: " + String(myOpCode)
        myOutput += " binary "
        myOutput += myInstruction.showBinary(UInt32(myInstruction.opCode), noOfBits: 6) + "\n"
        myOutput += "Format Type: "
        myOutput += (myInstruction.formatType ?? "Unknown ")
        myOutput += ("-Type \n")
        
        if (myInstruction.function != 0xFF) {
            myOutput += "Function: 0x" + String (format: "%02X", myInstruction.function) + "\n"
        }
        dataSource.append(myOutput)
        
        myOutput = ""
        if (myInstruction.formatType == "I") {
            let myIType = IFormat(tempMC, myOpCode)
            myOutput += "The I Format opCode: " + String(format: "%02X", myOpCode) + "\n"
            myOutput += "The rs is: \(myIType.rs) \n"
            myOutput += "The rt is: \(myIType.rt) \n"
            let imm = String(format: "%02x", myIType.IMM)
            myOutput += "The IMM is: \(imm) \n"
            
            dataSource.append(myOutput)
            
            let displayText = myTable.getAssembly(myOpCode, myInstruction.function)
            myOutput = ""
            myOutput += "Your assemble code is \n"
            myOutput += displayText.0 + " " + myIType.rtMnemonic
            myOutput += " , " + myIType.rsMnemonic
            myOutput += " , " + imm
            dataSource.append(myOutput)
        }
        
        if (myInstruction.formatType == "J") {
            let myJType = JFormat(tempMC, myOpCode)
            myOutput += "The J Format opCode: " + String(format: "%02X", myOpCode) + "\n"
            let myOffset = myJType.showBinary(myJType.offset, noOfBits: 26)
            myOutput += "The offset is: \(myOffset) \n"
            myOutput += "which is: \(myJType.offset) \n"
            
            dataSource.append(myOutput)
            
            let displayText = myTable.getAssembly(myOpCode, myInstruction.function)
            
            myOutput = ""
            myOutput += "Your assemble code is \n"
            myOutput += displayText.0 + " \(myJType.offset)"
            dataSource.append(myOutput)
            
            let i = myTable.OpTable.firstIndex(where: {$0.value.0.hasPrefix(String(format: "%02X", myOpCode))})
            print(i)
        }
        
        if (myInstruction.formatType == "R") {
            let myRType = RFormat(tempMC, myOpCode, myInstruction.function)
            myOutput += "The R Format opCode: " + String(format: "%02X", myOpCode) + "\n"
            myOutput += "The rs is: \(myRType.rs) "
            myOutput +=  myRType.rsMnemonic + "\n"
            myOutput += "The rd is: \(myRType.rd) "
            myOutput +=  myRType.rdMnemonic + "\n"
            myOutput += "The rt is: \(myRType.rt) "
            myOutput +=  myRType.rtMnemonic + "\n"
            myOutput += "The shamt is: \(myRType.shamt) \n"
            myOutput += "The function is: \(myRType.funct) \n"
            
            dataSource.append(myOutput)
            
            let displayText = myTable.getAssembly(myOpCode, myInstruction.function)
            
            myOutput = ""
            myOutput += "Your assemble code is \n"
            myOutput += displayText.0 + " " + myRType.rdMnemonic
            myOutput += " , " + myRType.rsMnemonic
            myOutput += " , " + myRType.rtMnemonic
            dataSource.append(myOutput)
        }
        
    
        consoleOput.text = myOutput
        
        let i = myTable.OpTable.firstIndex(where: {$0.value.0.hasPrefix(String(format: "%02X", myOpCode))})
        print("About to call the page view")
        print("My Out var is \(myOutput)")
        dataSource.append(myOutput)
        dataSource.append("jay")
        print("my dataSource is")
        print(dataSource)
        configurePageViewController()
        print("Done with the page view in convertMachineCode")
    }
    
    func convertAssemblyCode() {
        print ("In convertAssemblyCode")
        dataSource = []
        
        // Add the following lines for debugging. Change the tempMC to user input
        let myString = userInputValue.text ?? "add"
        let myAssembly = Assembly(assembly: myString)
        let myOpCode : UInt8 = myAssembly.opCode
        let myFunct : UInt8 = myAssembly.function
        let myTable = OpTable()
        
        var myOutput : String = ""
        myOutput = "OpCode: " + String(myOpCode)
        myOutput += " binary "
        myOutput += myAssembly.showBinary(UInt32(myAssembly.opCode), noOfBits: 6) + "\n"
        myOutput += "Format Type: "
        myOutput += (myAssembly.formatType ?? "Unknown ")
        myOutput += ("-Type \n")
        
        if (myAssembly.function != 0xFF) {
            myOutput += "Function: 0x" + String (format: "%02X", myAssembly.function) + "\n"
        }
        
        dataSource.append(myOutput)
        
        myOutput = ""
        // Now we know what the format of the assembly code needs to be we can call on the right encoding
        switch myAssembly.formatType {
        case "I" :
            print ("About to encode an I format")
            let myIType = IFormat(myAssembly.assemblyCode, myAssembly.opCode)

            myOutput += "The I Format opCode: " + String(format: "%02X", myOpCode) + "\n"
            myOutput += "The rs is: \(myIType.rs) \n"
            myOutput += "The rt is: \(myIType.rt) \n"
            let imm = String(format: "%02x", myIType.IMM)
            myOutput += "The IMM is: \(imm) \n"
                        
            myOutput += "Your machine code is \n"
            myOutput += "\(myIType.opCode) " + " " + " \(myIType.rs)"
            myOutput += " , " + "\(myIType.rt) "
            myOutput += " , " + "\(imm) "
            
            myOutput += "\nYour binary code is \n"
            myOutput += "\(myIType.showBinary( UInt32(myIType.opCode) , noOfBits: 6)) " + " \(myIType.showBinary (UInt32(myIType.rt) , noOfBits: 5)) "
            myOutput += "\(myIType.showBinary (UInt32(myIType.rs) , noOfBits: 5)) "
            myOutput += "\(myIType.showBinary (UInt32(myIType.IMM) , noOfBits: 16)) "

            dataSource.append(myOutput)
            
            // Now copmbine all the various bits together shifting them to the right locaion
            var machineCode : UInt32 = 0x00000000
            var opCode32, rt32, rs32, imm32 :UInt32
            
            opCode32 = UInt32(myIType.opCode)
            opCode32 = opCode32 << 26
            
            rs32 = UInt32(myIType.rs)
            rs32 = rs32 << 21

            rt32 = UInt32(myIType.rt)
            rt32 = rt32 << 16
            
            imm32 = UInt32(myIType.IMM)
            
            machineCode = opCode32 + rs32 + rt32 + imm32
            
            myOutput = ""
            myOutput += "\nYour binary instruction is \n"
            myOutput += myIType.showBinary(machineCode, noOfBits: 32)
            myOutput += "\nYour machine instruction is \n"
            myOutput += String(format: "%08X", machineCode)
            dataSource.append(myOutput)
            
        case "J" :
            print ("About to encode an J format")
            let myJType = JFormat(myAssembly.assemblyCode, myAssembly.opCode)

            myOutput += "The J Format opCode: " + String(format: "%02X", myOpCode) + "\n"
            let offsetStr = String(format: "%06X", myJType.offset)
            myOutput += "The offset is: " + offsetStr
                        
            myOutput += "\nYour machine code is \n"
            myOutput += "\(myJType.opCode) " + " \(offsetStr)"
            
            dataSource.append(myOutput)
            myOutput += "\nYour binary code is \n"
            myOutput += "\(myJType.showBinary( UInt32(myJType.opCode) , noOfBits: 6)) "
            myOutput += " \(myJType.showBinary (UInt32(myJType.offset) , noOfBits: 26)) "
            
            // Now copmbine all the various bits together shifting them to the right locaion
            var machineCode : UInt32 = 0x00000000
            var opCode32, offset32 :UInt32
            
            opCode32 = UInt32(myJType.opCode)
            opCode32 = opCode32 << 26
            
            offset32 = UInt32(myJType.offset)

            
            machineCode = opCode32 + offset32
            
            myOutput += "\nYour binary instruction is \n"
            myOutput += myJType.showBinary(machineCode, noOfBits: 32)
            myOutput += "\nYour machine instruction is \n"
            myOutput += String(format: "%08X", machineCode)
            
        case "R" :
            print ("About to encode an R format")
            let myRType = RFormat(myAssembly.assemblyCode, myAssembly.opCode)

            myOutput += "The R Format opCode: " + String(format: "%02X", myOpCode) + "\n"
            myOutput += "The rs is: \(myRType.rs) "
            myOutput += "The rt is: \(myRType.rt) "
            myOutput += "The rd is: \(myRType.rd) \n"
            let shamt = String(format: "%02x", myRType.shamt)
            myOutput += "The shamt is: \(shamt) \n"
                        
            myOutput += "Your machine code is \n"
            myOutput += "\(myRType.opCode) " + " \(myRType.rs)"
            myOutput += " , " + "\(myRType.rt) ," + " \(myRType.rd)"
            myOutput += " , " + "\(shamt) "
            
            myOutput += "\nYour binary code is \n"
            myOutput += "\(myRType.showBinary( UInt32(myRType.opCode) , noOfBits: 6)) " + " \(myRType.showBinary (UInt32(myRType.rs) , noOfBits: 5)) "
            myOutput += "\(myRType.showBinary (UInt32(myRType.rt) , noOfBits: 5)) "
            myOutput += "\(myRType.showBinary (UInt32(myRType.rd) , noOfBits: 5)) "
            myOutput += "\(myRType.showBinary (UInt32(myRType.shamt) , noOfBits: 5)) "
            myOutput += "\(myRType.showBinary (UInt32(myRType.funct) , noOfBits: 6)) "
            dataSource.append(myOutput)
            
            // Now copmbine all the various bits together shifting them to the right locaion
            var machineCode : UInt32 = 0x00000000
            var opCode32, rt32, rs32, rd32, shamt32, funct32 :UInt32
            
            opCode32 = UInt32(myRType.opCode)
            opCode32 = opCode32 << 26
            
            rs32 = UInt32(myRType.rs)
            rs32 = rs32 << 21

            rt32 = UInt32(myRType.rt)
            rt32 = rt32 << 16
            
            rd32 = UInt32(myRType.rd)
            rd32 = rd32 << 11
            
            shamt32 = UInt32(myRType.shamt)
            shamt32 = shamt32 << 6
            
            funct32 = UInt32(myRType.funct)

            
            machineCode = opCode32 + rs32 + rt32 + rd32 + shamt32 + funct32
            
            myOutput = ""
            myOutput += "\nYour binary instruction is \n"
            myOutput += myRType.showBinary(machineCode, noOfBits: 32)
            myOutput += "\nYour machine instruction is \n"
            myOutput += String(format: "%08X", machineCode)
        default:
            print ("Error unknown format type")
        }
        consoleOput.text = myOutput
        dataSource.append(myOutput)
        print("About to call the page view")
        print("My Out var is \(myOutput)")
        dataSource.append(myOutput)
        dataSource.append("jay")
        print("my dataSource is")
        print(dataSource)
        configurePageViewController()
        print("Done with the page view in convertAssemblyCode")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

          guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

            // if keyboard size is not available for some reason, dont do anything
            return
          }

          var shouldMoveViewUp = false

          // if active text field is not nil
          if let activeTextField = activeTextField {

            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height

            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
              shouldMoveViewUp = true
            }
          }

          if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
          }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    @objc func didTapView() {
        self.view.endEditing(true)
    }
}

extension ViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}
extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        return currentViewControllerIndex
    }
    func presentationViewController( pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else{
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        return detailViewControllerAt(index: currentIndex)
    }
    
        func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?{
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else{
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        return detailViewControllerAt(index: currentIndex)
    }
 
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController?{
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        if currentIndex == dataSource.count{
            return nil
        }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }

}
