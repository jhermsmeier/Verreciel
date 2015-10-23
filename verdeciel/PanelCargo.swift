//  Created by Devine Lu Linvega on 2015-08-28.
//  Copyright (c) 2015 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class PanelCargo : Panel
{
	var uploadItem:Event!
	var uploadProgress:CGFloat = 0
	
	var cargohold = Event(newName: "cargohold", type: eventTypes.stack)
	
	var line1:SCNLine!
	var line2:SCNLine!
	var line3:SCNLine!
	var line4:SCNLine!
	var line5:SCNLine!
	var line6:SCNLine!
	
	var panelHead:SCNNode!
	
	var panelFoot:SCNNode!
	
	override func setup()
	{
		name = "cargo"
		interface.position = SCNVector3(x: 0, y: 0, z: templates.radius)
		
		panelHead = SCNNode()
		port = SCNPort(host: self)
		port.position = SCNVector3(x: 0, y: 0.4, z: templates.radius)
		label = SCNLabel(text: "cargo", scale: 0.1, align: alignment.center)
		label.position = SCNVector3(x: 0, y: 0, z: templates.radius)
		panelHead.addChildNode(port)
		panelHead.addChildNode(label)
		addChildNode(panelHead)
		panelHead.eulerAngles.x += Float(degToRad(templates.titlesAngle))
		
		panelFoot = SCNNode()
		details = SCNLabel(text: "0", scale: 0.1, align: alignment.center)
		details.position = SCNVector3(x: 0, y: 0, z: templates.radius)
		panelFoot.addChildNode(details)
		addChildNode(panelFoot)
		panelFoot.eulerAngles.x += Float(degToRad(-templates.titlesAngle))

		// Tutorial Item
		
		addEvent(items.smallBattery)

		// Quantity
		
		line1 = SCNLine(nodeA: SCNVector3(x: -0.5, y: -0.5, z: 0),nodeB: SCNVector3(x: 0.5, y: -0.5, z: 0),color:white)
		line2 = SCNLine(nodeA: SCNVector3(x: -0.5, y: -0.3, z: 0),nodeB: SCNVector3(x: 0.5, y: -0.3, z: 0),color:white)
		line3 = SCNLine(nodeA: SCNVector3(x: -0.5, y: -0.1, z: 0),nodeB: SCNVector3(x: 0.5, y: -0.1, z: 0),color:white)
		line4 = SCNLine(nodeA: SCNVector3(x: -0.5, y: 0.1, z: 0),nodeB: SCNVector3(x: 0.5, y: 0.1, z: 0),color:grey)
		line5 = SCNLine(nodeA: SCNVector3(x: -0.5, y: 0.3, z: 0),nodeB: SCNVector3(x: 0.5, y: 0.3, z: 0),color:grey)
		line6 = SCNLine(nodeA: SCNVector3(x: -0.5, y: 0.5, z: 0),nodeB: SCNVector3(x: 0.5, y: 0.5, z: 0),color:grey)
		
		interface.addChildNode(line1)
		interface.addChildNode(line2)
		interface.addChildNode(line3)
		interface.addChildNode(line4)
		interface.addChildNode(line5)
		interface.addChildNode(line6)
		
		// Trigger
		
		interface.addChildNode(SCNTrigger(host: self, size: CGSize(width: 2, height: 2)))
	}
	
	override func start()
	{
		decals.opacity = 0
		interface.opacity = 0
		label.updateWithColor("--", color: grey)
	}
	
	func contains(event:Event) -> Bool
	{
		for newEvent in cargohold.content {
			if newEvent == event { return true }
		}
		return false
	}
	
	func addEvent(event:Event)
	{
		cargohold.content.append(event)
	}
	
	func addEvents(events:Array<Event>)
	{
		for event in events {
			cargohold.content.append(event)
		}
	}
	
	override func touch(id:Int = 0)
	{
		self.bang()
	}
	
	override func listen(event:Event)
	{
		print("* CARGO    | Signal: \(event.name!)")
		if event.type == eventTypes.item {
			pickup(event)
		}
		else{
			details.updateWithColor("error", color: red)
		}
	}

	func pickup(event:Event)
	{
		if event.type == eventTypes.cargo {
			self.addEvents(event.content)
		}
		else{
			self.addEvent(event)
		}
		refreshCargohold()
		update()
		bang()
	}
	
	override func installedFixedUpdate()
	{
		if uploadItem != nil {
			uploadProgress += CGFloat(arc4random_uniform(100))/50
			details.updateWithColor("Upload \(Int(uploadProgress))%", color: grey)
			if uploadProgress >= 100 {
				uploadCompleted()
			}
		}
	}
	
	func uploadItem(item:Event)
	{
		uploadItem = item
	}
	
	func uploadCompleted()
	{
		port.origin.disconnect()
		self.addEvent(uploadItem)
		uploadItem = nil
		details.update("")
		refreshCargohold()
		update()
		bang()
	}
	
	override func update()
	{
		line1.color(grey)
		line2.color(grey)
		line3.color(grey)
		line4.color(grey)
		line5.color(grey)
		line6.color(grey)
		
		if cargohold.content.count > 0 { line1.color( cargohold.content[0].isQuest == true ? cyan : white ) }
		if cargohold.content.count > 1 { line2.color( cargohold.content[1].isQuest == true ? cyan : white ) }
		if cargohold.content.count > 2 { line3.color( cargohold.content[2].isQuest == true ? cyan : white ) }
		if cargohold.content.count > 3 { line4.color( cargohold.content[3].isQuest == true ? cyan : white ) }
		if cargohold.content.count > 4 { line5.color( cargohold.content[4].isQuest == true ? cyan : white ) }
		if cargohold.content.count > 5 { line6.color( cargohold.content[5].isQuest == true ? cyan : white ) }
	}
	
	func refreshCargohold()
	{
		let newCargohold = Event(newName: "cargohold", type: eventTypes.stack)
		for item in cargohold.content {
			if item.size > 0 {
				newCargohold.content.append(item)
			}
		}
		cargohold = newCargohold
	}
	
	override func bang()
	{
		self.update()
		if port.connection != nil {
			port.connection.host.listen(cargohold)
		}
	}
}