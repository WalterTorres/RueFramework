package engine.helpers.render;
import engine.base.RueObject;
import engine.helpers.collections.DrawNode;
import engine.helpers.TileSheetEntry;
import engine.systems.TileRenderSystem;
import engine.World;
import flash.display.Graphics;
import flash.display.Sprite;
import openfl.display.Tilesheet;

/**
 * ...
 * @author Jakegr
 */

class DrawStack extends RueObject
{
	public static var Layers:DrawStackList = DrawStackList.Create();
	
	static var Head:DrawStack;
	var Next:DrawStack;
	var Self:DrawStack;
	
	var TheSheet:TileSheetEntry;
	public var Target:Sprite;
	
	var _OneCount:Int;
	public var LayerOne:DrawNode;
	
	var _TwoCount:Int;
	public var LayerTwo:DrawNode;
	
	var _ThreeCount:Int;
	public var LayerThree:DrawNode;
	
	var _FourCount:Int;
	public var LayerFour:DrawNode;
	
	static var ElementNumber:Int = 4;
	var TheLayer:Int;
	
	public var _RenderOnce:Bool;
	public var _AllowedToRender:Bool;
	
	public var _CameraPullX:Float; //used for when the render target follows the camera, usually defaulted at 0
	public var _CameraPullY:Float;
	
	var _CameraX:Float;
	var _CameraY:Float;
	
	var _CurrentX:Float; //the current position X and Y of the render target. for internal use only.
	var _CurrentY:Float;
	
	var _PositionChanged:Bool;
	
	private function new() 
	{
		super();
		Self = this;
	}

	// The tile sheet that contains the bitmap data
	// The target sprite where to render the data
	// The global layer on which we will be adding our child target
	// The scale X
	// The scale Y
	public static function Create(TileSheet:TileSheetEntry, Layer:Int = 0, ScaleX:Float = 1, ScaleY:Float = 1, Alpha:Float = 1.0, RenderOnce:Bool = false ):DrawStack
	{
		var Vessel:DrawStack;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new DrawStack(); }
		
		Vessel._OneCount = 0;
		Vessel._TwoCount = 0;
		Vessel._ThreeCount = 0;
		Vessel._FourCount = 0;
		
		Vessel.LayerOne = null;
		Vessel.LayerTwo = null;
		Vessel.LayerThree = null;
		Vessel.LayerFour = null;
		
		Vessel.TheSheet = TileSheet;
		Vessel.Target = new Sprite();
		Vessel.Target.scaleX = ScaleX;
		Vessel.Target.scaleY = ScaleY;
		Vessel.Target.alpha = Alpha;
		Vessel.TheLayer = Layer;
		
		Vessel._RenderOnce = RenderOnce;
		Vessel._AllowedToRender = true;
		
		Vessel._PositionChanged = false;
		
		Vessel._CameraX = 0;
		Vessel._CameraY = 0;
		
		Vessel._CameraPullX = 0;
		Vessel._CameraPullY = 0;
		
		Vessel._CurrentX = 0;
		Vessel._CurrentY = 0;
		
		switch(Layer)
		{
			case 0: { World.Self.BackgroundRenderTarget.addChild(Vessel.Target); }
			case 1: { World.Self.ScreenRenderTarget.addChild(Vessel.Target); }
			default: { World.Self.GuiRenderTarget.addChild(Vessel.Target); }
		}
		
