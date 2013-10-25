package engine.base;

/**
 * ...
 * @author Jakegr
 */

class EntityGroup extends RueObject
{
	static var Head:EntityGroup;
	var Next:EntityGroup;
	var Self:EntityGroup;
	
	public var EntityHead:Entity;
	
	public var DoesPreUpdate:Bool;
	public var DoesUpdate:Bool;
	public var DoesDraw:Bool;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(DoesPreUpdate:Bool = true, DoesUpdate:Bool = true, DoesDraw:Bool = true):EntityGroup
	{
		var Vessel:EntityGroup;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new EntityGroup();
		}
		Vessel.DoesDraw = DoesDraw;
		Vessel.DoesPreUpdate = DoesPreUpdate;
		Vessel.DoesUpdate = DoesUpdate;
		return Vessel;
	}
	
	public function PreUpdate():Void 
	{
		if (!DoesPreUpdate) { return; }
		var Current:Entity = EntityHead;
		while (Current != null)
		{
			var NextEntity:Entity = Current.NextEntity;
			if(Current.DoesPreUpdate)
			Current.PreUpdate();
			Current = NextEntity;
		}
	}
	
	public function Update():Void
	{
		if (!DoesUpdate) { return; }
		var Current:Entity = EntityHead;
		while (Current != null)
		{
			var NextEntity:Entity = Current.NextEntity;
			if(Current.DoesUpdate)
			Current.Update();
			Current = NextEntity;
		}
	}
	
	public function Draw():Void
	{
		if (!DoesDraw) { return; }
		var Current:Entity = EntityHead;
		while (Current != null)
		{
			var NextEntity:Entity = Current.NextEntity;
			if(Current.DoesDraw)
			Current.Draw();
			Current = NextEntity;
		}
	}
	
	override public function Recycle():Void
	{
		super.Recycle();
		Next = Head;
		Head = Self;
		while (EntityHead != null)
		{
			EntityHead.Recycle();
		}
	}
		
	
}