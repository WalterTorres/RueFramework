package engine.helpers;

import engine.components.PhysicsComponent;
/**
 * ...
 * @author Jakegr
 */

class RueMath 
{
	public static function SecondsToDateFormat(Seconds:Int):String
	{
		trace("attempting to create date from seconds");
		
		var Hours:Int = Std.int(Seconds / 3600);
		Seconds -= Hours * 3600;
		var Minutes:Int = Std.int(Seconds / 60);
		Seconds -= Minutes * 60;
		//var TheDate:Date = new Date(0, 0, 0, Hours, Minutes, Seconds);
		var comp:String = "" + Hours + "h: " + Minutes + "m: " + Seconds + "s";
		return comp;
	}
	
	/**
	 * Will return a string composed like this: (120 seconds) => 2:00 || (36125 seconds) = 1:02:05
	 * @param	Seconds
	 */
	public static function SecondsToHMS(Seconds:Int):Void
	{
		var Hours:Int = Std.int(Seconds / 3600);
		Seconds -= Hours * 3600;
		var Minutes:Int = Std.int(Seconds / 60);
		Seconds -= Minutes * 60;
		//var TheDate:Date = new Date(0, 0, 0, Hours, Minutes, Seconds);
		var comp:String = "";
		if (Hours > 0)
		{
			if (Minutes > 9)
			{
				if (Seconds > 9)
				{
					comp = "" + Hours + ":" + Minutes + ":" + Seconds;
				}
				else
				{
					comp = "" + Hours + ":" + Minutes + ":0" + Seconds;
				}
			}
			else
			{
				if (Seconds > 9)
				{
					comp = "" + Hours + ":0" + Minutes + ":" + Seconds;
				}
				else
				{
					comp = "" + Hours + ":0" + Minutes + ":0" + Seconds;
				}
			}
		}
		else if (Minutes > 0)
		{
			if (Minutes > 9)
			{
				if (Seconds > 9)
				{
					comp = "" + Minutes + ":" + Seconds;
				}
				else
				{
					comp = "" + Minutes + ":0" + Seconds;
				}
			}
			else
			{
				if (Seconds > 9)
				{
					comp = "" + Minutes + ":" + Seconds;
				}
				else
				{
					comp = "" + Minutes + ":0" + Seconds;
				}
			}
		}
		else if (Seconds > 0)
		{
			if (Seconds > 9)
			{
				comp = "0:" + Seconds;
			}
			else
			{
				comp = "0:0" + Seconds;
			}
		}
		return comp;
	}
	
	//will return in seconds how much time has passed from one date to the other
	/**
	 * 
	 * @param	FromThisDate	The current date that is now
	 * @param	ToThisDate		The past date
	 * @return
	 */
	public static function DeltaTime(FromThisDate:Date, ToThisDate:Date):Int
	{
		return Std.int(DateTools.delta(FromThisDate, -1 * ToThisDate.getTime()).getTime()/1000);
	}
	
	public static function ToFormattedNumberString(pars:Int):String
	{
		var Current:Int = pars;
		var Text:String = Std.string(pars);
		var lenghtOfNumber:Int = Text.length;
		var Times:Int = Std.int(lenghtOfNumber / 3);
		var startPoint:Int =  lenghtOfNumber % 3;
		if (startPoint == 0)
		{
			Times--;
		}
		for (i in 0...Times)
		{
			Text = Text.substr(0, startPoint+i*4) + Text.substr(startPoint + (i * 3) + i, 3) + "," + Text.substr(startPoint + (i * 3) + i + 3, Text.length - startPoint + (i * 3) + i + 3);
		}
		if (startPoint != 0)
		{
			Text = Text.substr(0, startPoint) + "," + Text.substr(startPoint, Text.length - startPoint);
			Text = Text.substring(0, Text.length - 1);
		}
		
		return Text;
	}
	
	public static inline function SameDirection(Val1:Float, Val2:Float):Bool
	{
		return IsNegative(Val1) == IsNegative(Val2);
	}
	
	
	public static inline function Abs(Value:Float):Float
	{
		return Value > 0 ? Value: -Value;
	}
	
	public static inline function IntAbs(value:Int):Int
	{
		return value > 0 ? value: -value; 
	}
	
	public static inline function LenSquared(StartPoint:Float, EndPoint:Float):Float
	{
		var Result:Float = StartPoint - EndPoint;
		Result *= Result;
		return Result;
	}
	
	public static inline function IsNegative(Value:Float):Bool
	{
		return Value > 0? false: true;
	}
	
	public static inline function AbsoluteDirection(Value:Float):Int
	{
		return Value > 0? 1: -1;
	}
	
	public static inline function IntAbsoluteDirection(Value:Int):Int
	{
		return Value > 0? 1: -1;
	}
	
	public static inline function RandRange():Float
	{
		return Math.random() * 2 - 1;
	}
	
	public static inline function Magnitude(X:Float, Y:Float):Float
	{
		return Math.sqrt((X * X) + (Y * Y));
	}
	
	public static inline function SquareMagnitude(X:Float, Y:Float):Float
	{
		return (X * X) + (Y * Y);
	}
	
	public static inline function Square(Value:Float):Float
	{
		return Value * Value;
	}
	
	public static inline function Lerp(Start:Float, End:Float, Interval:Float):Float
	{
		if (Interval > 1.0) { Interval = 1.0; }
		else if (Interval < 0.0) { Interval = 0.0; }
		return Start + ((End-Start) * Interval);
	}
	
	public static inline function Lerp3(Start:Float, End:Float, Interval:Float):Float
	{
		if (Interval > 1.0) { Interval = 1.0; }
		else if (Interval < 0.0) { Interval = 0.0; }
		return Start + ((End-Start) * (3*Square(Interval)-2*Cube(Interval)));
	}
	
	public static inline function Lerp3Inverted(Start:Float, End:Float, Interval:Float):Float
	{
		if (Interval > 1.0) { Interval = 1.0; }
		else if (Interval < 0.0) { Interval = 0.0; }
		return Start + ((End-Start) * ((3*Square(Interval)-2*Cube(Interval)))/Interval );
	}
	
	public static inline function BezierInterpolation(InitialX:Float, InitialY:Float, MidX:Float, MidY:Float, FinalX:Float, FinalY:Float, Target:PhysicsComponent, Completion:Float):Bool
	{
		var CompletetionDone:Bool = false;
		if (Completion >= 1)
		{
			Target.Position.setxy(FinalX, FinalY);
			Target.AdjustGraphicsPosition();
			CompletetionDone = true;
		}
		
		if (!CompletetionDone)
		{
			var TDelta:Float = 1 - Completion;
			var X:Float = InitialX * Square(TDelta) + MidX * 2 * (TDelta) * Completion + FinalX * Square(Completion);
			var Y:Float = InitialY * Square(TDelta) + MidY * 2 * (TDelta) * Completion + FinalY * Square(Completion);
			Target.NapeBody.position.setxy(X, Y);
			Target.AdjustGraphicsPosition();
		}
		
		return CompletetionDone;
	}
	
	public static inline function Cube(Value:Float):Float
	{
		return Value * Value * Value;
	}
	
	private function new() 
	{
		
	}
	
	
	
}