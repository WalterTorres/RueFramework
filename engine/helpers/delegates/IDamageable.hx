package engine.helpers.delegates;
import engine.helpers.enums.ElementType;
/**
 * ...
 * @author Jakegr
 */
 
interface IDamageable
{
	function ReceiveStraightDamage(damage:Int):Void;
	function ReceiveTypeDamage(damage:Int, theType:ElementType):Void;
}