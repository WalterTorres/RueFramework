package engine.templates;
import engine.base.RueObject;

/**
 * ...
 * @author Jakegr
 */

interface IScreenGraphic
{
	function Recycle():Void;
	function DrawFrom(ParentX:Float, ParentY:Float, CameraBound:Bool):Void;
	function SetRotation(Rot:Float):Void;
	function SetAlpha(Alpha:Float):Void;
	function OnRebirth():Void;
	function ConnectToNode(Node:RueNodeConnection):RueNodeConnection;
	
}