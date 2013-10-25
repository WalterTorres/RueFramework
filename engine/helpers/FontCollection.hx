package engine.helpers;
import flash.text.Font;
import openfl.Assets;

/**
 * ...
 * @author Jakegr
 */
class FontCollection
{
//here you would load your fonts, you can make static references to them.
	//public static var QuidBoldFont:Font;

	
	public static function Init():Void
	{
		//here is an example on how to load a font, you can use something else.
		//QuidBoldFont = LoadFont("quidbold");
		
	}
	
	private static function LoadFont(Name:String):Font
	{
		return Assets.getFont("fonts/" + Name + ".ttf");
	}

	private function new() 
	{
		
	}
	
}