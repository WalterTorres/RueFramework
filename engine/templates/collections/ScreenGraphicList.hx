package engine.templates.collections;
import engine.base.RueObject;
import engine.helpers.Profiler;
import engine.helpers.render.DrawStack;
import engine.templates.IScreenGraphic;
import engine.templates.ScreenGraphic;

/**
 * ...
 * @author Jakegr
 */

class ScreenGraphicList 
{
	static var Head:ScreenGraphicList;
	var Next:ScreenGraphicList;
	var Self:ScreenGraphicList;
	
	public var _HeadNode:ScreenGraphicListNode;
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create():ScreenGraphicList
	{
		var Vessel:ScreenGraphicList;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new ScreenGraphicList();
		}
		
		return Vessel;
	}
	
	public function Add(Element:IScreenGraphic):RueNodeConnection //CHANGE ME TO THE PROPER ELEMENT TO ADD
	{
		var Addition:ScreenGraphicListNode = ScreenGraphicListNode.Create(Element, Self);
		var Connection:RueNodeConnection = Element.ConnectToNode(Addition); //this will return a handle to the link itself, this can be cached and told to recycle to remove itself from the list it resides in both sides.
		Addition._TargetNode = Connection;
		return Connection;
	}
	
	public function Clear():Void //never ever remove a single element from the list, let the elements be removed from the object itself when it recycles
	{
		while (_HeadNode != null)
		{
			_HeadNode.Remove();
		}
	}
	
	public function DrawAll(ParentX:Float, ParentY:Float, Canvas:DrawStack, CameraBound:Bool):Void
	{
		var Current:ScreenGraphicListNode = _HeadNode;
		while (Current != null)
		{
			Current._Target.DrawFrom(ParentX, ParentY, Canvas, CameraBound);
			Current = Current._NextNode;
		}
	}
	
	public function ChangeAlphaOfAllTo(Alpha:Float):Void
	{
		var Current:ScreenGraphicListNode = _HeadNode;
		while (Current != null)
		{
			Current._Target.SetAlpha(Alpha);
			Current = Current._NextNode;
		}
	}
	
	public function RecycleElements():Void
	{
		while (_HeadNode != null)
		{
			_HeadNode._Target.Recycle();
		}
	}
	
	public function Count():Int
	{
		var count:Int = 0;
		var Current:ScreenGraphicListNode = _HeadNode;
		while (Current != null)
		{
			count++;
			Current = Current._NextNode;
		}
		
		return count;
	}
	
	public function Recycle():Void
	{
		Next = Head;
		Head = Self;
		while (_HeadNode != null)
		{
			_HeadNode.Remove();
		}
	}
}

class ScreenGraphicListNode implements RueNodeConnection
{
	static var Head:ScreenGraphicListNode;
	var Next:ScreenGraphicListNode;
	var Self:ScreenGraphicListNode;
	
	public var _Owner:ScreenGraphicList;
	public var _Target:IScreenGraphic; //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	public var _TargetNode:RueNodeConnection;
	
	public var _NextNode:ScreenGraphicListNode;
	public var _PreviousNode:ScreenGraphicListNode;
	
	private function new() { Self = this; }
	
	public static function Create(Target:IScreenGraphic, Owner:ScreenGraphicList):ScreenGraphicListNode //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	{
		var Vessel:ScreenGraphicListNode;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new ScreenGraphicListNode();
		}
		Vessel._PreviousNode = null;
		Vessel._NextNode = null;
		
		Vessel._Target = Target;
		Vessel._Owner = Owner;
		
		if (Owner._HeadNode != null)
		{
			Vessel._NextNode = Owner._HeadNode;
			Owner._HeadNode._PreviousNode = Vessel;
		}
		
		Owner._HeadNode = Vessel;
		
		
		return Vessel;
	}
	
	public function Remove():Void
	{
		_TargetNode.Recycle();
		Recycle();
	}

	public function Recycle():Void
	{
		//remove from the list it lives in, return to the pool, let the element go
		if (_Owner._HeadNode == Self)
		{
			//surprise, you are the head
			if (_NextNode != null)
			{
				//oh noes, you have a child
				_NextNode._PreviousNode = null; //tell your child to forget about you
				_Owner._HeadNode = _NextNode; //and now your child is the head.
			}
			else
			{
				_Owner._HeadNode = null;
			}
		}
		else
		{
			//well you are not the head
			if (_PreviousNode != null)
			{
				_PreviousNode._NextNode = _NextNode;
			}
			if (_NextNode != null)
			{
				_NextNode._PreviousNode = _PreviousNode;
			}
		}
		
		Next = Head;
		Head = Self;
	}
}