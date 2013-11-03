package engine.components;

import engine.helpers.render.DrawStack;
import engine.helpers.TileDesc;
import engine.helpers.TileSheetEntry;
import engine.systems.TileRenderSystem;
import engine.World;
import flash.display.BitmapData;
import engine.helpers.Profiler;
import flash.display.Sprite;
import flash.geom.Point;
import engine.helpers.collections.DrawNode;
import openfl.display.Tilesheet;

/**
 * ...
 * @author Jakegr
 */

class GraphicsComponent 
{
	static var Head:GraphicsComponent;
	var Next:GraphicsComponent;
	var Self:GraphicsComponent;
	
	public var CurrentFrame:Int;
	public var MaxFrame:Int;
	public var Description:TileDesc;
	public var ElapsedTime:Float;
	public var CurrentDelay:Float;
	public var Rotation:Float;
	
	public var CameraRatioX:Float;
	public var CameraRatioY:Float;
	
	public var TargetCanvas:DrawStack;
	public var Layer:Int;
	public var Alpha:Float;
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create(Description:TileDesc, Target:DrawStack, Layer:Int = 0, CamXRatio:Float = 1.0, CamYRatio:Float = 1.0):GraphicsComponent
	{
		var Vessel:GraphicsComponent;
		if(Head != null){Vessel = Head;Head = Head.Next;}
		else{Vessel = new GraphicsComponent();}
		
		Vessel.Description = Description;
		Vessel.CurrentFrame = 0;
		Vessel.ElapsedTime = 0;
		Vessel.Rotation = 0;
		Vessel.Alpha = 1.0;
		Vessel.CurrentDelay = Vessel.Description.DS[0];
		Vessel.MaxFrame = Vessel.Description.FrameCount;
		Vessel.CameraRatioX = CamXRatio;
		Vessel.CameraRatioY = CamYRatio;
		Vessel.TargetCanvas = Target;
		Vessel.Layer = Layer;
		
		return Vessel;
	}
	
	public function Animate(Speed:Float = 1.0):Void
	{
		ElapsedTime += Profiler.ElapsedTime * Speed;
		if (ElapsedTime >= CurrentDelay)
		{
			CurrentFrame++;
			if (CurrentFrame >= MaxFrame)
			{
				CurrentFrame = 0;
			}
			
			ElapsedTime -= CurrentDelay;
			CurrentDelay = Description.DS[CurrentFrame];
		}
	}
	
	public function ReverseAnimation(Speed:Float = 1.0):Void
	{
		ElapsedTime -= Profiler.ElapsedTime * Speed;
		if (ElapsedTime <= 0)
		{
			CurrentFrame--;
			if (CurrentFrame < 0)
			{
				CurrentFrame = MaxFrame-1;
			}
			
			ElapsedTime += CurrentDelay;
			CurrentDelay = Description.DS[CurrentFrame];
		}
	}
	
	public function ChangeFrame(To:Int):Void
	{
		if (To < MaxFrame)
		{
			CurrentFrame = To;
			ElapsedTime = 0.0;
			CurrentDelay = Description.DS[CurrentFrame];
		}
	}
	
	public function ChangeAnimation(ToThis:TileDesc):Void
	{
		if (Description != ToThis)
		{
			ElapsedTime = 0.0;
			CurrentFrame = 0;
			Description = ToThis;
			CurrentDelay = Description.DS[0];
			MaxFrame = Description.FrameCount;
		}
	}
	
	public function RenderToScreen(X:Float, Y:Float):Void
	{
		var ID:Int = Description.UIDS[CurrentFrame];
		TargetCanvas.AddToRender(Layer, ID, X, Y, Rotation, Alpha);
	}
	
	public function RenderToCamera(X:Float, Y:Float):Void
	{
		var ID:Int = Description.UIDS[CurrentFrame];
		TargetCanvas.AddToRender(Layer, ID, X + TileRenderSystem.CameraX*CameraRatioX, Y + TileRenderSystem.CameraY*CameraRatioY, Rotation, Alpha);
	}
	
	public function Recycle():Void
	{
		Next = Head;
		Head = Self;
	}
		
	
}