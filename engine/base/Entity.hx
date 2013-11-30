package engine.base;
import engine.components.GraphicsComponent;
import engine.components.PhysicsComponent;
import engine.helpers.RueRectangle;

/**
 * ...
 * @author Jakegr
 */

class Entity extends RueObject
{
	public var Group:EntityGroup;
	
	public var PreviousEntity:Entity;
	public var NextEntity:Entity;
	public var SelfEntity:Entity;
	
	public var DoesPreUpdate:Bool;
	public var DoesUpdate:Bool;
	public var DoesDraw:Bool;
	
	
	private function new() {SelfEntity = this;super();}
	public inline function Setup(dGroup:EntityGroup = null):Void //Setup is mandatory, regardless if the entity doesnt have a group. if you dont call setup in an entity it will disturb the pool.
	{
		InPool = false;
		DoesPreUpdate = true;
		DoesUpdate = true;
		DoesDraw = true;
		Group = dGroup;
		PreviousEntity = null;
		if (Group != null)
		{
			if (Group.EntityHead != null){Group.EntityHead.PreviousEntity = SelfEntity;}
			NextEntity = Group.EntityHead;
			Group.EntityHead = SelfEntity;
		}
	}
	
	public function PreUpdate():Void{}
	public function Update():Void{}
	public function Draw():Void{}
	override public function Recycle():Void
	{
		if (!InPool)
		{
			super.Recycle();
			if (Group != null)
			{
				if (PreviousEntity != null){if (NextEntity != null){PreviousEntity.NextEntity = NextEntity;NextEntity.PreviousEntity = PreviousEntity;}else{PreviousEntity.NextEntity = null;}}
				else { if (NextEntity != null) { NextEntity.PreviousEntity = null; Group.EntityHead = NextEntity; } else { Group.EntityHead = null; }}
			}
		}
		else
		{
			trace("Entity attempted to recycle twice");
		}
	}
	
	
}