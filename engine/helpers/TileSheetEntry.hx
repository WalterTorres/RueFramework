package engine.helpers;

import haxe.Json;
import openfl.Assets;
import flash.display.Graphics;
import openfl.display.Tilesheet;
import flash.display.BitmapData;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

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
 
class TileSheetEntry 
{
	public static var TheGraphics:Graphics;
	public static var TheGuiGraphics:Graphics;
	public static var TheBGGraphics:Graphics;
	private static var Flags:Int = Tilesheet.TILE_ROTATION;

	public var TheSheet:Tilesheet;

	public var Offsets:Array<FloatTupe>;
	
	public var _IsCameraBound:Bool;
	
	public static function Create(File:String,  IsCameraBound:Bool = false) :TileSheetEntry
	{
		return new TileSheetEntry(File, IsCameraBound);
	}

	public function new(File:String,  IsCameraBound:Bool = false) 
	{
		var Data:BitmapData;
		super();
		_IsCameraBound = IsCameraBound;
		Data = Assets.getBitmapData("textures/" + File + ".png");
		TheSheet = new Tilesheet(Data);
		TileStack = new Array<Float>();
		Offsets = new Array<FloatTupe>();
		InternalID = 0;

		var JsonFileData = Json.parse(Assets.getText("json/" + File + ".json"));
		var dFrames:Array<Dynamic> = cast(JsonFileData.frames);
		var FrameCount = dFrames.length;
		
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
			AddTileRec(X, Y, Width, Height, -XOffset, -YOffset);
		}
		
		#if ios
		Data.dumpBits(); //optimization for ios lack of memory.
		#end
	}

	private inline function AddTileRec(X:Float, Y:Float, Width:Float, Height:Float, ManualOffsetX:Float = 0, ManualOffsetY:Float = 0):Void
	{
		var TheRect:Rectangle = new Rectangle(X, Y, Width, Height);
		Offsets.push(new FloatTupe(-Width / 2 + ManualOffsetX, -Height / 2 + ManualOffsetY));
		TheSheet.addTileRect(TheRect, new Point(Width / 2, Height / 2));
	}
	
	
}