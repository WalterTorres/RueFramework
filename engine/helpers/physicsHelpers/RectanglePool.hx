package engine.helpers.physicsHelpers;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Shape;


/**
 * ...
 * @author Jakegr
 */

class RectanglePool 
{
	static var Head:RectanglePool;
	var Next:RectanglePool;
	var Self:RectanglePool;
	
	public var _Body:Body;
	public var _Shape:Polygon;
	public var _Width:Float;
	public var _Height:Float;
	public var _OffsetX:Float;
	public var _OffsetY:Float;
	
	private function new() 
	{
		Self = this;
		_Shape = new Polygon(Polygon.box(1, 10));
	}
	
	public static function Create(theBody:Body, Width:Float, Height:Float, OffsetX:Float, OffsetY:Float):RectanglePool
	{
		var Vessel:RectanglePool;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new RectanglePool();
		}
		
		Vessel._Body = theBody;
		
		Vessel._Width = Width;
		Vessel._Height = Height;
		
		Vessel._OffsetX = OffsetX;
		Vessel._OffsetY = OffsetY;
		
		var HalfWidth = Width / 2;
		var HalfHeight = Height / 2;
		
		Vessel._Shape.localVerts.at(0).setxy( -HalfWidth+OffsetX, -HalfHeight+OffsetY);
		Vessel._Shape.localVerts.at(1).setxy(HalfWidth+OffsetX, -HalfHeight+OffsetY);
		Vessel._Shape.localVerts.at(2).setxy(HalfWidth+OffsetX, HalfHeight+OffsetY);
		Vessel._Shape.localVerts.at(3).setxy( -HalfWidth+OffsetX, HalfHeight+OffsetY);
		
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