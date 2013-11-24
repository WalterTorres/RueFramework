package engine.templates;

import engine.base.RueObject;
import engine.components.PositionComponent;
import engine.gameElements.interfaces.IDisplayView;
import engine.helpers.Profiler;
import engine.helpers.render.DrawStack;
import engine.helpers.RueMath;
import engine.helpers.RueRectangle;
import engine.helpers.TileDesc;
import engine.systems.MouseInputSystem;
import engine.systems.TileRenderSystem;
import engine.templates.collections.RueCallback;
import engine.templates.collections.RueCallbackList;
import engine.templates.collections.ScreenGraphicList;
import engine.templates.collections.ViewElements;
import engine.templates.MouseListener;
import flash.geom.Matrix;

/**
 * ...
 * @author Jakegr
 */
class RueView extends MouseListener implements IDisplayView
{
	static var Head:RueView;
	var Self:RueView;
	var Next:RueView;
	
	var _DrawChildren:ViewElements;
	public var _Graphics:ScreenGraphicList;
	var _CameraBound:Bool;
	public var _ParentView:IDisplayView;
	public var _Position:PositionComponent;
	public var _IsHidden:Bool;
	public var _ClickRec:RueRectangle;
	public var _OnClick:RueCallbackList;
	public var _OnDraw:RueCallbackList;
	public var _OnRecycle:RueCallbackList;
	public var _IsScrollable:Bool;
	var _LastDragX:Float; //the position of the last delta for the drag
	var _LastDragY:Float;
	var _ParentConnection:RueNodeConnection;
	public var _MaxDragX:Float;
	public var _MaxDragY:Float;
	public var _CurrentDragX:Float;
	public var _CurrentDragY:Float;
	public var _IsDragging:Bool;
	public var _Rotation:Float;
	public var _ElasticSpeedX:Float;
	public var _ElasticSpeedY:Float;
	public var _TakesUserInput:Bool;
	public var _InputLayer:Int; //input layer corresponds to what layer the view is at.
	
	private function new() 
	{
		super();
		Self = this;
	}
	//{ FACTORY METHODS
	public static function CreateWithController(Controller:RueViewController, Position:PositionComponent = null, Width:Float = 0, Height:Float = 0):RueView
	{
		var Vessel:RueView;
		if (Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueView(); }
		Vessel.InPool = false;
		Vessel.InitView(Vessel, Position, Width, Height);
		Controller.SetView(Vessel);
		return Vessel;
	}
	
	public static function CreateWithParent(Parent:RueView, Position:PositionComponent = null, Width:Float = 0, Height:Float = 0):RueView
	{
		var Vessel:RueView;
		if (Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueView(); }
		Vessel.InPool = false;
		Vessel.InitView(Vessel, Position, Width, Height);
		Parent.AddChildView(Vessel);
		return Vessel;
	}

	public static function Create(Position:PositionComponent = null, Width:Float = 0, Height:Float = 0):RueView
	{
		var Vessel:RueView;
		if (Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueView(); }
		Vessel.InPool = false;
		Vessel.InitView(Vessel, Position, Width, Height);
		return Vessel;
	}
	//}
	private function InitView(Vessel:RueView, Position:PositionComponent = null, Width:Float = 0, Height:Float = 0):Void
	{
		if (Position == null) { Position = PositionComponent.Create(); } 
		Vessel._Position = Position;
		if (Width != 0 && Height != 0)
		{
			Vessel._ClickRec = RueRectangle.Create(Position._X, Position._Y, Width, Height);
		}
		Vessel._ParentView = null;
		Vessel._ParentConnection = null;
		Vessel._IsHidden = false;
		Vessel._DrawChildren = ViewElements.Create();
		Vessel._Graphics = ScreenGraphicList.Create();
		Vessel._OnClick = RueCallbackList.Create();
		Vessel._OnDraw = RueCallbackList.Create();
		Vessel._OnRecycle = RueCallbackList.Create();
		Vessel._IsScrollable = true;
		Vessel._MaxDragX = 0;
		Vessel._MaxDragY = 0;
		Vessel._CurrentDragX = 0;
		Vessel._CurrentDragY = 0;
		Vessel._IsDragging = false;
		Vessel._ElasticSpeedX = 5.5;
		Vessel._ElasticSpeedY = 5.5;
		Vessel._Rotation = 0;
		Vessel._CameraBound = false;
		Vessel._TakesUserInput = true;
		Vessel._InputLayer = 0;
		Vessel.AddToMouseListener(0);
	}
	
