package engine.systems;
import flash.media.SoundTransform;
import flash.media.Sound;
import flash.media.SoundChannel;
import openfl.Assets;
/**
 * ...
 * @author Jakegr
 */

class SoundSystem 
{
	public static var TheVolume:SoundTransform;
	private static var SoundDic:Array<Sound>;
	
	private static var Count:Int;
	
	//LABELS

	public static function Init():Void
	{
		Count = 0;
		TheVolume = new SoundTransform();
		SoundDic = new Array<Sound>();
		
		//ADJUST LABELS
		
		//FIX DICTIONARY SIZE
		for (i in 0...Count)
		{
			SoundDic.push(null);
		}
		
		//LOAD SOUNDS
	}
	
	public static function Play(ID:Int, Volume:Float, Loop:Int):Void
	{
		TheVolume.volume = Volume;
		SoundDic[ID].play(0, Loop, TheVolume);
	}
	
	private function new() 
	{
			
	}
	
}