//  Created by Devine Lu Linvega on 2015-07-07.
//  Copyright (c) 2015 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class PanelMission : Panel
{
	var locationPanel:SCNNode!

	var questPanel:SCNNode!
	
	var quest1 = SCNLabel()
	var quest1Details = SCNLabel(text: "", align: alignment.right, color:grey)
	var quest2 = SCNLabel()
	var quest2Details = SCNLabel(text: "", align: alignment.right, color:grey)
	var quest3 = SCNLabel()
	var quest4 = SCNLabel()
	var quest5 = SCNLabel()
	
	// MARK: Default -
	
	override func setup()
	{
		name = "mission"
		
		// Decals
		
		decals.position = SCNVector3(x: 0, y: 0, z: templates.radius)
		decals.addChildNode(SCNLine(nodeA: SCNVector3(templates.left,templates.top - 0.2,0), nodeB: SCNVector3(templates.left + 0.2,templates.top,0), color: grey))
		decals.addChildNode(SCNLine(nodeA: SCNVector3(templates.right,templates.top - 0.2,0), nodeB: SCNVector3(templates.right - 0.2,templates.top,0), color: grey))
		decals.addChildNode(SCNLine(nodeA: SCNVector3(templates.left,templates.bottom + 0.2,0), nodeB: SCNVector3(templates.left + 0.2,templates.bottom,0), color: grey))
		decals.addChildNode(SCNLine(nodeA: SCNVector3(templates.right,templates.bottom + 0.2,0), nodeB: SCNVector3(templates.right - 0.2,templates.bottom,0), color: grey))
		
		decals.addChildNode(SCNLine(nodeA: SCNVector3(templates.left,templates.top - 0.2,0), nodeB: SCNVector3(templates.left,templates.bottom + 0.2,0), color: grey))
		decals.addChildNode(SCNLine(nodeA: SCNVector3(templates.right,templates.top - 0.2,0), nodeB: SCNVector3(templates.right,templates.bottom + 0.2,0), color: grey))
		
		locationPanel = Panel()
		interface.addChildNode(locationPanel)
	
		questPanel = SCNNode()
		questPanel.position = SCNVector3(0,0,0)
		
		quest1.position = SCNVector3(x: templates.leftMargin, y: 0.8, z: 0)
		questPanel.addChildNode(quest1)
		quest1Details.position = SCNVector3(x: templates.rightMargin, y: 0.8, z: 0)
		questPanel.addChildNode(quest1Details)
		
		quest2.position = SCNVector3(x: templates.leftMargin, y: 0.4, z: 0)
		questPanel.addChildNode(quest2)
		quest2Details.position = SCNVector3(x: templates.rightMargin, y: 0.4, z: 0)
		questPanel.addChildNode(quest2Details)
		
		quest3.position = SCNVector3(x: templates.leftMargin, y: 0, z: 0)
		questPanel.addChildNode(quest3)
		
		quest4.position = SCNVector3(x: templates.leftMargin, y: -0.4, z: 0)
		questPanel.addChildNode(quest4)
		
		quest5.position = SCNVector3(x: templates.leftMargin, y: -0.8, z: 0)
		questPanel.addChildNode(quest5)
		
		interface.addChildNode(questPanel)
		
		port.input = eventTypes.item
		port.output = eventTypes.unknown
		
		footer.addChildNode(SCNHandle(destination: SCNVector3(0,0,1)))
		
		locationPanel.opacity = 0
	}
	
	override func installedFixedUpdate()
	{
		if capsule.isDocked && capsule.dock.isComplete == false {
			panelUpdate()
		}
		else{
			missionUpdate()
		}
	}
	
	func missionUpdate()
	{
		if isInstalled == false { return }
		
		label.update(name!, color: white)
		
		let latestTutorialQuest = quests.tutorial[quests.tutorialQuestId]
		let latestFalvetQuest = quests.falvet[quests.falvetQuestId]
		
		// Tutorial Quest Line
		quest1.update((latestTutorialQuest.name!))
		quest1Details.update("\(quests.tutorialQuestId)/\(quests.tutorial.count)")
		
		// Falvet Quest Line
		quest2.update((latestFalvetQuest.name!))
		quest2Details.update("\(quests.falvetQuestId)/\(quests.falvet.count)")
		
		quest2.update("--")
		quest3.update("--")
		quest4.update("--")
		quest5.update("--")
	}
	
	func panelUpdate()
	{
		if isInstalled == false { return }
		
		locationPanel.update()
		label.update(capsule.dock.name!)
	}
	
	// MARK: Ports -
	
	override func listen(event:Event)
	{
		
	}
	
	override func bang()
	{
	}
	
	// MARK: Custom -
	
	func complete()
	{
		// Animate
		
		SCNTransaction.begin()
		SCNTransaction.setAnimationDuration(0.5)
		
		locationPanel.position = SCNVector3(0,0,-0.5)
		locationPanel.opacity = 0
		
		SCNTransaction.setCompletionBlock({

			self.questPanel.position = SCNVector3(0,0,-0.5)
			
			SCNTransaction.begin()
			SCNTransaction.setAnimationDuration(0.5)
			
			self.questPanel.position = SCNVector3(0,0,0)
			self.questPanel.opacity = 1
			
			SCNTransaction.setCompletionBlock({
				capsule.dock.isComplete = true
				capsule.dock.update()
			})
			SCNTransaction.commit()
		})
		SCNTransaction.commit()
	}
	
	func connectToLocation(location:Location)
	{
		if location.isComplete == true { return }
		
		locationPanel.empty()
		locationPanel.add(location.panel())
		
		// Animate
		
		SCNTransaction.begin()
		SCNTransaction.setAnimationDuration(0.5)
		
		questPanel.position = SCNVector3(0,0,-0.5)
		questPanel.opacity = 0
		
		SCNTransaction.setCompletionBlock({
			
			self.locationPanel.position = SCNVector3(0,0,-0.5)
			
			SCNTransaction.begin()
			SCNTransaction.setAnimationDuration(0.5)
			
			self.locationPanel.position = SCNVector3(0,0,0)
			self.locationPanel.opacity = 1
			
			SCNTransaction.commit()
		})
		SCNTransaction.commit()
	}
	
	func disconnectFromLocation()
	{
		// Animate
		
		SCNTransaction.begin()
		SCNTransaction.setAnimationDuration(0.5)
		
		locationPanel.position = SCNVector3(0,0,-0.5)
		locationPanel.opacity = 0
		
		SCNTransaction.setCompletionBlock({
			
			self.questPanel.position = SCNVector3(0,0,-0.5)
			
			SCNTransaction.begin()
			SCNTransaction.setAnimationDuration(0.5)
			
			self.questPanel.position = SCNVector3(0,0,0)
			self.questPanel.opacity = 1
			
			SCNTransaction.setCompletionBlock({
				self.locationPanel.empty()
			})
			SCNTransaction.commit()
		})
		SCNTransaction.commit()
	}
	
	override func onInstallationBegin()
	{
		ui.addWarning("Installing", duration: 3)
		player.lookAt(deg: -180)
	}
}