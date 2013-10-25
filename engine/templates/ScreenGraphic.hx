package engine.templates;
import engine.base.RueObject;
import engine.components.GraphicsComponent;
import engine.helpers.render.DrawStack;
import engine.helpers.TileDesc;


/**
 * ...
 * @author Jakegr
 */

class ScreenGraphic extends RueObject
{
	static var Head:ScreenGraphic;
	var Next:ScreenGraphic;
	var Self:ScreenGraphic;
	
	public var _Graphic:GraphicsComponent;
	public var _Layer:Int;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(GraphicID:TileDesc, Target:DrawStack, Layer:Int = 0):ScreenGraphic
	{
		var Vessel:ScreenGraphic;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new ScreenGraphic(); }
		Vessel.InPool = false;
		
		Vessel._Graphic = GraphicsComponent.Create(GraphicID, Target, Layer);
	
		Vessel._Layer = Layer;
		
		return Vessel;
	}

	public function Draw(ParentX:Float, ParentY:Float, CameraBound:Bool):Void
	{
		if (CameraBound)
		{
			_Graphic.RenderToCamera(ParentX, ParentY);
		}
		else
		{
			_Graphic.RenderToScreen(ParentX, ParentY);
		}
	}
	
	public function SetRotation(Rot:Float):Void
	{
		_Graphic.Rotation = Rot;
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