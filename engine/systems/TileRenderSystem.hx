package engine.systems;
import engine.helpers.collections.TileSheetList;
import engine.helpers.Profiler;
import engine.helpers.render.DrawStack;
import engine.helpers.render.DrawStackList;
import engine.helpers.RueMath;
import engine.helpers.TileSheetEntry;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import engine.World;

import nape.util.Debug;
import nape.util.BitmapDebug;

/**
 * ...
 * @author Jakegr
 */

class TileRenderSystem 
{
	public static var LetterBoxOffsetX:Float = 0;
	public static var LetterBoxOffsetY:Float = 0;
	
	public static var ActualScaleX:Float = 1;
	public static var ActualScaleY:Float = 1;
	
	public static var CameraX:Float = 0;
	public static var CameraY:Float = 0;
	
	public static var NapeCameraX:Float = 0;
	public static var NapeCameraY:Float = 0;
	
	public static var CenterCamX:Float = 0;
	public static var CenterCamY:Float = 0;
	
	public static var TargetX:Float = 0;
	public static var TargetY:Float = 0;
	
	public static var InitialHalfWidth:Float = 0;
	public static var InitialHalfHeight:Float = 0;
	
	public static var HalfWidth:Float = 0;
	public static var HalfHeight:Float = 0;
	
	public static var Layers:DrawStackList = DrawStackList.Create();
	
	public static var ScreenRenderTarget:Sprite;
	public static var BackgroundRenderTarget:Sprite;
	
	public static var Zoom:Float = 1.0;

	public static function Init(StageWidth:Float, StageHeight:Float, ScreenRT:Sprite, GuiRT:Sprite, BackGRT:Sprite):Void
	{
		InitialHalfWidth = StageWidth * 0.5;
		InitialHalfHeight = StageHeight * 0.5;
		ScreenRenderTarget = ScreenRT;
		BackgroundRenderTarget = BackGRT;
		SetZoom(1.0);
		TileSheetEntry.TheGraphics = ScreenRT.graphics;
		TileSheetEntry.TheGuiGraphics = GuiRT.graphics;
		TileSheetEntry.TheBGGraphics = BackGRT.graphics;
	}
	
	public static function SetZoom(Value:Float):Void
	{
		Zoom = Value;
		HalfWidth = InitialHalfWidth * Zoom;
		HalfHeight = InitialHalfHeight * Zoom;
		ScreenRenderTarget.x = -HalfWidth + InitialHalfWidth;
		ScreenRenderTarget.y = -HalfHeight + InitialHalfHeight;
		ScreenRenderTarget.scaleX = Zoom;
		ScreenRenderTarget.scaleY = Zoom;
		
		BackgroundRenderTarget.x = -HalfWidth + InitialHalfWidth;
		BackgroundRenderTarget.y = -HalfHeight + InitialHalfHeight;
		BackgroundRenderTarget.scaleX = Zoom;
		BackgroundRenderTarget.scaleY = Zoom;
	}
	
	public static function Render():Void
	{
		TileSheetEntry.TheGraphics.clear();
		TileSheetEntry.TheGuiGraphics.clear();
		TileSheetEntry.TheBGGraphics.clear();
		DrawStack.Layers.RenderAll();
		
		//draw the letter box
	}
	
	public static function AdjustBody():Void
	{
		CameraX = -TargetX * Zoom + InitialHalfWidth;
		CameraY = -TargetY * Zoom + InitialHalfHeight;
	}
	
	public static function InterpolateZoom(Towards:Float, AtRate:Float = 0.06):Void
	{
		if (Towards > 1) { Towards = 1; }
		if (Towards == Zoom) { return; }
		
		if (Zoom < Towards)
		{
			Zoom += Profiler.ElapsedTime*AtRate;
			if (Zoom > 1) { Zoom = 1; }
			else if (Zoom > Towards) { Zoom = Towards; }
		}
		else
		{
			Zoom -= Profiler.ElapsedTime * AtRate;
			if (Zoom < 0) { Zoom = 0; }
			else if (Zoom < Towards) { Zoom = Towards; }
		}
		
		SetZoom(Zoom);
	}
	
	public static function InterpolateX(Towards:Float, AtPerTick:Float):Void
	{
		var Delta:Float = Towards - TargetX;
		if (Delta == 0)
		{
			return;
		}
		var Direction:Float = RueMath.AbsoluteDirection(Delta);
		TargetX += Direction * AtPerTick * Profiler.ElapsedTime;
		var NewDirection:Float = RueMath.AbsoluteDirection(Towards - TargetX);
		if (!RueMath.SameDirection(Direction, NewDirection))
		{
			TargetX = Towards;
		}
	}
	
	public static function InterpolateY(Towards:Float, AtPerTick:Float):Void
	{
		var Delta:Float = Towards - TargetY;
		if (Delta == 0)
		{
			return;
		}
		var Direction:Float = RueMath.AbsoluteDirection(Delta);
		TargetY += Direction * AtPerTick * Profiler.ElapsedTime;
		var NewDirection:Float = RueMath.AbsoluteDirection(Towards - TargetY);
		if (!RueMath.SameDirection(Direction, NewDirection))
		{
			TargetY = Towards;
		}
	}
	
	private function new() 
	{
		
	}
	
}