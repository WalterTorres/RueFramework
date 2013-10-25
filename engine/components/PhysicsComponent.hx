package engine.components;

import engine.base.Entity;
import engine.helpers.delegates.ICollisionListener;
import engine.helpers.delegates.IDamage;
import engine.helpers.delegates.IDamageable;
import engine.World;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2List;
import nape.phys.Body;
import nape.shape.Shape;

import nape.space.Space;
import nape.util.Debug;
import nape.util.BitmapDebug;
import nape.shape.Polygon;
import nape.callbacks.CbType;
import nape.callbacks.InteractionListener;
import nape.callbacks.CbEvent;
import nape.geom.Vec2;
import nape.phys.BodyType;

import engine.helpers.physicsHelpers.RectanglePool;
import engine.helpers.physicsHelpers.CirclePool;

/**
 * ...
 * @author Jakegr
 */

enum CollisionType
{
	PLAYER;
	ENEMY;
	AFFECTS_PLAYER;
	AFFECTS_ENEMY;
	AFFECTS_ALL;
	MISC;
}

class PhysicsComponent 
{
	//static vector to pass around
	static var PassingVector:Vec2 = Vec2.get();

	//nape body
	public var NapeBody:Body;
	public var TheRectangle:RectanglePool;
	public var TheCircle:CirclePool;
	public var Position:Vec2;
	//
	static var Head:PhysicsComponent;
	var Next:PhysicsComponent;
	var Self:PhysicsComponent;
	
	//delegates holders
	public var DamageDealer:IDamage;
	public var DamageReceiver:IDamageable;
	public var CollisionListener:ICollisionListener;
	
	//float positions
	public var PositionX:Float;
	public var PositionY:Float;
	
	//half sizes
	public var HalfWidth:Float;
	public var HalfHeight:Float;
	
	private function new() 
	{
		Self = this;
		NapeBody = new Body(BodyType.DYNAMIC, Vec2.get());
	}
	
	public static function CreateCircle(X:Float, Y:Float, TheType:BodyType, Radius:Float,
										Offset:Float = 0, mass:Float = 1):PhysicsComponent
	{
		var Vessel:PhysicsComponent;
		if (Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new PhysicsComponent(); }
		Vessel.HalfWidth = Radius;
		Vessel.HalfHeight = Radius;
		Vessel.PositionX = X;
		Vessel.PositionY = Y;
		Vessel.NapeBody.type = TheType;
		Vessel.NapeBody.userData.Physics = Vessel;
		Vessel.NapeBody.position.setxy(X + Radius, Y + Radius);
		Vessel.NapeBody.rotation = 0;
		Vessel.NapeBody.mass = mass;
		Vessel.Position = Vessel.NapeBody.position;
		var TheCircle:CirclePool = CirclePool.Create(Vessel.NapeBody, Radius);
		TheCircle._Shape.localCOM.setxy(Offset, Offset);
		Vessel.TheCircle = TheCircle;
		World.TheSpace.bodies.add(Vessel.NapeBody);
		return Vessel;
	}
	
	public static function CreateRectangle(X:Float, Y:Float, TheType:BodyType, Width:Float, Height:Float,
										   OffsetWidth:Float = 0, OffsetHeight:Float = 0, mass:Float = 1):PhysicsComponent
	{
		var Vessel:PhysicsComponent;
		if (Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new PhysicsComponent(); }
		Vessel.HalfWidth = Width*0.5;
		Vessel.HalfHeight = Height*0.5;
		Vessel.PositionX = X;
		Vessel.PositionY = Y;
		Vessel.NapeBody.type = TheType;
		Vessel.NapeBody.userData.Physics = Vessel;
		Vessel.NapeBody.position.setxy(X + Vessel.HalfWidth, Y + Vessel.HalfHeight);
		Vessel.NapeBody.rotation = 0;
		Vessel.NapeBody.mass = mass;
		Vessel.Position = Vessel.NapeBody.position;
		var TheRectangle:RectanglePool = RectanglePool.Create(Vessel.NapeBody, Width, Height, OffsetWidth, OffsetHeight);
		Vessel.TheRectangle = TheRectangle;
		World.TheSpace.bodies.add(Vessel.NapeBody);
		return Vessel;
	}
	
