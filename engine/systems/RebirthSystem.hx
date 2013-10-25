package engine.systems;

/**
 * ...
 * @author Jakegr
 */
class RebirthSystem
{
	//this will make sure all rue objects that got recycled will be put back into their respective pools for reuse.
	public static var Purgatory:RebirthList;
	
	public static function Init():Void
	{
		Purgatory = RebirthList.Create();
	}
	
	public static function Rebirth():Void
	{
		Purgatory.Rebirth();
	}

	private function new() 
	{
		
	}
	
}