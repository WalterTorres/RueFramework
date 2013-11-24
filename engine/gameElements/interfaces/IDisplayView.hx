package engine.gameElements.interfaces;
import engine.base.RueObject.RueNodeConnection;
import engine.helpers.render.DrawStack;
import engine.templates.RueView;

/**
 * ...
 * @author Jakegr
 */

interface IDisplayView 
{
	function Render(X:Float, Y:Float, Canvas:DrawStack):Void;
	function UpdateClickRec(X:Float, Y:Float):Void;
	function CheckScreenInput(X:Float, Y:Float, ParentX:Float, ParentY:Float):IDisplayView;
	function CancelDrags():Void;
	function Recycle():Void;
	function ConnectToNode(Node:RueNodeConnection):RueNodeConnection;
	function RemoveFromParentView():Void;
	function SetParentView(Parent:IDisplayView):Void;
	function SetChildConnection(Connection:RueNodeConnection):Void;
	function SetInputPriority(Layer:Int):Void;
	function AddChildView(Child:IDisplayView):IDisplayView;
	function StartDragging():Void;
	function Dragging():Void;
	function IsScrollable():Bool;
}