		Layers.Add(Vessel);//automatically adds itself to the rendering
		return Vessel;
	}
	
	public function SetCameraPullXY(X:Float, Y:Float):Void
	{
		_CameraPullX = X;
		_CameraPullY = Y;
		SetCameraXY(TileRenderSystem.CameraX, TileRenderSystem.CameraY);
	}
	
	public function SetCameraXY(X:Float, Y:Float):Void
	{
		if (_CameraPullX != 0)
		{
			_CameraX = _CameraPullX * X;
			_PositionChanged = true;
		}
		if (_CameraPullY != 0)
		{
			_CameraY = _CameraPullY * Y;
			_PositionChanged = true;
		}
	}
	
	public function SetScale(X:Float, Y:Float):Void
	{
		Target.scaleX = X;
		Target.scaleY = Y;
	}
	
	//hard coded value for position
	public function SetRenderTargetXY(X:Float, Y:Float):Void
	{
		if (X != _CurrentX) 
		{
			_PositionChanged = true;
			_CurrentX = X;
		}
		if (Y != _CurrentY)
		{
			_PositionChanged = true;
			_CurrentY = Y;
		}
	}
	
	public function SetRenderTargetAlpha(Alpha:Float):Void
	{
		Target.alpha = Alpha;
	}
	
	override public function Recycle():Void
	{
		switch(TheLayer)
		{
			case 0: { World.Self.BackgroundRenderTarget.removeChild(Target); }
			case 1: { World.Self.ScreenRenderTarget.removeChild(Target); }
			default: { World.Self.GuiRenderTarget.removeChild(Target); }
		}
		Target = null;
		
		Next = Head;
		Head = Self;
		
		super.Recycle();
	}
	
	public function AddToRender(Layer:Int, UniqueID:Int, X:Float, Y:Float, Rotation:Float):Void
	{
		switch(Layer)
		{
			case 0:
			{
				_OneCount++;
				var Offset:FloatTupe = TheSheet.Offsets[UniqueID];
				var NewNode:DrawNode = DrawNode.Create(X-Offset.ValueOne, Y-Offset.ValueTwo, UniqueID, Rotation);
				NewNode.NextNode = LayerOne;
				LayerOne = NewNode;
			}
			
			case 1:
			{
				_TwoCount++;
				var Offset:FloatTupe = TheSheet.Offsets[UniqueID];
				var NewNode:DrawNode = DrawNode.Create(X-Offset.ValueOne, Y-Offset.ValueTwo, UniqueID, Rotation);
				NewNode.NextNode = LayerTwo;
				LayerTwo = NewNode;
			}
			
			case 2:
			{
				_ThreeCount++;
				var Offset:FloatTupe = TheSheet.Offsets[UniqueID];
				var NewNode:DrawNode = DrawNode.Create(X-Offset.ValueOne, Y-Offset.ValueTwo, UniqueID, Rotation);
				NewNode.NextNode = LayerThree;
				LayerThree = NewNode;
			}
			
			case 3:
			{
				_FourCount++;
				var Offset:FloatTupe = TheSheet.Offsets[UniqueID];
				var NewNode:DrawNode = DrawNode.Create(X-Offset.ValueOne, Y-Offset.ValueTwo, UniqueID, Rotation);
				NewNode.NextNode = LayerFour;
				LayerFour = NewNode;
			}
		}
	}
	
	public function RenderAll():Void
	{
		if (_PositionChanged)
		{
			_PositionChanged = false;
			Target.x = _CurrentX - _CameraX;
			Target.y = _CurrentY - _CameraY;
		}
		
		if (!_AllowedToRender) { return; }
		Target.graphics.clear();
		if (_OneCount == 0 && _TwoCount == 0 && _ThreeCount == 0 && _FourCount == 0) { return; }
		var First:Int = _OneCount * ElementNumber;
		var Second:Int = _OneCount * ElementNumber + _TwoCount * ElementNumber;
		var Third:Int = _OneCount * ElementNumber + _TwoCount * ElementNumber + _ThreeCount * ElementNumber;
		var Forth:Int = _OneCount * ElementNumber + _TwoCount * ElementNumber + _ThreeCount * ElementNumber + _FourCount*ElementNumber;
		_OneCount = 0;
		_TwoCount = 0;
		_ThreeCount = 0;
		_FourCount = 0;
		var TileStack:Array<Float> = new Array<Float>();
		while (LayerOne != null)
		{
			TileStack[--First] = -LayerOne.Rotation;
			TileStack[--First] = LayerOne.Frame;
			TileStack[--First] = LayerOne.PositionY;
			TileStack[--First] = LayerOne.PositionX;
			LayerOne.Recycle();
			LayerOne = LayerOne.NextNode;
		}
		while (LayerTwo != null)
		{
			TileStack[--Second] = -LayerTwo.Rotation;
			TileStack[--Second] = LayerTwo.Frame;
			TileStack[--Second] = LayerTwo.PositionY;
			TileStack[--Second] = LayerTwo.PositionX;
			LayerTwo.Recycle();
			LayerTwo = LayerTwo.NextNode;
		}
		while (LayerThree != null)
		{
			TileStack[--Third] = -LayerThree.Rotation;
			TileStack[--Third] = LayerThree.Frame;
			TileStack[--Third] = LayerThree.PositionY;
			TileStack[--Third] = LayerThree.PositionX;
			LayerThree.Recycle();
			LayerThree = LayerThree.NextNode;
		}
		while (LayerFour != null)
		{
			TileStack[--Forth] = -LayerFour.Rotation;
			TileStack[--Forth] = LayerFour.Frame;
			TileStack[--Forth] = LayerFour.PositionY;
			TileStack[--Forth] = LayerFour.PositionX;
			LayerFour.Recycle();
			LayerFour = LayerFour.NextNode;
		}
		TheSheet.TheSheet.drawTiles(Target.graphics, TileStack, true, Tilesheet.TILE_ROTATION);
		if (_RenderOnce)
		{
			_AllowedToRender = false;
		}
	}
	

		
	
}