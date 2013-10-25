package engine.systems;
import engine.base.Entity;
import engine.base.EntityGroup;
import flash.system.System;

/**
 * ...
 * @author Jakegr
 */

class UpdateSystem 
{
	public static var CurrentGroup:EntityGroup;
	public static var PersistentGroup:EntityGroup;
	
	public static function Init():Void
	{
		PersistentGroup = EntityGroup.Create();
	}
	
	public static function PreUpdate():Void
	{
		if (CurrentGroup != null)
		{
			CurrentGroup.PreUpdate();
		}
		PersistentGroup.PreUpdate();
	}
	
	
	public static function Update():Void
	{
		if (CurrentGroup != null)
		{
			CurrentGroup.Update();
		}
		PersistentGroup.Update();
	}
	
	public static function Draw():Void
	{
		if (CurrentGroup != null)
		{
			CurrentGroup.Draw();
		}
		PersistentGroup.Draw();
	}
	
	private function new() 
	{
		
	}
	
}