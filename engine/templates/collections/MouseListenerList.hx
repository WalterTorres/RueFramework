package engine.templates.collections;
import engine.base.RueObject;
import engine.templates.collections.MouseListenerList.MouseListenerListNode;
import engine.templates.MouseListener;

/**
 * ...
 * @author Jakegr
 */

class MouseListenerList 

{
	static var MouseListenerListHead:MouseListenerList;
	var MouseListenerListNext:MouseListenerList;
	var MouseListenerListSelf:MouseListenerList;
	
	public var _HeadNode:MouseListenerListNode;
	
	private function new() 
	 
	{
		MouseListenerListSelf = this;
	}
	
	public static function Create():MouseListenerList
	{
		var Vessel:MouseListenerList;
		if(MouseListenerListHead != null)
		{
			Vessel = MouseListenerListHead;
			MouseListenerListHead = MouseListenerListHead.MouseListenerListNext;
		}
		else 
		{
			Vessel = new MouseListenerList();
		}
		
		return Vessel;
	}
	
	public function Add(Element:MouseListener):RueNodeConnection //CHANGE ME TO THE PROPER ELEMENT TO ADD
	{
		var Addition:MouseListenerListNode = MouseListenerListNode.Create(Element, MouseListenerListSelf);
		var Connection:RueNodeConnection = Element.ConnectToNode(Addition); //this will return a handle to the link itself, this can be cached and told to recycle to remove itself from the list it resides in both sides.
		Addition._TargetNode = Connection;
		return Connection;
	}
	
	public function CheckInput(X:Float, Y:Float):Bool
	{
		var Current:MouseListenerListNode = _HeadNode;
		while (Current != null)
		{
			if (Current._Target.CheckInput(X, Y))
			{
				return true;
			}
			Current = Current._NextNode;
		}
		
		return false;
	}
	
	public function Clear():Void //never ever remove a single element from the list, let the elements be removed from the object itself when it recycles
	{
		while (_HeadNode != null)
		{
			_HeadNode.Remove();
		}
	}
	
	public function Recycle():Void
	{
		MouseListenerListNext = MouseListenerListHead;
		MouseListenerListHead = MouseListenerListSelf;
		while (_HeadNode != null)
		{
			_HeadNode.Remove();
		}
	}
}

class MouseListenerListNode implements RueNodeConnection
{
	static var MouseListenerListNodeHead:MouseListenerListNode;
	var MouseListenerListNodeNext:MouseListenerListNode;
	var MouseListenerListNodeSelf:MouseListenerListNode;
	
	public var _Owner:MouseListenerList;
	public var _Target:MouseListener; //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	public var _TargetNode:RueNodeConnection;
	
	public var _NextNode:MouseListenerListNode;
	public var _PreviousNode:MouseListenerListNode;
	
	private function new() { MouseListenerListNodeSelf = this; }
	
	public static function Create(Target:MouseListener, Owner:MouseListenerList):MouseListenerListNode //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	{
		var Vessel:MouseListenerListNode;
		if(MouseListenerListNodeHead != null)
		{
			Vessel = MouseListenerListNodeHead;
			MouseListenerListNodeHead = MouseListenerListNodeHead.MouseListenerListNodeNext;
		}
		else 
		{
			Vessel = new MouseListenerListNode();
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
		if (_Owner._HeadNode == MouseListenerListNodeSelf)
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
		
		MouseListenerListNodeNext = MouseListenerListNodeHead;
		MouseListenerListNodeHead = MouseListenerListNodeSelf;
	}
}