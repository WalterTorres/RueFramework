package engine;

import engine.base.EntityGroup;
import engine.components.PositionComponent;
import engine.gameElements.CollisionResponses;
import engine.helpers.RueMath;
import engine.helpers.TileSheetEntry;
import engine.systems.InputSystem;
import engine.systems.RebirthSystem;
import engine.systems.TileRenderSystem;
import engine.systems.SoundSystem;
import engine.helpers.Profiler;
import engine.systems.MouseInputSystem;
import engine.systems.UpdateSystem;
import engine.templates.collections.RueCallbackList;
import flash.display.StageScaleMode;
import flash.system.System;
import nape.space.Space;
import flash.display.Sprite;
import flash.events.Event;
import nape.geom.Vec2;
import flash.Lib;
import flash.display.Shape;



/**
 * ...
 * @author Jakegr
 */

class World 
{
	public var Parent:Main;
	public static var Self:World;
	public static var TheSpace:Space = new Space(Vec2.get(0, 0));
	public static var Group:EntityGroup;
	
	public var VelocityIterations:Int;
	public var PositionIterations:Int;
	
	public var GuiRenderTarget:Sprite;
	public var ScreenRenderTarget:Sprite;
	public var BackgroundRenderTarget:Sprite;
	public var FrameRateDecimal:Float;	
	public var Orientation:Int;
	public var OnResizeListeners:RueCallbackList;
	
	public var MainSprite:Sprite;
	public var LetterBoxOne:Shape;
	public var LetterBoxTwo:Shape;
	
	private var TargetWidth:Float; 
	private var TargetHeight:Float;

	public function new(Stage:Main, Width:Float, Height:Float, EntryPoint:EntityGroup->Void) 
	{
		Stage.stage.scaleMode = StageScaleMode.NO_SCALE; //if this is not set by default just make sure it is, since we will be manipulating the scaling manually.
		Lib.current.stage.addEventListener(Event.RESIZE, OnResize); //I added this for testing, since when targeting a windows or flash I can change the size of the screen dynamically, I see the changes working.
		Stage.addEventListener(Event.ENTER_FRAME, Update); //for my own framework.
		
		Self = this;
		Parent = Stage;
		FrameRateDecimal = 1 / 60;
		
		MainSprite = new Sprite(); //this is the "render target" where we will be drawing our game at. please note I use a hierarchy of render targets that get drawn onto this sprite, but I draw to the leaves of this tree using drawTiles.
		LetterBoxOne = new Shape(); //this are the letter boxes, right now they are Shapes but they could be sprites, up to you really.
		LetterBoxTwo = new Shape();
		
		Stage.addChild(MainSprite);//adding the display objects in this order we will make sure that the letter boxes will draw on top of our game. (in case there are letter boxes)
		Stage.addChild(LetterBoxOne);
		Stage.addChild(LetterBoxTwo);
		
		TargetWidth = Width;
		TargetHeight = Height;
		
		VelocityIterations = 10;
		PositionIterations = 10;
		
		GuiRenderTarget = new Sprite();
		GuiRenderTarget.x = 0;
		GuiRenderTarget.y = 0;
		GuiRenderTarget.scaleX = 1;
		GuiRenderTarget.scaleY = 1;
		
		ScreenRenderTarget = new Sprite();
		ScreenRenderTarget.x = 0;
		ScreenRenderTarget.y = 0;
		ScreenRenderTarget.scaleX = 1;
		ScreenRenderTarget.scaleY = 1;
		
		BackgroundRenderTarget = new Sprite();
		BackgroundRenderTarget.x = 0;
		BackgroundRenderTarget.y = 0;
		BackgroundRenderTarget.scaleX = 1;
		BackgroundRenderTarget.scaleY = 1;
		
		MainSprite.addChild(BackgroundRenderTarget); //the one to draw first
		MainSprite.addChild(ScreenRenderTarget); //the one to draw the middle
		MainSprite.addChild(GuiRenderTarget); //for gui
		
		OnResizeListeners = RueCallbackList.Create();
		
		CollisionResponses.SetUpRules();
		InputSystem.Init(Stage);
		UpdateSystem.Init();
		MouseInputSystem.Init(Stage);
		TileRenderSystem.Init(Width, Height, ScreenRenderTarget, GuiRenderTarget, BackgroundRenderTarget);
		SoundSystem.Init();
		RebirthSystem.Init();
		Profiler.Init(GuiRenderTarget);
		//TheSpace.worldAngularDrag = 0;
		//TheSpace.worldLinearDrag = 0;
		Group = EntityGroup.Create();
		UpdateSystem.CurrentGroup = Group;
	}
	
	public function Update(e:Event):Void
	{
		//TIME STEP
		Profiler.Tick();
		
		//SYSTEM SET UP
		MouseInputSystem.Update();

		//PRE UPDATE
		UpdateSystem.PreUpdate();

		//BETWEEN STEP
		TileRenderSystem.AdjustBody();
	
		//COLLISION UPDATE
		TheSpace.step(FrameRateDecimal, VelocityIterations, PositionIterations);
		
		//UPDATE
		UpdateSystem.Update();
		
		//DRAW SET UP
		UpdateSystem.Draw();
		
		//RENDERING
		TileRenderSystem.Render();
		
		//CLEAN UP
		MouseInputSystem.CleanUp();
		RebirthSystem.Rebirth();
		
		
		Profiler.Report();
	}
	
