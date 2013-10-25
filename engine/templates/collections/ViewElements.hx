package engine.templates.collections;
import engine.base.RueObject;
import engine.templates.RueView;

/**
 * ...
 * @author Jakegr
 */

class ViewElements
{
	static var Head:ViewElements;
	var Next:ViewElements;
	var Self:ViewElements;
	
	public var _HeadNode:ViewElementsNode;
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create():ViewElements
	{
		var Vessel:ViewElements;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new ViewElements();
		}
		
		return Vessel;
	}
	
	public function Add(Element:RueView):RueNodeConnection 
	{
		var Addition:ViewElementsNode = ViewElementsNode.Create(Element, Self);
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
	
	public function Render(X:Float, Y:Float):Void
	{
		var Current:ViewElementsNode = _HeadNode;
		if (Current == null) { return; }
		while (Current._NextNode != null)
		{
			Current = Current._NextNode; //find the end.
		}
		while (Current != null)
		{
			Current._Target.Render(X, Y);
			Current = Current._PreviousNode;
		}
	}
	
	public function CheckInput(X:Float, Y:Float, ParentX:Float, ParentY:Float):RueView
	{
		var Current:ViewElementsNode = _HeadNode;
		while (Current != null)
		{
			var Result:RueView = Current._Target.CheckScreenInput(X, Y, ParentX, ParentY);
			if ( Result != null)
			{
				return Result;
			}
			Current = Current._NextNode;
		}
		
		return null;
	}
	
	public function CancelAllDrags():Void
	{
		var Current:ViewElementsNode = _HeadNode;
		while (Current != null)
		{
			Current._Target.CancelDrags();
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

class ViewElementsNode implements RueNodeConnection
{
	static var Head:ViewElementsNode;
	var Next:ViewElementsNode;
	var Self:ViewElementsNode;
	
	public var _Owner:ViewElements;
	public var _Target:RueView; 
	public var _TargetNode:RueNodeConnection;
	
	public var _NextNode:ViewElementsNode;
	public var _PreviousNode:ViewElementsNode;
	
	private function new() { Self = this; }
	
	public static function Create(Target:RueView, Owner:ViewElements):ViewElementsNode 
	{
		var Vessel:ViewElementsNode;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new ViewElementsNode();
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
		if (_Owner._HeadNode == Self)
		{
			if (_NextNode != null)
			{
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