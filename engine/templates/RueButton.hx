package engine.templates;
import engine.base.RueObject;
import engine.components.PositionComponent;
import engine.helpers.TileDesc;

/**
 * ...
 * @author Jakegr
 */

class RueButton extends RueView
{
	static var RueButtonHead:RueButton;
	var RueButtonNext:RueButton;
	var RueButtonSelf:RueButton;
	
	private function new() 
	{
		super();
		RueButtonSelf = this;
	}
	
	public static function Create(Parent:RueView, OnClick:Void->Void, Graphic:TileDesc, Position:PositionComponent = null, Width:Float = 1, Height:Float = 1):RueButton
	{
		var Vessel:RueButton;
		if(RueButtonHead != null) { Vessel = RueButtonHead; RueButtonHead = RueButtonHead.RueButtonNext; }
		else { Vessel = new RueButton(); }
		Vessel.InPool = false;
		Vessel.InitView(Vessel, Position, Width, Height);
		Vessel.AddGraphic(Graphic, 0);
		Vessel.AddOnClickEvent(OnClick);
		Parent.AddChildView(Vessel);
		
		return Vessel;
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		RueButtonNext = RueButtonHead;
		RueButtonHead = RueButtonSelf;
	}
		
	
}