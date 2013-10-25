package engine.helpers;
/**
 * ...
 * @author Jakegr
 */

class RueLine 
{
	static var Head:RueLine;
	var Next:RueLine;
	var Self:RueLine;
	
	public var StartX:Float;
	public var StartY:Float;
	
	public var EndX:Float;
	public var EndY:Float;
	
	var VectorX:Float;
	var VectorY:Float;
	
	var NormalX:Float;
	var NormalY:Float;

	var LenghtSquared:Float;
	var Lenght:Float;
	
	var Angle:Float;

	private function new() 
	{
		Self = this;
	}
	
	public static function Create(StartX:Float, StartY:Float, EndX:Float, EndY:Float):RueLine
	{
		var Vessel:RueLine;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new RueLine();
		}
		
		Vessel.StartX = StartX;
		Vessel.StartY = StartY;
		
		Vessel.EndX = EndX;
		Vessel.EndY = EndY;

		Vessel.VectorX = EndX - StartX;
		Vessel.VectorY = EndY - StartY;
		
		Vessel.NormalX = -Vessel.VectorY;
		Vessel.NormalY = Vessel.VectorX;	
		
		var AbsNormX:Float = RueMath.Abs(Vessel.NormalX);
		var AbsNormY:Float = RueMath.Abs(Vessel.NormalY);
		
		if (AbsNormX == AbsNormY)
		{
			Vessel.NormalX *= -1;
			Vessel.NormalY *= -1;
		}
		else if (AbsNormX >= AbsNormY)
		{
			if (Vessel.VectorY > 0) //Y is going downwards, X must be positive
			{
				if (Vessel.NormalX < 0)
				{
					//flip it
					Vessel.NormalX *= -1;
					Vessel.NormalY *= -1;
				}
			}
			else //Y is going upwards, X must be negative
			{
				if (Vessel.NormalX > 0)
				{
					//flip it
					Vessel.NormalX *= -1;
					Vessel.NormalY *= -1;
				}
			}
		}
		else
		{
			if (Vessel.NormalY > 0)
			{
				//flip it
				Vessel.NormalX *= -1;
				Vessel.NormalY *= -1;
			}
		}
		
		Vessel.LenghtSquared = (Vessel.VectorX * Vessel.VectorX) + (Vessel.VectorY * Vessel.VectorY);
		
		Vessel.Lenght = Math.sqrt(Vessel.LenghtSquared);
		Vessel.NormalX /= Vessel.Lenght;
		Vessel.NormalY /= Vessel.Lenght;
		
		Vessel.Angle = Math.atan2(Vessel.VectorY, Vessel.VectorX);
		
		return Vessel;
	}
	
	public inline function CheckVSCircle(Cir:RueCircle):Bool
	{
		//projection step
		var StartToCircleX:Float = Cir._X - StartX;
		var StartToCircleY:Float = Cir._Y - StartY;
		
		var StartPlusVecX:Float = VectorX;
		var StartPlusVecY:Float = VectorY;
		
		var dotProduct:Float = (StartPlusVecX * StartToCircleX + StartPlusVecY * StartToCircleY) / LenghtSquared;
		
		if (dotProduct > 1)
		{
			dotProduct = 1;
		}
		else if (dotProduct < 0)
		{
			dotProduct = 0;
		}
		
		var ProjectedX:Float = (dotProduct * StartPlusVecX);
		var ProjectedY:Float = (dotProduct * StartPlusVecY);
		
		var HeightLenghtSquared:Float = RueMath.Square(ProjectedX - StartToCircleX) + RueMath.Square(ProjectedY - StartToCircleY);
		
		return HeightLenghtSquared < RueMath.Square(Cir._Radius);
	}


	public function Recycle():Void
	{
		Next = Head;
		Head = Self;
	}
		
	
}