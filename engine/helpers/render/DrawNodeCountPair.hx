package engine.helpers.render;
import engine.base.RueObject;
import engine.helpers.collections.DrawNode;

/**
 * ...
 * @author Jakegr
 */

class DrawNodeCountPair extends RueObject
{
	static var Head:DrawNodeCountPair;
	var Next:DrawNodeCountPair;
	var Self:DrawNodeCountPair;
	
	public var _DrawHeadNode:DrawNode;
	public var _Count:Int;
	
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create():DrawNodeCountPair
	{
		var Vessel:DrawNodeCountPair;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new DrawNodeCountPair(); }
		Vessel.InPool = false;
		Vessel._Count = 0;
		Vessel._DrawHeadNode = null;
		
		return Vessel;
	}
	
	public inline function Add(AddMe:DrawNode):Void
	{
		_Count++;
		AddMe.NextNode = _DrawHeadNode;
		_DrawHeadNode = AddMe;
	}
	
	public inline function Flush():Void
	{
		_DrawHeadNode = null;
		_Count = 0;
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			if (_DrawHeadNode != null)
			{
				_DrawHeadNode.RecycleInChain();
				_DrawHeadNode = null;
			}
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		Next = Head;
		Head = Self;
	}
		
	
}