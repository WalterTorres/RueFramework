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
	
	/**
	 * Create invokes the internal constructor to create an spritesheet description, this class will save all the information 
	 * obtained from the json file created from Texture packer (as an array export) for drawing the elements in the spritesheet.
	 * 
	 * Use this class along with the GraphicsComponent and the TileDesc class for animation. To create animations use the Rue Animation editor (Coming soon as a stand alone app).
	 * 
	 * 
	 *  @param FileName The name of the Bitmap you are trying to load, the Json file must have the same name as the bitmap. (only works with pngs)
	 * 
	 * 
	 *  @param BitmapPath The location where the bitmap is, by default the system will look in a folder called "textures/", if you would like to create this folder,
	 * 					  do it inside the Assets folder and add to your project.xml the following: <assets path="Assets/textures" rename="textures" include="*" />
	 * 
	 *  @param JsonPath The location where the Json is, by default the system will look in a folder called "json/", if you would like to create this folder,
	 * 					  do it inside the Assets folder and add to your project.xml the following: <assets path="Assets/json" rename="json" include="*" />
	 * 
	*/
	
	public static function Create(FileName:String,  BitmapPath:String = "textures/", JsonPath:String = "json/") :TileSheetEntry
	{
		return new TileSheetEntry(FileName, BitmapPath, JsonPath);
	}

	private function new(File:String, BitmapPath:String, JsonPath:String) 
	{
		var Data:BitmapData = Assets.getBitmapData(BitmapPath + File + ".png");
		TheSheet = new Tilesheet(Data);

		Offsets = new Array<FloatTupe>();


		var JsonFileData = Json.parse(Assets.getText(JsonPath + File + ".json"));
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
		var HalfWidth:Float = Width *0.5;
		var HalfHeight:Float = Height *0.5;
		var TheRect:Rectangle = new Rectangle(X, Y, Width, Height);
		Offsets.push(new FloatTupe(-HalfWidth + ManualOffsetX, -HalfHeight + ManualOffsetY));
		TheSheet.addTileRect(TheRect, new Point(HalfWidth, HalfHeight));
	}
	
	
}