	public function SetInputPriority(LayerInput:Int):Void
	{
		RemoveFromMouseListener();
		AddToMouseListener(LayerInput);
		_InputLayer = LayerInput;
	}
	
	public function StartDragging():Void
	{
		_LastDragX = MouseInputSystem.X;
		_LastDragY = MouseInputSystem.Y;
		trace(_LastDragX);
		trace(_LastDragY);
		_IsDragging = true;
	}
	
	public function CancelDrags():Void
	{
		_IsDragging = false;
		_DrawChildren.CancelAllDrags();
	}
	
	public function Dragging():Void
	{
		if (!_IsScrollable || !_IsDragging) { return; }
		if (_MaxDragX == 0 && _MaxDragY == 0) { _IsDragging = false; return; }
		var DeltaX:Float = MouseInputSystem.X - _LastDragX;
		var DeltaY:Float = MouseInputSystem.Y - _LastDragY;
		
		_CurrentDragX += DeltaX;
		_CurrentDragY += DeltaY;
		
		if (RueMath.Abs(_CurrentDragX) > _MaxDragX)
		{
			_CurrentDragX = RueMath.AbsoluteDirection(_CurrentDragX) * _MaxDragX;
		}
		if (RueMath.Abs(_CurrentDragY) > _MaxDragY)
		{
			_CurrentDragY = RueMath.AbsoluteDirection(_CurrentDragY) * _MaxDragY;
		}
		
		_LastDragX = MouseInputSystem.X;
		_LastDragY = MouseInputSystem.Y;
	}
	
	public function Render(ParentX:Float, ParentY:Float, RenderTarget:DrawStack):Void
	{
		if (_IsHidden) { return; }
		if (!_IsDragging)
		{
			if (_CurrentDragX != 0)
			{
				var Dir:Int = RueMath.AbsoluteDirection(_CurrentDragX);
				_CurrentDragX += Dir * -1 * _ElasticSpeedX * RueMath.Abs(_CurrentDragX) * Profiler.ElapsedTime;
				if (_CurrentDragX == 0 || Dir != RueMath.AbsoluteDirection(_CurrentDragX))
				{
					_CurrentDragX = 0;
				}
			}
			if (_CurrentDragY != 0)
			{
				var Dir:Int = RueMath.AbsoluteDirection(_CurrentDragY);
				_CurrentDragY += Dir * -1 * _ElasticSpeedY * RueMath.Abs(_CurrentDragY)  * Profiler.ElapsedTime;
				if (_CurrentDragY == 0 || Dir != RueMath.AbsoluteDirection(_CurrentDragY))
				{
					_CurrentDragY = 0;
				}
			}
		}
		else
		{
			_ClickRec.X = ParentX + _Position._X + _CurrentDragX;
			_ClickRec.Y = ParentY + _Position._Y + _CurrentDragY;
			if (!_ClickRec.ContainsFPoint(MouseInputSystem.X, MouseInputSystem.Y))
			{
				CancelDrags();
			}
		}

		var X:Float = ParentX + _Position._X + _CurrentDragX;
		var Y:Float = ParentY + _Position._Y + _CurrentDragY;

		
		
		_Graphics.DrawAll(X , Y, RenderTarget, _CameraBound);
		_DrawChildren.Render(X, Y, RenderTarget);
		
		_OnDraw.TriggerAll();
	}
	
	public function UpdateClickRec(ParentX:Float, ParentY:Float):Void
	{
		var NewX:Float = ParentX + _Position._X + _CurrentDragX;
		var NewY:Float = ParentY + _Position._Y + _CurrentDragY;
		if (_ClickRec != null)
		{
			_ClickRec.X = NewX;
			_ClickRec.Y = NewY;
		}
		_DrawChildren.UpdateClickRecPosition(NewX, NewY);
	}

