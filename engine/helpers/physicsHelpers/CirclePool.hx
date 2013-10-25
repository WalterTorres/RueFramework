package engine.helpers.physicsHelpers;

import nape.shape.Polygon;
import nape.shape.Circle;
import nape.shape.Shape;
import nape.phys.Body;
import nape.phys.BodyType;

/**
 * ...
 * @author Jakegr
 */

class CirclePool 
{
	static var Head:CirclePool;
	var Next:CirclePool;
	var Self:CirclePool;
	
	public var _Body:Body;
	public var _Shape:Circle;
	
	private function new() 
	{
		Self = this;
		_Shape = new Circle(10);
		_Shape.material.elasticity=0.5;
        _Shape.material.density=1;
        _Shape.material.staticFriction=0;
	}
	
	public static function Create(theBody:Body, Radius:Float):CirclePool
	{
		var Vessel:CirclePool;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new CirclePool();
		}
		
		Vessel._Body = theBody;
		Vessel._Shape.radius = Radius;
		theBody.shapes.add(Vessel._Shape);
		
		return Vessel;
	}
	
	public function Recycle():Void
	{
		_Body.type = BodyType.DYNAMIC;
		_Body.shapes.remove(_Shape);
		Next = Head;
		Head = Self;
	}
		
	
}