	private function OnResize(e):Void //here is where we make sure that we are resizing and scaling the screen properly.
	{
		//fix the resolution
		var ScaleX:Float = Lib.current.stage.stageWidth / TargetWidth;  //first we get the scales from the current device we are targetting by comparing it with the target resolution.
		var ScaleY:Float = Lib.current.stage.stageHeight / TargetHeight;
		var Smallest:Float = ScaleX >= ScaleY ? ScaleY : ScaleX; //after that we need to make sure we target the smallest possible resolution, this is for properly scaling the entire screen.
		var ScreenActualSizeWidth:Float = TargetWidth * Smallest; //after scaling the screen we will end up with a "real" screen size, this is used for the letter boxing offset
		var ScreenActualSizeHeight:Float = TargetHeight * Smallest;
		var OffsetX:Float = ((Lib.current.stage.stageWidth - ScreenActualSizeWidth)/2)/Smallest; //we need to compare the device screen resolution to get the half of the offset needed, we divie by the smallest to bring it to the actual resolution the entire screen will be.
		var OffsetY:Float = ((Lib.current.stage.stageHeight - ScreenActualSizeHeight)/2)/Smallest;

		LetterBoxOne.graphics.clear();
		LetterBoxTwo.graphics.clear();
		
		var Distortion:Float = RueMath.Abs(ScaleX - ScaleY); //distortion calculation.
		
		if (Distortion > 0.0) //this is a threshold of distortion, it will only add the letter boxes if the image ratio is too distorted, you can change this value to fit your needs.
		{
			if (OffsetX >= OffsetY) //makes sure you are adding the letterboxes on the right spots, either at the top and bottom or the sides.
			{
				//letter box goes to the sides, use the size of the screen for Height
				//here, instead of just creating black boxes, you could potentially use your own graphics (in fact, youw ont be allowed to use black boxes for an apple app, so make sure to use your own graphics instead.
				LetterBoxOne.graphics.beginFill(0x000000);
				LetterBoxOne.graphics.drawRect(0, -1, OffsetX+1, Lib.current.stage.stageHeight/Smallest);
				LetterBoxOne.graphics.endFill();
				
				LetterBoxTwo.graphics.beginFill(0x000000);
				LetterBoxTwo.graphics.drawRect((OffsetX-1)+ScreenActualSizeWidth/Smallest, 0, OffsetX+1, Lib.current.stage.stageHeight/Smallest);
				LetterBoxTwo.graphics.endFill();
			}
			else
			{
				//letter box goes to the top and bot, use the size of the screen for Width
				LetterBoxOne.graphics.beginFill(0x000000);
				LetterBoxOne.graphics.drawRect(0, 0, Lib.current.stage.stageWidth/Smallest, OffsetY+1);
				LetterBoxOne.graphics.endFill();
	
				LetterBoxTwo.graphics.beginFill(0x000000);
				LetterBoxTwo.graphics.drawRect(0, OffsetY+(ScreenActualSizeHeight/Smallest), Lib.current.stage.stageWidth/Smallest, OffsetY);
				LetterBoxTwo.graphics.endFill();
			}
			
			Lib.current.scaleX = Smallest; //we are going to scale the entire screen to fit our resolution, this will make sure we present the game with the proper resolution.
			Lib.current.scaleY = Smallest;
			
			MouseInputSystem.XRate = 1 / Smallest; //here I do some scaling for my input, since the input X and Y is linked directly to the resolution of the device, this will make sure that I get an input X Y related to my own resolution.
			MouseInputSystem.YRate = 1 / Smallest;
			
			MainSprite.x = OffsetX-3; //-3 because right now there is a bug of some sort that does not align the main view properly.
			MainSprite.y = OffsetY-3; 
			
			MouseInputSystem.LetterBoxOffsetX = OffsetX; //this is used for my own system that records user input, modifying this 
			MouseInputSystem.LetterBoxOffsetY = OffsetY;
	
			TileRenderSystem.LetterBoxOffsetX = OffsetX; //this will add the offset to all the elements I render.
			TileRenderSystem.LetterBoxOffsetY = OffsetY;
		}
		else
		{
			Lib.current.scaleX = ScaleX; //in case the distortion is not that big that would require letter boxing, we are going to use the relative resolution from the target to the device screen.
			Lib.current.scaleY = ScaleY;
			
			MouseInputSystem.XRate = 1 / ScaleX;
			MouseInputSystem.YRate = 1 / ScaleY;
			
			MainSprite.x = -3;
			MainSprite.y = -3;
			
			MouseInputSystem.LetterBoxOffsetX = 0; //since there is no letter boxes, bring all back to 0.
			MouseInputSystem.LetterBoxOffsetY = 0;
	
			TileRenderSystem.LetterBoxOffsetX = 0;
			TileRenderSystem.LetterBoxOffsetY = 0;
		}
		
		if (OnResizeListeners != null)
		{
			OnResizeListeners.TriggerAll();
		}

	}
}