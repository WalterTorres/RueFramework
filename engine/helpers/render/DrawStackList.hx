package engine.helpers.render;
import engine.base.RueObject;

/**
 * ...
 * @author Jakegr
 */

class DrawStackList 

{
	static var Head:DrawStackList;
	var Next:DrawStackList;
	var Self:DrawStackList;
	
	public var _HeadNode:DrawStackListNode;
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create():DrawStackList
	{
		var Vessel:DrawStackList;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new DrawStackList();
		}
		
		return Vessel;
	}
	
	public function Add(Element:DrawStack):RueNodeConnection //CHANGE ME TO THE PROPER ELEMENT TO ADD
	{
		var Addition:DrawStackListNode = DrawStackListNode.Create(Element, Self);
		var Connection:RueNodeConnection = Element.ConnectToNode(Addition); //this will return a handle to the link itself, this can be cached and told to recycle to remove itself from the list it resides in both sides.
		Addition._TargetNode = Connection;
		return Connection;
	}
	
	public function RenderAll():Void
	{
		var Current:DrawStackListNode = _HeadNode;
		if (Current != null)
		{
			while (Current._NextNode != null)
			{
				Current = Current._NextNode; //find the end.
			}
			while (Current != null)
			{
				Current._Target.RenderAll();
				Current = Current._PreviousNode;
			}
		}
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
		Next = Head;
		Head = Self;
		while (_HeadNode != null)
		{
			_HeadNode.Remove();
		}
	}
}

class DrawStackListNode implements RueNodeConnection
{
	static var Head:DrawStackListNode;
	var Next:DrawStackListNode;
	var Self:DrawStackListNode;
	
	public var _Owner:DrawStackList;
	public var _Target:DrawStack; //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	public var _TargetNode:RueNodeConnection;
	
	public var _NextNode:DrawStackListNode;
	public var _PreviousNode:DrawStackListNode;
	
	private function new() { Self = this; }
	
	public static function Create(Target:DrawStack, Owner:DrawStackList):DrawStackListNode //CHANGE ME TO THE PROPER ELEMENT TO HOLD
	{
		var Vessel:DrawStackListNode;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new DrawStackListNode();
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