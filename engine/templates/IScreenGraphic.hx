package engine.templates;
import engine.base.RueObject;
import engine.helpers.render.DrawStack;

/**
 * ...
 * @author Jakegr
 */

interface IScreenGraphic
{
	function Recycle():Void;
	function DrawFrom(ParentX:Float, ParentY:Float, Canvas:DrawStack, CameraBound:Bool):Void;
	function SetRotation(Rot:Float):Void;
	function SetAlpha(Alpha:Float):Void;
	function OnRebirth():Void;
	function ConnectToNode(Node:RueNodeConnection):RueNodeConnection;
	
}