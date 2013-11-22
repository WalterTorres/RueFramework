package engine.helpers;
import engine.base.RueObject;
import engine.templates.MouseListener;

/**
 * ...
 * @author Jakegr
 */

class MouseHitBox extends MouseListener
{
	static var MouseHitBoxHead:MouseHitBox;
	var MouseHitBoxNext:MouseHitBox;
	var MouseHitBoxSelf:MouseHitBox;
	
	public var Width:Float;
	public var Height:Float;
	
	public var _X:Float;
	public var _Y:Float;
	
	public var OffsetX:Float;
	public var OffsetY:Float;
	
	public var _OnClicked:Void->Void;
	
	private function new() 
	{
		super();
		MouseHitBoxSelf = this;
	}
	
	public static function Create(ListenLayer:Int, OnClicked:Void->Void, X:Float, Y:Float, Width:Float, Height:Float, OffsetX:Float = 0, OffsetY:Float = 0):MouseHitBox
	{
		var Vessel:MouseHitBox;
		if(MouseHitBoxHead != null) { Vessel = MouseHitBoxHead; MouseHitBoxHead = MouseHitBoxHead.MouseHitBoxNext; }
		else { Vessel = new MouseHitBox(); }
		Vessel.InPool = false;
		Vessel._X = X + OffsetX;
		Vessel._Y = Y + OffsetY;
		Vessel.OffsetX = OffsetX;
		Vessel.OffsetY = OffsetY;
		Vessel.Width = Width;
		Vessel.Height = Height;
		Vessel._OnClicked = OnClicked;
		Vessel.AddToMouseListener(ListenLayer);
		
		return Vessel;
	}
	
	public inline function AdjustBody(OwnerX:Float, OwnerY:Float):Void
	{
		_X = OwnerX + OffsetX;
		_Y = OwnerY + OffsetY;
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			super.Recycle();
		}
	}
	
	override public function CheckInput(X:Float, Y:Float):Bool 
	{
		if ((((_X <= X) && (X < _X + Width)) && (_Y <= Y)) && (Y < _Y + Height))
		{
			_OnClicked();
			return true;
		}
		
		return false;
	}
	
	override public function OnRebirth():Void
	{
		MouseHitBoxNext = MouseHitBoxHead;
		MouseHitBoxHead = MouseHitBoxSelf;
	}
		
	
}