package engine.helpers;

import haxe.Timer;
import flash.display.Sprite;
import flash.text.TextField;
/**
 * ...
 * @author Jakegr
 */

class Profiler 
{
	static var LastTime:Float;
	public static var ElapsedTime:Float;
	public static var FPS:Int;
	
	public static var Text:TextField;
	public static var InternalTick:Float;
	private static var TickCount:Int;
	public static var IsPaused:Bool;
	private static var TheStage:Sprite;
	
	static var ReportAllowed:Bool;
	
	private static var TimersCollection:Array<RueTimer>;
	
	private static var ReportingTimer:Float;
	
	private static var RenderTarget:Sprite;
	
	public static function Init(Stage:Sprite):Void
	{
		IsPaused = false;
		InternalTick = 0;
		LastTime = 0;
		ElapsedTime = 0;
		
		RenderTarget = Stage;
		
		Text = new TextField();
		Text.scaleX = 2;
		Text.scaleY = 2;
		Text.width = 20;
		Text.height = 20;
		Stage.addChild(Text);
	
		TheStage = Stage;
		
		TimersCollection = new Array<RueTimer>();
		ReportAllowed = false;
	}
	
	public static function AddTimer(Name:String):Int
	{
		TimersCollection.push(new RueTimer(TheStage, TimersCollection.length, Name));
		return TimersCollection.length - 1;
	}
	
	public function HideFPS():Void
	{
		RenderTarget.removeChild(Text);
	}
	
	public function ShowFPS():Void
	{
		RenderTarget.addChild(Text);
	}
	
	public static function Start(ID:Int):Void
	{
	
		TimersCollection[ID].Start();
		
	}
	
	public static function Stop(ID:Int):Void
	{
		
		TimersCollection[ID].Stop();
		
	}

	private function new() 
	{
		
	}
	
	public static function Tick():Void
	{
		ElapsedTime = Timer.stamp() - LastTime;
		LastTime = Timer.stamp();
		InternalTick += ElapsedTime;
		TickCount++;
		if (InternalTick >= 1.0)
		{
			ReportAllowed = true;
			InternalTick -= 1.0;
			FPS = TickCount;
			
			Text.text = cast(FPS);// + " SpriteCount: " + cast(MaxEntity.Count);
			
			TickCount = 0;
		}
	}
	
	public static function Report():Void
	{
		if (ReportAllowed)
		{
			ReportAllowed = false;
			for (i in 0...TimersCollection.length)
			{
				TimersCollection[i].Report();
			}
		}
	}
}

class RueTimer
{
	public var ElapsedTime:Float;
	var Stamp:Float;
	var Texto:TextField;
	var Name:String;
	
	public function new(Stage:Sprite, Index:Int, dName:String)
	{
		Name = dName;
		ElapsedTime = 0;
		Texto = new TextField();
		Texto.x = 10;
		Texto.y = 30 + 14 * Index;
		Texto.width = 100;
		Stage.addChild(Texto);
		
	}
	
	public function Start():Void
	{
		Stamp = Timer.stamp();
	}
	
	public function Stop():Void
	{
		ElapsedTime += (Timer.stamp() - Stamp);
	}
	
	public function Report():Void
	{
		Texto.text = Name + " " + ElapsedTime;
		ElapsedTime = 0.0;
	}
	
}