
//  Created by Devine Lu Linvega on 2015-12-18.
//  Copyright © 2015 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class CoreGame
{
	var time:Float = 0
	let memory = NSUserDefaults.standardUserDefaults()
	
	init()
	{
		NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(self.onTic), userInfo: nil, repeats: true)
		NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.whenSecond), userInfo: nil, repeats: true)
	}
	
	func start()
	{
		erase()
		
		save(11)
		
		universe.whenStart()
		capsule.whenStart()
		player.whenStart()
		space.whenStart()
		helmet.whenStart()
		items.whenStart()
		
		load(memory.integerForKey("state"))
	}
	
	func save(id:Int)
	{
		print("@ GAME     | Saved State to \(id)")
		memory.setValue(id, forKey: "state")
		memory.setValue(version, forKey: "version")
	}
	
	func load(id:Int)
	{
		print("@ GAME     | Loaded State to \(id)")
		
		for mission in missions.story {
			if mission.id < id {
				mission.complete()
			}
		}
		missions.story[id].state()
	}
	
	func erase()
	{
		print("$ GAME     | Erase")
		
		let appDomain = NSBundle.mainBundle().bundleIdentifier!
		NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
	}
	
	@objc func whenSecond()
	{
		capsule.whenSecond()
		missions.refresh()
	}
	
	@objc func onTic()
	{
		time += 1
		space.whenTime()
	}
}