package engine.systems;


import engine.helpers.render.DrawStack;
import engine.helpers.roxstudio.haxe.gesture.RoxGestureEvent;
import engine.helpers.RueMath;
import engine.systems.touches.RueTouch;
import engine.templates.collections.MouseListenerList;
import engine.World;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.TouchEvent;
import flash.text.TextField;
import flash.sensors.Accelerometer;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import engine.helpers.roxstudio.haxe.gesture.RoxGestureAgent;


/**
 * ...
 * @author Jakegr
 */

class MouseInputSystem 
{
	public static var Accelerometersupported:Bool;
	
	public static var XRate:Float = 1;
	public static var YRate:Float = 1;
	
	public static var LetterBoxOffsetX:Float = 0;
	public static var LetterBoxOffsetY:Float = 0;

	//touches
	public static var TouchOne:RueTouch = new RueTouch();
	public static var TouchTwo:RueTouch = new RueTouch();
	
	
	public static var X:Float = 0; //represents always the first touch
	public static var Y:Float = 0;
	public static var CameraMouseX:Float = 0;
	public static var CameraMouseY:Float = 0;
	
	public static var IntX:Int = 0;
	public static var IntY:Int = 0;
	
	public static var IntCameraX:Int = 0;
	public static var IntCameraY:Int = 0;
	
	private static var HitBitmap:Bitmap;
	
	public static var ClickedThisTick:Bool = false;
	public static var ClickedLastTick:Bool = false;
	public static var Clicked:Bool = false;
	public static var Dragging:Bool = false;
	public static var Pinched:Bool = false;
	
	public static var PinchRatio:Float = 0.0;
	public static var DebugText:TextField;
	
	private static var GestureAgent:RoxGestureAgent = null;
	
	private static var theStage:Main;
	
	public static var MouseListeners:Array<MouseListenerList> = new Array<MouseListenerList>();
	
	public static function Init(TheStage:Main):Void
	{
		for (i in 0...20)
		{
			MouseListeners[i] = MouseListenerList.Create();
		}
		
		if (Accelerometer.isSupported)
		{
			Accelerometersupported = true;
		}
		else
		{
			Accelerometersupported = false;
		}
		
		#if !flash
		GestureAgent = new RoxGestureAgent(TheStage.stage, RoxGestureAgent.GESTURE);
		TheStage.stage.addEventListener(RoxGestureEvent.GESTURE_PINCH, OnPinch);
		#end
		
		TheStage.stage.addEventListener(MouseEvent.MOUSE_DOWN, OnTouchDown, true, 0);
		TheStage.stage.addEventListener(MouseEvent.MOUSE_UP, OnTouchUp);
		TheStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnDrag);
		
		//#end
		
		ClickedLastTick = false;
		ClickedThisTick = false;
		