	/**
	 * This method is used internally for the Dragging checking.
	 * @param	ClickX
	 * @param	ClickY
	 * @param	ParentX
	 * @param	ParentY
	 * @return
	 */
	public function CheckScreenInput(ClickX:Float, ClickY:Float, ParentX:Float, ParentY:Float):IDisplayView
	{
		if (_ClickRec != null)
		{
			_ClickRec.X = ParentX + _Position._X + _CurrentDragX;
			_ClickRec.Y = ParentY + _Position._Y + _CurrentDragY;
			if (_ClickRec.ContainsFPoint(ClickX, ClickY))
			{
				var Attempt:IDisplayView = _DrawChildren.CheckInput(ClickX, ClickY, ParentX + _Position._X, ParentY + _Position._Y);
				if ( Attempt == null) //if no children are being clicked then this one is being clicked
				{
					if (!_TakesUserInput)
					{ 
						return null;
					}
					return Self;
				}
				else
				{
					return Attempt;
				}
			}
		}
		return null;
	}
	
	/**
	 * This method gets called when the user makes a tap (or mouse click), all views are subcribed to the mouse listeners.
	 * @param	X
	 * @param	Y
	 * @return
	 */
	override public function CheckInput(X:Float, Y:Float):Bool 
	{
		if (_ClickRec != null)
		{
			if (_ClickRec.ContainsFPoint(X, Y))
			{
				_OnClick.TriggerAll();
				return true;
			}
		}
		return false;
	}
	
	public function AddChildView(Child:IDisplayView):IDisplayView
	{
		Child.RemoveFromParentView(); //if it belongs to another view, remove it from it.
		Child.SetParentView(Self); //set yourself as the new parent
		Child.SetInputPriority(_InputLayer + 1); //set the click priority of this view to one higher than yourself.
		var ChildToParentConnection:RueNodeConnection = _DrawChildren.Add(Child); //get the connection
		Child.SetChildConnection(ChildToParentConnection); //set the connection in case your child needs to remove itself from you.
		
		return Self;
	}
	
	
	
	public function AddGraphic(Desc:TileDesc, Layer:Int = 0, X:Float = 0, Y:Float = 0, Alpha:Float = 1.0):RueView
	{
		_Graphics.Add(ScreenGraphic.Create(Desc, Layer, X, Y, Alpha));
		return Self;
	}
	
	public function AddGraphicDirect(Add:IScreenGraphic):RueView
	{
		_Graphics.Add(Add);
		return Self;
	}
	
	public function RemoveFromParentView():Void
	{
		if (_ParentConnection != null)
		{
			_ParentConnection.Remove();
			_ParentConnection = null;
		}
	}
	
	public function AddOnRecycleEvent(OnRes:Void->Void):RueCallback
	{
		var Re:RueCallback = RueCallback.Create(OnRes);
		_OnRecycle.Add(Re);
		return Re;
	}
	
	public function AddOnDrawEvent(OnDraw:Void->Void):RueCallback
	{
		var Re:RueCallback = RueCallback.Create(OnDraw);
		_OnDraw.Add(Re);
		return Re;
	}
	
	public function AddOnClickEvent(OnClick:Void->Void):RueCallback
	{
		var Re:RueCallback = RueCallback.Create(OnClick);
		_OnClick.Add(Re);
		return Re;
	}
	
	override public function Recycle():Void 
	{
		if (!InPool)
		{
			_Position.Recycle();
			if (_ClickRec != null)
			{
				_ClickRec.Recycle();
				_ClickRec = null;
			}
			_OnRecycle.TriggerAll();
			_OnRecycle.RecycleAll();
			_OnRecycle.Recycle();
			_OnClick.RecycleAll();
			_OnClick.Recycle();
			_OnDraw.RecycleAll();
			_OnDraw.Recycle();

			_DrawChildren.RecycleElements();
			_Graphics.RecycleElements();
			_DrawChildren.Recycle();
			_Graphics.Recycle();
			//Rueobject recycle
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void 
	{
		Next = Head;
		Head = Self;
	}
	
	/* INTERFACE engine.gameElements.interfaces.IDisplayView */
	
	public function SetParentView(Parent:IDisplayView):Void 
	{
		_ParentView = Parent;
	}
	
	public function SetChildConnection(Connection:RueNodeConnection):Void 
	{
		_ParentConnection = Connection;
	}
	
	public function IsScrollable():Bool 
	{
		return _IsScrollable;
	}
}