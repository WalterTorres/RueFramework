package engine.templates.collections;
import engine.base.RueObject;

/**
 * ...
 * @author Jakegr
 */

class RueCallbackList extends RueObject
{
	static var Head:RueCallbackList;
	var Next:RueCallbackList;
	var Self:RueCallbackList;
	
	public var _HeadNode:RueCallbackListNode;
	
	private function new() 
	{
		
		super();
		Self = this;
	}
	
	public static function Create():RueCallbackList
	{
		var Vessel:RueCallbackList;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new RueCallbackList();
		}
		Vessel.InPool = false;
		
		return Vessel;
	}
	
	public function Add(Element:RueCallback):RueNodeConnection //CHANGE ME TO THE PROPER ELEMENT TO ADD
	{
		var Addition:RueCallbackListNode = RueCallbackListNode.Create(Element, Self);
		var Connection:RueNodeConnection = Element.ConnectToNode(Addition); //this will return a handle to the link itself, this can be cached and told to recycle to remove itself from the list it resides in both sides.
		Addition._TargetNode = Connection;
		return Connection;
	}
	
	public function TriggerAll():Void
	{
		var Current:RueCallbackListNode = _HeadNode;
		while (Current != null)
		{
			Current._Target._Function();
			Current = Current._NextNode;
		}
	}
	
	public function RecycleAll():Void
	{
		while (_HeadNode != null)
		{
			_HeadNode._Target.Recycle();
		}
	}
	
	public function Clear():Void //never ever remove a single element from the list, let the elements be removed from the object itself when it recycles
	{
		while (_HeadNode != null)
		{
			_HeadNode.Remove();
		}
	}
	
	override public function Recycle():Void
	{
		if (!InPool)
		{
			RecycleAll();
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void 
	{
		Next = Head;
		Head = Self;
	}
}

class RueCallbackListNode implements RueNodeConnection
{
	static var Head:RueCallbackListNode;
	var Next:RueCallbackListNode;
	var Self:RueCallbackListNode;
	
	public var _Owner:RueCallbackList;
	public var _Target:RueCallback; //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	public var _TargetNode:RueNodeConnection;
	
	public var _NextNode:RueCallbackListNode;
	public var _PreviousNode:RueCallbackListNode;
	
	private function new() { Self = this; }
	
	public static function Create(Target:RueCallback, Owner:RueCallbackList):RueCallbackListNode //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	{
		var Vessel:RueCallbackListNode;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new RueCallbackListNode();
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