package engine.gameElements;

import engine.components.PhysicsComponent;
import engine.helpers.RueMath;
import engine.World;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;

/**
 * ...
 * @author Jakegr
 */
class CollisionResponses
{
	//body types
	public static var cPLAYER:CbType = new CbType();
	public static var cENEMY:CbType = new CbType();
	public static var cAFFECTS_PLAYER:CbType = new CbType();
	public static var cAFFECTS_ENEMY:CbType = new CbType();
	public static var cAFFECTS_ALL:CbType = new CbType();
	public static var cMISC:CbType = new CbType();
	
	//the way that nape works is by using a group and mask system. in this case the player group would be of value 1, so if something doesn't collide or sense
	//the player, then it should mask the value 1 like this: ~(1) 
	public static var filterPLAYER:InteractionFilter = new InteractionFilter(1, ~(1|2|8|32), 1, ~(1|8|32)); //don't collide with enemy/affects enemy/misc, don't sense affects enemy and misc
	public static var filterENEMY:InteractionFilter = new InteractionFilter(2, ~(1|2|4|32), 2, ~(2|4|32));
	public static var filterAFFECTS_PLAYER:InteractionFilter = new InteractionFilter(4, ~(1|2|4|8|16|32), 4, ~(2|4|8|32));
	public static var filterAFFECTS_ENEMY:InteractionFilter = new InteractionFilter(8, ~(1|2|4|8|16|32), 8, ~(1|4|8|32));
	public static var filterAFFECTS_ALL:InteractionFilter = new InteractionFilter(16, ~(32), 16, ~(32));
	public static var filterMISC:InteractionFilter = new InteractionFilter(32, ~(1|2|4|8|16|32|64|128),32, ~(1|2|4|8|16|32|64|128));
	//end
	

	public static function SetUpRules():Void
	{
		
		
	}
	
	private static inline function PreCallExample(cb:PreCallback):PreFlag
	{
		return PreFlag.IGNORE;
	}
	
	private static inline function InteractionCallExample(ic:InteractionCallback):Void
	{
	
	}
	


	private function new() 
	{
		
	}
	
}