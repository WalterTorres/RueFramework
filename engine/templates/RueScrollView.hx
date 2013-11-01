package engine.templates;
import engine.components.PositionComponent;
import engine.helpers.render.DrawStack;

/**
 * ...
 * @author Jakegr
 */
class RueScrollView extends RueView
{
	static var RueScrollHead:RueScrollView;
	var RueScrollSelf:RueScrollView;
	var RueScrollNext:RueScrollView;
	
	var _ScrollViewRenderTarget:DrawStack;
	
	private function new() 
	{
		super();
		RueScrollSelf = this;
	}
	
	/**
	 * Scroll views control their own render target, which is fixed to be of a certain dimensions and all the graphics that belong to this view will not be visible outside the bounds of the view.
	 * 
	 * @param	RenderTarget 	The parent render target where this view will be placed.
	 * @param	Position		X and Y of the view.	
	 * @param	Width			How big the render target viewport is in width.
	 * @param	Height			How big the render target viewport is in height.
	 * @return
	 */
	public static function Create(RenderTarget:DrawStack, Position:PositionComponent = null, Width:Float = 0, Height:Float = 0):RueScrollView
	{
		var Vessel:RueScrollView;
		if (RueScrollHead != null) { Vessel = RueScrollHead; RueScrollHead = RueScrollHead.RueScrollNext; }
		else { Vessel = new RueScrollView(); }
		Vessel.InPool = false;
		
		return Vessel;
	}

	override public function Recycle():Void 
	{
		if (!InPool)
		{
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void 
	{
		RueScrollNext = RueScrollHead;
		RueScrollHead = RueScrollSelf;
	}
	
}