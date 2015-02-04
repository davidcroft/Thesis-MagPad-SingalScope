//
//  ViewController.swift
//  MagDataScope
//
//  Created by Ding Xu on 2/2/15.
//  Copyright (c) 2015 Ding Xu. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    @IBOutlet var valueXText: UILabel!
    @IBOutlet var valueYText: UILabel!
    @IBOutlet var valueZText: UILabel!
    
    @IBOutlet var valueXSwitch: UISwitch!
    @IBOutlet var valueYSwitch: UISwitch!
    @IBOutlet var valueZSwitch: UISwitch!
    var valueXSwitchFlag:UInt = 0
    var valueYSwitchFlag:UInt = 0
    var valueZSwitchFlag:UInt = 0
    
    
    let lineChartView = JBLineChartView()
    
    // megnetometer setting
    var motionManager: CMMotionManager = CMMotionManager()
    var magnetoTimer: NSTimer!
    
    // megnetometer data
    var dataX: Array<CGFloat> = Array<CGFloat>(count: GRAPH_SIZE, repeatedValue:0)
    var dataY: Array<CGFloat> = Array<CGFloat>(count: GRAPH_SIZE, repeatedValue:0)
    var dataZ: Array<CGFloat> = Array<CGFloat>(count: GRAPH_SIZE, repeatedValue:0)
    var dataIndex: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // init magnetometer
        self.motionManager.startMagnetometerUpdates()
        // add a timer and new thread to get data from sensors
        self.magnetoTimer = NSTimer.scheduledTimerWithTimeInterval(0.01,
            target:self,
            selector:"updateMegneto:",
            userInfo:nil,
            repeats:true)
        println("Launched magnetometer")
        
        // init line chart
        self.lineChartView.dataSource = self
        self.lineChartView.delegate = self
        self.lineChartView.backgroundColor = lineGranphbgColor
        self.lineChartView.frame = CGRectMake(0, self.view.bounds.height*0.4, self.view.bounds.width, self.view.bounds.height*0.6)
        self.lineChartView.minimumValue = 0
        self.lineChartView.maximumValue = 450
        self.lineChartView.reloadData()
        self.view.addSubview(lineChartView)
        println("Launched lineChartView")
        
        // init text
        self.valueXText.textColor = redColor
        self.valueYText.textColor = greenColor
        self.valueZText.textColor = blueColor
        self.valueXText.text = "X: "
        self.valueYText.text = "Y: "
        self.valueZText.text = "Z: "
        
        // init switch btn
        self.valueXSwitch.setOn(true, animated: false)
        self.valueYSwitch.setOn(true, animated: false)
        self.valueZSwitch.setOn(true, animated: false)
        self.valueXSwitchFlag = 1
        self.valueYSwitchFlag = 1
        self.valueZSwitchFlag = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //number of lines in chart
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return  valueXSwitchFlag + valueYSwitchFlag + valueZSwitchFlag
    }
    
    //number of values for a line
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        //println("lineChartView x \(dataX.count)")
        return UInt(dataX.count)
    }
    
    //y-position (y-axis) of point at horizontalIndex (x-axis)
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        //println("x: \(horizontalIndex) value: \(dataX[Int(horizontalIndex)])")
        
        if (self.valueXSwitch.on && self.valueYSwitch.on && self.valueZSwitch.on) {
            // show x, y and z value
            if (lineIndex == 0) {
                return dataX[Int(horizontalIndex)]
            } else if (lineIndex == 1) {
                return dataY[Int(horizontalIndex)]
            } else {
                return dataZ[Int(horizontalIndex)]
            }
        } else if (self.valueXSwitch.on && self.valueYSwitch.on && !self.valueZSwitch.on) {
            // show x and y value
            if (lineIndex == 0) {
                return dataX[Int(horizontalIndex)]
            } else {
                return dataY[Int(horizontalIndex)]
            }
        } else if (self.valueXSwitch.on && !self.valueYSwitch.on && self.valueZSwitch.on) {
            // show x and y value
            if (lineIndex == 0) {
                return dataX[Int(horizontalIndex)]
            } else {
                return dataZ[Int(horizontalIndex)]
            }
        } else if (!self.valueXSwitch.on && self.valueYSwitch.on && self.valueZSwitch.on) {
            // show x and y value
            if (lineIndex == 0) {
                return dataY[Int(horizontalIndex)]
            } else {
                return dataZ[Int(horizontalIndex)]
            }
        } else if (!self.valueXSwitch.on && !self.valueYSwitch.on && self.valueZSwitch.on) {
            // show z value only
            if (lineIndex == 0) {
                return dataZ[Int(horizontalIndex)]
            }
        } else if (!self.valueXSwitch.on && self.valueYSwitch.on && !self.valueZSwitch.on) {
            // show Y value only
            if (lineIndex == 0) {
                return dataY[Int(horizontalIndex)]
            }
        }  else if (self.valueXSwitch.on && !self.valueYSwitch.on && !self.valueZSwitch.on) {
            // show x value only
            if (lineIndex == 0) {
                return dataX[Int(horizontalIndex)]
            }
        } else {
            // show no value
            return 0
        }
        return 0
    }
    
    func lineChartView(lineChartView:JBLineChartView!, colorForLineAtLineIndex lineIndex:UInt) -> UIColor {
        //println("swith X status: \(self.valueXSwitch.on), swith Y status: \(self.valueYSwitch.on), swith Y status: \(self.valueZSwitch.on)")
        if (self.valueXSwitch.on && self.valueYSwitch.on && self.valueZSwitch.on) {
            // show x, y and z value
            if (lineIndex == 0) {
                return redColor
            } else if (lineIndex == 1) {
                return greenColor
            } else {
                return blueColor
            }
        } else if (self.valueXSwitch.on && self.valueYSwitch.on && !self.valueZSwitch.on) {
            // show x and y value
            if (lineIndex == 0) {
                return redColor
            } else {
                return greenColor
            }
        } else if (self.valueXSwitch.on && !self.valueYSwitch.on && self.valueZSwitch.on) {
            // show x and y value
            if (lineIndex == 0) {
                return redColor
            } else {
                return blueColor
            }
        } else if (!self.valueXSwitch.on && self.valueYSwitch.on && self.valueZSwitch.on) {
            // show x and y value
            if (lineIndex == 0) {
                return greenColor
            } else {
                return blueColor
            }
        } else if (!self.valueXSwitch.on && !self.valueYSwitch.on && self.valueZSwitch.on) {
            // show z value only
            if (lineIndex == 0) {
                return blueColor
            }
        } else if (!self.valueXSwitch.on && self.valueYSwitch.on && !self.valueZSwitch.on) {
            // show Y value only
            if (lineIndex == 0) {
                return greenColor
            }
        }  else if (self.valueXSwitch.on && !self.valueYSwitch.on && !self.valueZSwitch.on) {
            // show x value only
            if (lineIndex == 0) {
                return redColor
            }
        } else {
            // show no value
            return UIColor.clearColor()
        }
        return  UIColor.clearColor()
    }
    
    func lineChartView(lineChartView:JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor{
        return UIColor.clearColor() // color of area under line in chart
    }
    
    func lineChartView(lineChartView:JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat{
        return CGFloat(1.5); // width of line in chart
    }
    
    

    // timer
    func updateMegneto(timer: NSTimer) -> Void {
        // TODO
        if self.motionManager.magnetometerData != nil {
            let valX = self.motionManager.magnetometerData.magneticField.x
            let valY = self.motionManager.magnetometerData.magneticField.y
            let valZ = self.motionManager.magnetometerData.magneticField.z

            // update text in UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.valueXText.text = String(format:"X: %f", valX)
                self.valueYText.text = String(format:"Y: %f", valY)
                self.valueZText.text = String(format:"Z: %f", valZ)
            })
            
            // update graph in view
            if (self.dataIndex < GRAPH_SIZE) {
                // not comes to end of an array
                self.dataX[self.dataIndex] = CGFloat(abs(valX))
                self.dataY[self.dataIndex] = CGFloat(abs(valY))
                self.dataZ[self.dataIndex] = CGFloat(abs(valZ))
                self.dataIndex++
                self.lineChartView.reloadData()
            } else {
                // comes to end of an array
                for var index = 0; index < GRAPH_SIZE; ++index {
                    self.dataX[index] = 0
                    self.dataY[index] = 0
                    self.dataZ[index] = 0
                }
                self.dataIndex = 0
                self.lineChartView.reloadData()
            }
        }
    }

    @IBAction func valueXSwitchBtn(sender: AnyObject) {
        //println("swith X status: \(self.valueXSwitch.on)")
        if (self.valueXSwitch.on) {
            // set switch on
            //self.valueXSwitch.setOn(true, animated: true)
            self.valueXSwitchFlag = 1
        } else {
            // set switch off
            //self.valueXSwitch.setOn(false, animated: true)
            self.valueXSwitchFlag = 0
        }
        self.lineChartView.reloadData()
    }
    
    @IBAction func valueYSwitchBtn(sender: AnyObject) {
        //println("swith Y status: \(self.valueYSwitch.on)")
        if (self.valueYSwitch.on) {
            // set switch on
            //self.valueYSwitch.setOn(true, animated: true)
            self.valueYSwitchFlag = 1
        } else {
            // set switch off
            //self.valueYSwitch.setOn(false, animated: true)
            self.valueYSwitchFlag = 0
        }
        self.lineChartView.reloadData()
    }
    
    @IBAction func valueZSwitchBtn(sender: AnyObject) {
        //println("swith Z status: \(self.valueZSwitch.on)")
        if (self.valueZSwitch.on) {
            // set switch on
            //self.valueZSwitch.setOn(true, animated: true)
            self.valueZSwitchFlag = 1
        } else {
            // set switch off
            //self.valueZSwitch.setOn(false, animated: true)
            self.valueZSwitchFlag = 0
        }
        self.lineChartView.reloadData()
    }
}