		theStage = TheStage;
	}
	
	private static var isIn:Bool = false;
	public static function ToggleDebug():Void
	{
		if (DebugText == null)
		{
			DebugText = new TextField();
			DebugText.x = 300;
			DebugText.y = 300;
			DebugText.width = 300;
			DebugText.height = 300;
			DebugText.scaleX = 3;
			DebugText.scaleY = 3;
			DebugText.mouseEnabled = false;
			DebugText.selectable = false;
		}
		
		if (isIn)
		{
			isIn = false;
			theStage.stage.removeChild(DebugText);
		}
		else
		{
			isIn = true;
			theStage.stage.addChild(DebugText);
		}
		
	}
	
	
	private static var FirstTouchDown:Bool = false;
	
	
	
	private static function OnPinch(e:RoxGestureEvent):Void
	{
		Pinched = true;
		PinchRatio = -(1-e.extra);
		//DebugText.text = cast(("pinching: " + PinchRatio));
	}
	
	
	private static function OnTouchDown(A:MouseEvent):Void
	{
		//this will be true for all the instances
		ClickedThisTick = true;
		X = A.stageX*XRate - LetterBoxOffsetX;
		Y = A.stageY*YRate - LetterBoxOffsetY;
		
		var ZoomedMousePositionX:Float = (X - TileRenderSystem.InitialHalfWidth) / TileRenderSystem.Zoom;
		var ZoomedMousePositionY:Float = (Y - TileRenderSystem.InitialHalfHeight) / TileRenderSystem.Zoom;
		
		CameraMouseX = ZoomedMousePositionX + TileRenderSystem.TargetX*TileRenderSystem.Zoom;
		CameraMouseY = ZoomedMousePositionY + TileRenderSystem.TargetY*TileRenderSystem.Zoom;

		FirstTouchDown = true;

		if (!TouchOne._IsActive)
		{
			TouchOne._InitialX = X;
			TouchOne._InitialY = Y;
		}

		if (isIn)
		{
			var comp = "X: " + Std.int(X) + " Y: " + Std.int(Y);
		
			DebugText.text = comp;
		}
		
		IntX = cast(X);
		IntY = cast(Y);
		IntCameraX = cast(CameraMouseX);
		IntCameraY = cast(CameraMouseY);
	
		TouchOne._IsActive = true;
		TouchOne._X = X;
		TouchOne._Y = Y;
		TouchOne._LastX = X;
		TouchOne._LastY = Y;
		TouchOne._CamX = CameraMouseX;
		TouchOne._CamY = CameraMouseY;
		TouchOne._LastCamX = CameraMouseX;
		TouchOne._LastCamY = CameraMouseY;
			
	}
	
	private static function OnTouchUp(A:MouseEvent):Void
	{
		X = A.stageX*XRate - LetterBoxOffsetX;
		Y = A.stageY*YRate - LetterBoxOffsetY;
		
		ClickedThisTick = false;
		if (!Dragging)
		{
			Clicked = true;
			//check all the listeners and notify the one that got touched.
			for (i in 0...20)
			{
				var current:Int = 19 - i;
				if (MouseListeners[current].CheckInput(X, Y))
				{
					break;
				}
			}
		}
		else
		{
			if(!TouchOne.Dragged())
			{
				Clicked = true;
				//trace("didnt drag");
			}
			Dragging = false;
			
		}
		var ZoomedMousePositionX:Float = (X - TileRenderSystem.InitialHalfWidth) / TileRenderSystem.Zoom;
		var ZoomedMousePositionY:Float = (Y - TileRenderSystem.InitialHalfHeight) / TileRenderSystem.Zoom;
		
		CameraMouseX = ZoomedMousePositionX + TileRenderSystem.TargetX*TileRenderSystem.Zoom;
		CameraMouseY = ZoomedMousePositionY + TileRenderSystem.TargetY*TileRenderSystem.Zoom;
		
		IntX = cast(X);
		IntY = cast(Y);
		IntCameraX = cast(CameraMouseX);
		IntCameraY = cast(CameraMouseY);
		
		TouchOne._IsActive = false;
		FirstTouchDown = false;
	}
	
	private static function OnDrag(A:MouseEvent):Void
	{
		//ClickedThisTick = true;
		if (FirstTouchDown)
		{
			if (TouchOne.Dragged())
			{
				Dragging = true;
			}
		}
		X = A.stageX*XRate - LetterBoxOffsetX;
		Y = A.stageY * YRate - LetterBoxOffsetY;
		
		if (isIn)
		{
			var comp = "X: " + Std.int(X) + " Y: " + Std.int(Y);
		
			DebugText.text = comp;
		}
		
		var ZoomedMousePositionX:Float = (X - TileRenderSystem.InitialHalfWidth) / TileRenderSystem.Zoom;
		var ZoomedMousePositionY:Float = (Y - TileRenderSystem.InitialHalfHeight) / TileRenderSystem.Zoom;
		
		CameraMouseX = ZoomedMousePositionX + TileRenderSystem.TargetX*TileRenderSystem.Zoom;
		CameraMouseY = ZoomedMousePositionY + TileRenderSystem.TargetY*TileRenderSystem.Zoom;
		
		IntX = cast(X);
		IntY = cast(Y);
		IntCameraX = cast(CameraMouseX);
		IntCameraY = cast(CameraMouseY);
		
		TouchOne._IsActive = true;
		
		//TouchOne._LastX = TouchOne._X;
		//TouchOne._LastY = TouchOne._Y;
		
		TouchOne._X = X;
		TouchOne._Y = Y;
		
		//TouchOne._LastCamX = TouchOne._CamX;
		//TouchOne._LastCamY = TouchOne._CamY;
		
		TouchOne._CamX = CameraMouseX;
		TouchOne._CamY = CameraMouseY;
	}

	public static function Update():Void
	{
		
	}
	
	public static function CleanUp():Void
	{
		if (!FirstTouchDown)
		{
			Dragging = false;
		}
		Pinched = false;
		if (Clicked)
		{
			Clicked = false;
		}
		ClickedLastTick = ClickedThisTick;
		
		if (TouchOne._IsActive)
		{
			TouchOne._LastX = TouchOne._X;
			TouchOne._LastY = TouchOne._Y;
			
			TouchOne._LastCamX = TouchOne._CamX;
			TouchOne._LastCamY = TouchOne._CamY;
		}
		
	}

	private function new() 
	{
	}
	
}
