package engine.helpers;

import engine.base.Entity;
import engine.base.RueObject;
import engine.components.GraphicsComponent;
import engine.helpers.collections.DrawNode;
import engine.systems.TileRenderSystem;
import engine.World;

import haxe.ds.Vector;

import haxe.Json;
import openfl.Assets;
import flash.display.Graphics;
import openfl.display.Tilesheet;
import flash.display.BitmapData;

import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


import flash.system.System;

/**
 * ...
 * @author Jakegr
 */

 class FloatTupe
 {
	 public function new(val1:Float, val2:Float) 
	 {
		 ValueOne = val1;
		 ValueTwo = val2;
	 }
	public var ValueOne:Float;
	public var ValueTwo:Float;
 }
 
class NameIDTupe
{
	public var Name:String;
	public var ID:Int;
	
	public function new(dName:String, dID:Int)
	{
		Name = dName;
		ID = dID;
		Name = Name.split(".")[0];
	}
	
}

class TileSheetEntry extends RueObject
{
	public static var TheGraphics:Graphics;
	public static var TheGuiGraphics:Graphics;
	public static var TheBGGraphics:Graphics;
	
	private static var Flags:Int = Tilesheet.TILE_ROTATION;

	public var TheSheet:Tilesheet;
	var InternalID:Int;
	public var Data:BitmapData;
	
	public var BackGround:DrawNode;
	public var MidGround:DrawNode;
	public var ForeGround:DrawNode;
	
	public var OutOfGraphic:DrawNode;
	
	public var Offsets:Array<FloatTupe>;
	public var NameIDs:Array<NameIDTupe>;
	
	var TileStack:Array<Float>;
	
	public var StackCount:Int;
	
	var BackgroundCount:Int;
	var MidgroundCount:Int;
	var ForegroundCount:Int;
	
	var CurrentMax:Int;
	
	public var _IsCameraBound:Bool;
	
	public static function Create(File:String,  IsCameraBound:Bool = false) :TileSheetEntry
	{
		return new TileSheetEntry(File, IsCameraBound);
	}

	public function new(File:String,  IsCameraBound:Bool = false) 
	{
		super();
		_IsCameraBound = IsCameraBound;
		StackCount = 0;
		CurrentMax = 0;
		BackgroundCount = 0;
		MidgroundCount = 0;
		ForegroundCount = 0;
		
		Data = Assets.getBitmapData("textures/" + File + ".png");

		TheSheet = new Tilesheet(Data);
		TileStack = new Array<Float>();
		Offsets = new Array<FloatTupe>();
		NameIDs = new Array<NameIDTupe>();
		InternalID = 0;

		var JsonFileData = Json.parse(Assets.getText("json/" + File + ".json"));
		var dFrames:Array<Dynamic> = cast(JsonFileData.frames);
		var FrameCount = dFrames.length;
		trace(dFrames);
		for (i in 0...FrameCount)
		{
			var FirstObject = dFrames[i];
			var TheFrame = FirstObject.frame;
			var X:Float = TheFrame.x;
			var Y:Float = TheFrame.y;
			var Width:Int = TheFrame.w;
			var Height:Int = TheFrame.h;
			
			var Offset = FirstObject.spriteSourceSize;
			
			var XOffset = Offset.x;
			var YOffset = Offset.y;
			
			var IDTile:Int = 0;
			
			IDTile = AddTileRec(X, Y, Width, Height, -XOffset, -YOffset);
		}
	}
	
	public function GetFrameID(Name:String):Int
	{
		for (i in 0...NameIDs.length)
		{
			var Current:NameIDTupe = NameIDs[i];
			if (Current.Name == Name)
			{
				return Current.ID;
			}
		}
		trace(Name);
		return -1;
	}
	
	private inline function AddTileRec(X:Float, Y:Float, Width:Float, Height:Float, ManualOffsetX:Float = 0, ManualOffsetY:Float = 0):Int
	{
		var TheRect:Rectangle = new Rectangle(X, Y, Width, Height);
		Offsets.push(new FloatTupe(-Width / 2 + ManualOffsetX, -Height / 2 + ManualOffsetY));
		TheSheet.addTileRect(TheRect, new Point(Width / 2, Height / 2));
		InternalID++;
		return InternalID - 1;
	}
	
	//{Functionality
	
