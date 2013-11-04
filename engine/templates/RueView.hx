package engine.templates;

import engine.base.RueObject;
import engine.components.PositionComponent;
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
import flash.geom.Matrix;

/**
 * ...
 * @author Jakegr
 */
class RueView extends RueObject
{
	static var Head:RueView;
	var Self:RueView;
	var Next:RueView;
	
	var _DrawChildren:ViewElements;
	public var _Graphics:ScreenGraphicList;
	
	var _CameraBound:Bool;
	
	public var _ParentView:RueView;
	public var _Position:PositionComponent;
	public var _IsHidden:Bool;
	public var _ClickRec:RueRectangle;
	public var _OnClick:RueCallbackList;
	public var _OnDraw:RueCallbackList;
	public var _OnRecycle:RueCallbackList;
	public var _IsScrollable:Bool;
	
	var _LastDragX:Float; //the position of the last delta for the drag
	var _LastDragY:Float;
	
	public var _MaxDragX:Float;
	public var _MaxDragY:Float;
	
	var _CurrentDragX:Float;
	var _CurrentDragY:Float;
	
	public var _IsDragging:Bool;
	public var _Rotation:Float;
	
	public var _ElasticSpeedX:Float;
	public var _ElasticSpeedY:Float;
	
	public var _RenderTarget:DrawStack;
	
	private function new() 
	{
		super();
		Self = this;
	}

	public static function Create(RenderTarget:DrawStack, Position:PositionComponent = null, Width:Float = 0, Height:Float = 0):RueView
	{
		var Vessel:RueView;
		if (Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueView(); }
		Vessel.InPool = false;
		if (Position == null) { Position = PositionComponent.Create(); } 
		Vessel._Position = Position;
		if (Width != 0 && Height != 0)
		{
			Vessel._ClickRec = RueRectangle.Create(Position._X, Position._Y, Width, Height);
		}
		Vessel._ParentView = null;
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
		Vessel._RenderTarget = RenderTarget;
		
		return Vessel;
	}
	
	public function StartDragging():Void
	{
		_LastDragX = MouseInputSystem.X;
		_LastDragY = MouseInputSystem.Y;
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
	
	public function Render(ParentX:Float, ParentY:Float):Void
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

		
		
		_Graphics.DrawAll(X , Y, _Rotation, _CameraBound);
		_DrawChildren.Render(X, Y);
		
		_OnDraw.TriggerAll();
	}
	
	public function CheckScreenInput(ClickX:Float, ClickY:Float, ParentX:Float, ParentY:Float):RueView
	{
		if (_ClickRec != null)
		{
			_ClickRec.X = ParentX + _Position._X + _CurrentDragX;
			_ClickRec.Y = ParentY + _Position._Y + _CurrentDragY;
			if (_ClickRec.ContainsFPoint(ClickX, ClickY))
			{
				var Attempt:RueView = _DrawChildren.CheckInput(ClickX, ClickY, ParentX + _Position._X, ParentY + _Position._Y);
				if ( Attempt == null) //if no children are being clicked then this one is being clicked
				{
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
	
	public function AddChildView(Child:RueView):RueView
	{
		if (Child._ParentView != null)//if it belongs to another view before adding it to this view, it should be properly removed from it
		{
			Child.RemoveFromParentView();
		}
		
		Child._ParentView = Self;
		_DrawChildren.Add(Child);
		
		return Self;
	}
	
	public function AddGraphic(Desc:TileDesc, Layer:Int = 0, X:Float = 0, Y:Float = 0, Alpha:Float = 1.0):RueView
	{
		_Graphics.Add(ScreenGraphic.Create(Desc, _RenderTarget, Layer, X, Y, Alpha));
		return Self;
	}
	
	public function AddGraphicDirect(Add:ScreenGraphic):RueView
	{
		_Graphics.Add(Add);
		return Self;
	}
	
	public function RemoveFromParentView():Void
	{
		while (_HeadNode != null)
		{
			_HeadNode.Remove();
		}
	}
	
	public function AddOnRecycleEvent(OnRes:Void->Void):Void
	{
		_OnRecycle.Add(RueCallback.Create(OnRes));
	}
	
	public function AddOnDrawEvent(OnDraw:Void->Void):Void
	{
		_OnDraw.Add(RueCallback.Create(OnDraw));
	}
	
	public function AddOnClickEvent(OnClick:Void->Void):Void
	{
		_OnClick.Add(RueCallback.Create(OnClick));
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
}