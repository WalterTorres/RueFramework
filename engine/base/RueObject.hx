package engine.base;
import engine.systems.RebirthSystem;

interface RueNodeConnection
{
	//function ConnectionIsBeingRecycled():Void;
	function Recycle():Void;
	function Remove():Void;
}

/**
 * ...
 * @author Jakegr
 */

 //this class is used for indexing and identification of an element inside a collection, since all elements are indexable everything needs to inherit from rueobject
class RueObject
{
	public var SelfRoot:RueObject;
	public var _RueHeadNode:RueObjectNode; //head node connection
	public var InPool:Bool;

	private function new() 
	{
		World.Tracking++;
		SelfRoot = this;
		InPool = false;
	}
	
	public function Recycle():Void
	{
		if (!InPool)
		{
			while (_RueHeadNode != null)
			{
				_RueHeadNode.Remove();
			}
			InPool = true;
			RebirthSystem.Purgatory.Add(SelfRoot);
		}
	}
	
	public function PurgatoryRecycle():Void
	{
		_RueHeadNode.Remove(); //this should suffice since the only list containing this element at this point should be the rebirth list.
	}
	
	public function OnRebirth():Void
	{
		//override me to get back in the pool.
	}
	
	public inline function ConnectToNode(Node:RueNodeConnection):RueNodeConnection
	{
		var NewNode:RueObjectNode = RueObjectNode.Create(SelfRoot, Node);
		if (_RueHeadNode != null)
		{
			_RueHeadNode._PreviousNode = NewNode;
			NewNode._NextNode = _RueHeadNode;
		}
		_RueHeadNode = NewNode;
		return _RueHeadNode;
	}
}

class RueObjectNode implements RueNodeConnection
{
	private static var Head:RueObjectNode;
	private var Next:RueObjectNode;
	private var Self:RueObjectNode;
	
	public var _Owner:RueObject;
	public var _Target:RueNodeConnection;//this is the other end of the bridge that connects a RueObject with a collection using the mirror pattern
	
	public var _NextNode:RueObjectNode;
	public var _PreviousNode:RueObjectNode;
	
	private function new()
	{
		Self = this;
	}
	
	public static function Create(Owner:RueObject, Target:RueNodeConnection):RueObjectNode
	{
		var Vessel:RueObjectNode;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new RueObjectNode();
		}

		Vessel._Owner = Owner;
		Vessel._Target = Target;
		Vessel._NextNode = null;
		Vessel._PreviousNode = null;
		
		return Vessel;
	}
	
	public function Remove():Void
	{
		_Target.Recycle();
		Recycle();
	}
	
	public function Recycle():Void
	{
		if (_Owner._RueHeadNode == Self)
		{
			//surprise, you are the head
			if (_NextNode != null)
			{
				//oh noes, you have a child
				_NextNode._PreviousNode = null; //tell your child to forget about you
				_Owner._RueHeadNode = _NextNode; //and now your child is the head.
			}
			else
			{
				_Owner._RueHeadNode = null;
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