	//public inline function AddToBackGround(X:Float, Y:Float, Frame:Int, Rotation:Float):Void
	//{
	//	BackgroundCount++;
	//	var Offset:FloatTupe = Offsets[Frame];
	//	var NewNode:DrawNode = DrawNode.Create(X-Offset.ValueOne, Y-Offset.ValueTwo, Frame, Rotation);
	//	NewNode.NextNode = BackGround;
	//	BackGround = NewNode;
	//}
    //
	//public inline function AddToMidGround(X:Float, Y:Float, Frame:Int, Rotation:Float):Void
	//{
	//	MidgroundCount++;
	//	var Offset:FloatTupe = Offsets[Frame];
	//	var NewNode:DrawNode = DrawNode.Create(X - Offset.ValueOne, Y - Offset.ValueTwo, Frame, Rotation);
	//	NewNode.NextNode = MidGround;
	//	MidGround = NewNode;
	//}
	//
	//public inline function AddToForeGround(X:Float, Y:Float, Frame:Int, Rotation:Float):Void
	//{
	//	ForegroundCount++;
	//	var Offset:FloatTupe = Offsets[Frame];
	//	var NewNode:DrawNode = DrawNode.Create(X-Offset.ValueOne, Y-Offset.ValueTwo, Frame, Rotation);
	//	NewNode.NextNode = ForeGround;
	//	ForeGround = NewNode;
	//}
	
	//public function Draw():Void
	//{
	//	if (_IsCameraBound)
	//	{
	//		GUIRenderAndFlush();
	//	}
	//	else
	//	{
	//		RenderAndFlush();
	//	}
	//}
	
	//public inline function RenderAndFlush():Void
	//{
	//	TileStack = new Array<Float>();
	//	var StartPointBack:Int = BackgroundCount*4;
	//	var StartPointMid:Int = BackgroundCount*4 + MidgroundCount*4;
	//	var StartPointFore:Int = MidgroundCount*4 + BackgroundCount*4 + ForegroundCount*4;
	//	BackgroundCount = 0;
	//	MidgroundCount = 0;
	//	ForegroundCount = 0;
	//	
	//	while (BackGround != null)
	//	{
	//		TileStack[--StartPointBack] = -BackGround.Rotation;
	//		TileStack[--StartPointBack] = BackGround.Frame;
	//		TileStack[--StartPointBack] = BackGround.PositionY;
	//		TileStack[--StartPointBack] = BackGround.PositionX;
	//		BackGround.Recycle();
	//		BackGround = BackGround.NextNode;
	//	}
	//	while (MidGround != null)
	//	{
	//		TileStack[--StartPointMid] = -MidGround.Rotation;
	//		TileStack[--StartPointMid] = MidGround.Frame;
	//		TileStack[--StartPointMid] = MidGround.PositionY;
	//		TileStack[--StartPointMid] = MidGround.PositionX;
	//		MidGround.Recycle();
	//		MidGround = MidGround.NextNode;
	//	}
	//	while (ForeGround != null)
	//	{
	//		TileStack[--StartPointFore] = -ForeGround.Rotation;
	//		TileStack[--StartPointFore] = ForeGround.Frame;
	//		TileStack[--StartPointFore] = ForeGround.PositionY;
	//		TileStack[--StartPointFore] = ForeGround.PositionX;
	//		ForeGround.Recycle();
	//		ForeGround = ForeGround.NextNode;
	//	}
	//	TheSheet.drawTiles(TheGraphics, TileStack, true, Flags);
	//}
	//
	//public inline function GUIRenderAndFlush():Void
	//{
	//	TileStack = new Array<Float>();
	//	var StartPointBack:Int = BackgroundCount*4;
	//	var StartPointMid:Int = BackgroundCount*4 + MidgroundCount*4;
	//	var StartPointFore:Int = MidgroundCount*4 + BackgroundCount*4 + ForegroundCount*4;
	//	BackgroundCount = 0;
	//	MidgroundCount = 0;
	//	ForegroundCount = 0;
	//	
	//	while (BackGround != null)
	//	{
	//		TileStack[--StartPointBack] = -BackGround.Rotation;
	//		TileStack[--StartPointBack] = BackGround.Frame;
	//		TileStack[--StartPointBack] = BackGround.PositionY;
	//		TileStack[--StartPointBack] = BackGround.PositionX;
	//		BackGround.Recycle();
	//		BackGround = BackGround.NextNode;
	//	}
	//	while (MidGround != null)
	//	{
	//		TileStack[--StartPointMid] = -MidGround.Rotation;
	//		TileStack[--StartPointMid] = MidGround.Frame;
	//		TileStack[--StartPointMid] = MidGround.PositionY;
	//		TileStack[--StartPointMid] = MidGround.PositionX;
	//		MidGround.Recycle();
	//		MidGround = MidGround.NextNode;
	//	}
	//	while (ForeGround != null)
	//	{
	//		TileStack[--StartPointFore] = -ForeGround.Rotation;
	//		TileStack[--StartPointFore] = ForeGround.Frame;
	//		TileStack[--StartPointFore] = ForeGround.PositionY;
	//		TileStack[--StartPointFore] = ForeGround.PositionX;
	//		ForeGround.Recycle();
	//		ForeGround = ForeGround.NextNode;
	//	}
	//	TheSheet.drawTiles(TheGuiGraphics, TileStack, true, Flags);
	//}
}