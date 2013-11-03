RueFramework
============

This framework was made to make 2D game development quickly and efficiently, making use of OpenFL and Haxe for a rapid crossplatform development.


Example:
```java
import engine.base.EntityGroup;
import engine.World;
import flash.display.Sprite;

class Main extends Sprite 
{
	var TheWorld:World;
	
	public function new() 
	{
		super();	
		TheWorld = new World(this, 300, 768, EntryPoint);
		TheWorld.start(); //this hooks up the world game loop and calls your entry point with the main entity group.
	}
	
	private function EntryPoint(Group:EntityGroup):Void
	{
		//create your first entities here:
	}
}
```

--------------------------------------------------------------------------------

RueView
-------

One of the features of the Rueframework is the use of Views for creating UI, RueViews operate similarly to the Apple views, they can be linked in a parent child relationship and all of them can be extended for your own custom implementations.

Usage:

```java
class TitleScreen 
 extends Entity
{
	static var Head:TitleScreen;
	var Next:TitleScreen;
	var Self:TitleScreen;
	
	//{ For recycling
	var _TitleScreenRenderTarget:DrawStack;
	var _Controller:RueViewController;
	var _MainView:RueView;
	var _TitleView:RueView;
	var _PlayButton:RueView;
	//}
	
	//{ Extras
	var _CurrentSequence:Void->Void;
	//}
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Group:EntityGroup):TitleScreen
	{
		var Vessel:TitleScreen;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new TitleScreen(); }
		Vessel.Setup(Group);
		
		Vessel._TitleScreenRenderTarget = DrawStack.Create(CRCAssetsAniDesc.TheSpriteSheet, World.Self.GuiRenderTarget, 2);
		Vessel._Controller = RueViewController.Create(Group);
		
		Vessel._MainView = RueView.Create(Vessel._TitleScreenRenderTarget, PositionComponent.Create(0, 800), World.Self.TargetWidth, World.Self.TargetHeight);
		Vessel._MainView._MaxDragY = 300;
		Vessel._MainView._ElasticSpeedY = 2.5;
		Vessel._TitleView = RueView.Create(Vessel._TitleScreenRenderTarget, PositionComponent.Create(10, 100));
		Vessel._PlayButton = RueView.Create(Vessel._TitleScreenRenderTarget, PositionComponent.Create(200, 900), 207, 131);
		Vessel._Controller._TheView = Vessel._MainView;
		Vessel._MainView.AddChildView(Vessel._TitleView).AddChildView(Vessel._PlayButton);
		
		Vessel._TitleView.AddGraphic(CRCAssetsAniDesc._logo_mainMenu, 1, 0, 0, 0);
		Vessel._PlayButton.AddGraphic(CRCAssetsAniDesc._button_play, 1, 0, 0, 0);
		
		Vessel.SetSequence();
		
		return Vessel;
	}
	
	override public function PreUpdate():Void
	{
		DoesPreUpdate = false; // add your custom pre update behaviour (Time steps, HP checking, Rotations, etc)
	}
	
	override public function Update():Void
	{
		DoesUpdate = false; // add your custom update behaviour (Collision response, input response, entity creation, etc)
	}
	
	override public function Draw():Void
	{
		DoesDraw = false; //draw all the elements you like.
	}
	
	//{ SEQUENCES
	private function SetSequence():Void
	{
		var a:ViewManipulator = ViewManipulator.Create(Group, _MainView);
		a.StepEaseTowards(_MainView, 0, 0, 1.5, Ease.BOUNCE_IN);
		
		var b:ViewManipulator = ViewManipulator.Create(Group, _TitleView);
		b.StepAlpha(1.0, 0.0, 1.5);
		
		var c:ViewManipulator = ViewManipulator.Create(Group, _PlayButton);
		c.StepWait(0.4);
		c.StepAlpha(1.0, 0.0, 1.1);
		c.StepAddOnSequenceFinished(OnFinishTranslatingIn);
		
		var d:ViewManipulator = ViewManipulator.Create(Group, _PlayButton);
		d.StepEaseTowards(_PlayButton, 200, 500, 1.8, Ease.EASE_IN);
	}
	
	private function OnFinishTranslatingIn():Void
	{
		_PlayButton.AddOnClickEvent(OnPlayButtonPressed);
	}

	//}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			trace("Recycling");
			_TitleScreenRenderTarget.Recycle();
			_Controller.Recycle();
			super.Recycle();
		}
		
	}
	
	override public function OnRebirth():Void
	{
		Next = Head;
		Head = Self;
	}
	
	private function OnPlayButtonPressed():Void
	{
		Recycle();
		TitleScreen.Create(Group);
	}
	
}
```

Here is a video showing the results of the above code: http://www.youtube.com/watch?v=70qyn3LGL8g&feature=youtu.be

For more information on views check the ViewManipulator class.

--------------------------------------------------------------------------------

This framework is better used with its templates in FlashDevelop, you can find the templates for PooledItems, Entities, and Rue objects lists inside.

--------------------------------------------------------------------------------


This framework is open source under the MIT license.
