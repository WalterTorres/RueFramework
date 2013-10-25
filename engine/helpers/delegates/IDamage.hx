package engine.helpers.delegates;
import engine.helpers.enums.ElementType;
/**
 * ...
 * @author Jakegr
 */
interface IDamage
{
	function DealTypeDamage(damage:Int, theType:ElementType, target:IDamageable):Void;
	function DealStraightDamage(damage:Int, target:IDamageable):Void;
	function GetDamage():Int;
	function GetDamageType():ElementType;
	function InternalDamage(target:IDamageable):Void;
}