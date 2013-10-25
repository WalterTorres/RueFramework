package engine;
import engine.base.EntityGroup;
import engine.helpers.FontCollection;
import engine.helpers.render.DrawStack;
import engine.helpers.RueRectangle;
import engine.systems.TileRenderSystem;
import engine.templates.RueView;
import engine.templates.RueViewController;
import engine.templates.ScreenGraphic;


/**
 * ...
 * @author Jakegr
 */
class EntryPoint
{
	public static var Group:EntityGroup;
	private function new() 
	{
		
	}
	
	public static function MainEntry(MainGroup:EntityGroup):Void
	{
		Group = MainGroup;
		//Add your code here:

	}
	
	
}