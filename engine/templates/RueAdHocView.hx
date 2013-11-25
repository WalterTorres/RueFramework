package engine.templates;

import engine.base.Entity;
import engine.base.EntityGroup;
import engine.base.RueObject;
import engine.components.PositionComponent;
import engine.gameElements.interfaces.IDisplayView;
import engine.helpers.Profiler;
import engine.helpers.render.DrawStack;
import engine.helpers.render.DrawStackList.DrawStackListNode;
import engine.helpers.RueMath;
import engine.helpers.RueRectangle;
import engine.helpers.TileDesc;
import engine.helpers.TileSheetEntry;
import engine.systems.MouseInputSystem;
import engine.systems.TileRenderSystem;
import engine.templates.collections.RueCallback;
import engine.templates.collections.RueCallbackList;
import engine.templates.collections.ScreenGraphicList;
import engine.templates.collections.ViewElements;
import engine.templates.MouseListener;
import engine.templates.RueView;
import flash.display.Sprite;

/**
 * ...
 * @author Jakegr
 */

class RueAdHocView extends Entity implements IDisplayView
{
	static var RueAdHocViewHead:RueAdHocView;
	var RueAdHocViewNext:RueAdHocView;
	var RueAdHocViewSelf:RueAdHocView;
	
	public var _TheView:RueView;
	
	var _DrawStack:DrawStack;
	
	private function new() 
	{
		super();
		RueAdHocViewSelf = this;
	}
	
	public static function Create(Group:EntityGroup, SPS:TileSheetEntry, Target:Sprite, X:Float, Y:Float, Width:Float = 0, Height:Float = 0):RueAdHocView
	{
		var Vessel:RueAdHocView;
		if(RueAdHocViewHead != null) { Vessel = RueAdHocViewHead; RueAdHocViewHead = RueAdHocViewHead.RueAdHocViewNext; }
		else { Vessel = new RueAdHocView(); }
		Vessel.Setup(Group);
		Vessel._TheView = RueView.Create(PositionComponent.Create(X, Y), Width, Height);
		Vessel._DrawStack = DrawStack.Create(SPS, Target);
		
		return Vessel;
	}
	
	public function AddGraphic(Desc:TileDesc, Layer:Int = 0, X:Float = 0, Y:Float = 0):Void
	{
		_TheView.AddGraphic(Desc, Layer, X, Y);
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			_TheView.Recycle();
			_DrawStack.Recycle();
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		RueAdHocViewNext = RueAdHocViewHead;
		RueAdHocViewHead = RueAdHocViewSelf;
	}
	
	override public function Draw():Void 
	{
		Render(0, 0, null);
	}
	
	
	public function Render(X:Float, Y:Float, Canvas:DrawStack):Void 
	{
		_TheView.Render(0, 0, _DrawStack);
	}
	
	public function UpdateClickRec(X:Float, Y:Float):Void 
	{
		
	}
	
	public function CheckScreenInput(X:Float, Y:Float, ParentX:Float, ParentY:Float):IDisplayView 
	{
		return null;
	}
	
	public function CancelDrags():Void 
	{
		
	}
	
	public function RemoveFromParentView():Void 
	{
		
	}
	
	public function SetParentView(Parent:IDisplayView):Void 
	{
		
	}
	
	public function SetChildConnection(Connection:RueNodeConnection):Void 
	{
		
	}
	
	public function SetInputPriority(Layer:Int):Void 
	{
		
	}
	
	public function AddChildView(Child:IDisplayView):IDisplayView 
	{
		return RueAdHocViewSelf;
	}
	
	
	public function StartDragging():Void 
	{
		
	}
	
	public function Dragging():Void 
	{
		
	}
	
	public function IsScrollable():Bool 
	{
		return false;
	}
		
	
}