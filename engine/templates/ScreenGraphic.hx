package engine.templates;
import engine.base.RueObject;
import engine.components.GraphicsComponent;
import engine.helpers.render.DrawStack;
import engine.helpers.TileDesc;


/**
 * ...
 * @author Jakegr
 */

class ScreenGraphic extends RueObject implements IScreenGraphic
{
	static var Head:ScreenGraphic;
	var Next:ScreenGraphic;
	var Self:ScreenGraphic;
	
	public var _Graphic:GraphicsComponent;
	public var _X:Float;
	public var _Y:Float;
	
	private function new() 
	{
			
		super();
		Self = this;
	}
	
	public static function Create(GraphicID:TileDesc, Layer:Int = 0, X:Float = 0, Y:Float = 0, Alpha:Float = 1.0):ScreenGraphic
	{
		var Vessel:ScreenGraphic;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new ScreenGraphic(); }
		Vessel.InPool = false;
		
		Vessel._Graphic = GraphicsComponent.Create(GraphicID, null, Layer);
		Vessel._Graphic.Alpha = Alpha;
		Vessel._X = X;
		Vessel._Y = Y;
		
		return Vessel;
	}

	public function DrawFrom(ParentX:Float, ParentY:Float, Canvas:DrawStack, CameraBound:Bool):Void
	{
		_Graphic.TargetCanvas = Canvas;
		
		if (CameraBound)
		{
			_Graphic.RenderToCamera(ParentX + _X, ParentY + _Y);
		}
		else
		{
			_Graphic.RenderToScreen(ParentX + _X, ParentY + _Y);
		}
	}
	
	public function SetRotation(Rot:Float):Void
	{
		_Graphic.Rotation = Rot;
	}
	
	public function SetAlpha(Alpha:Float):Void
	{
		_Graphic.Alpha = Alpha;
	}
	
	public override function Recycle():Void
	{
		if (!InPool)
		{
			_Graphic.Recycle();
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void 
	{
		Next = Head;
		Head = Self;
	}
		
	
}