	public inline function SetUniqueCBType(TypeToBeUnique:CbType):Void
	{
		NapeBody.cbTypes.clear();
		NapeBody.cbTypes.add(TypeToBeUnique);
	}
	
	public inline function AddCBType(TypeToAdd:CbType):Void
	{
		NapeBody.cbTypes.add(TypeToAdd);
	}
	
	public inline function SetFilter(FilterToSet:InteractionFilter):Void
	{
		NapeBody.setShapeFilters(FilterToSet);
	}
	
	public inline function GetShape():Shape
	{
		if (TheRectangle != null) { return TheRectangle._Shape; }
		else { return TheCircle._Shape; }
	}
	
	public inline function SetMass(newMass:Float):Void
	{
		NapeBody.mass = newMass;
	}
	
	public inline function AdjustGraphicsPosition():Void
	{
		PositionX = Position.x-HalfWidth;
		PositionY = Position.y-HalfHeight;
	}
	
	public function ContainsPoint(X:Float, Y:Float):Bool
	{
		var AddX:Float = 0;
		var AddY:Float = 0;
		
		if (TheRectangle != null)
		{
			AddX = TheRectangle._Width * 0.5;
			AddY = TheRectangle._Height * 0.5;
		}
		PassingVector.x = X-AddX;
		PassingVector.y = Y-AddY;
		return NapeBody.contains(PassingVector);
	}
	
	public function ContainsPhysicsPoint(X:Float, Y:Float):Bool
	{
		PassingVector.x = X;
		PassingVector.y = Y;
		return NapeBody.contains(PassingVector);
	}
	
	public function ContainsRect(X:Float, Y:Float, Width:Float, Height:Float):Bool
	{
		if (ContainsPhysicsPoint(X, Y))
		{
			if (ContainsPhysicsPoint(X + Width, Y + Height))
			{
				return true;
			}
		}
		return false;
	}
	
	public function ChangeWidthAndHeight(Width:Float, Height:Float):Void
	{
		if (TheRectangle != null)
		{
			var HalfWidth = Width / 2;
			var HalfHeight = Height / 2;
			
			var AddX:Float = TheRectangle._OffsetX;
			var AddY:Float = TheRectangle._OffsetY;
			
			TheRectangle._Shape.localVerts.at(0).setxy( -HalfWidth+AddX, -HalfHeight+AddY);
			TheRectangle._Shape.localVerts.at(1).setxy(HalfWidth+AddX, -HalfHeight+AddY);
			TheRectangle._Shape.localVerts.at(2).setxy(HalfWidth+AddX, HalfHeight+AddY);
			TheRectangle._Shape.localVerts.at(3).setxy( -HalfWidth + AddX, HalfHeight + AddY);
		}
		else
		{
			if (TheCircle != null)
			{
				var CalculatedNewRadius = Width * Height;
				TheCircle._Shape.radius = CalculatedNewRadius;
			}
		}
	}
	
	public function Recycle():Void
	{
		//recycle the types
		NapeBody.cbTypes.clear();
		//recycle the body
		if (TheRectangle != null)
		{
			TheRectangle.Recycle();
			TheRectangle = null;
		}
		if (TheCircle != null)
		{
			TheCircle.Recycle();
			TheCircle = null;
		}
		//unsubscribe the body
		World.TheSpace.bodies.remove(NapeBody);
		NapeBody.velocity.setxy(0, 0);
		NapeBody.angularVel = 0;

		Next = Head;
		Head = Self;
		
		//clean up all the listeners.
		DamageDealer = null;
		DamageReceiver = null;
		CollisionListener = null;
	}
		
	
}