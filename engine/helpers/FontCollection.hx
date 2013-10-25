package engine.helpers;
import flash.text.Font;
import openfl.Assets;

/**
 * ...
 * @author Jakegr
 */
class FontCollection
{
	public static var QuidBoldFont:Font;

	
	public static function Init():Void
	{
		QuidBoldFont = LoadFont("quidbold");
	}
	
	private static function LoadFont(Name:String):Font
	{
		return Assets.getFont("fonts/" + Name + ".ttf");
	}

	private function new() 
	{
		
	}
	
}