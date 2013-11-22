package engine.templates;
import engine.base.RueObject;
import engine.components.PositionComponent;
import engine.helpers.Profiler;
import engine.helpers.render.DrawStack;
import engine.helpers.RueMath;
import engine.helpers.RueRectangle;
import engine.helpers.TileDesc;
import engine.helpers.TileSheetEntry;
import engine.systems.MouseInputSystem;
import engine.templates.collections.RueCallback;
import engine.templates.collections.RueCallbackList;
import engine.templates.collections.ScreenGraphicList;
import engine.templates.collections.ViewElements;
import engine.templates.RueView;
import flash.display.Sprite;

/**
 * ...
 * @author Jakegr
 */
class RueScrollView extends RueView
{
	static var RueScrollHead:RueScrollView;
	var RueScrollSelf:RueScrollView;
	var RueScrollNext:RueScrollView;
	
	public var _OffsetX:Float;
	public var _OffsetY:Float;
	
	public var _MaxX:Float;
	public var _MaxY:Float;
	
	public var _MinX:Float;
	public var _MinY:Float;
	
	var _Width:Float;
	var _Height:Float;
	
	var _RenderTarget:DrawStack;
	
	var _MomemtumX:Float;
	var _MomemtumY:Float;
	
	private function new() 
	{
		super();
		RueScrollSelf = this;
	}

	public static function Create(Spritesheet:TileSheetEntry, LayerCount:Int = 2, Position:PositionComponent = null, Width:Float = 0, Height:Float = 0, MinX:Float = 0, MinY:Float = 0, MaxX:Float = 0, MaxY:Float = 0):RueScrollView
	{
		var Vessel:RueScrollView;
		if (RueScrollHead != null) { Vessel = RueScrollHead; RueScrollHead = RueScrollHead.RueScrollNext; }
		else { Vessel = new RueScrollView(); }
		Vessel.InPool = false;
		Vessel._Position = Position;
		
		if (Width != 0 && Height != 0)
		{
			Vessel._ClickRec = RueRectangle.Create(Position._X, Position._Y, Width, Height);
		}
		
		Vessel._MomemtumX = 0;
		Vessel._MomemtumY = 0;
		Vessel._MaxX = MaxX;
		Vessel._MaxY = MaxY;
		Vessel._MinX = MinX;
		Vessel._MinY = MinY;
		Vessel._OffsetX = 0;
		Vessel._OffsetY = 0;
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
		Vessel._Width = Width;
		Vessel._Height = Height;
		Vessel._CurrentDragX = 0;
		Vessel._CurrentDragY = 0;
		Vessel._IsDragging = false;
		Vessel._ElasticSpeedX = 5.5;
		Vessel._ElasticSpeedY = 5.5;
		Vessel._Rotation = 0;
		Vessel._CameraBound = false;
		Vessel._RenderTarget = DrawStack.Create(Spritesheet, null);
		Vessel._TakesUserInput = true;
		
		return Vessel;
	}
	
	override public function StartDragging():Void 
	{
		_MomemtumX = 0;
		_MomemtumY = 0;
		super.StartDragging();
	}
	
	override public function Dragging():Void 
	{
		if (!_IsDragging) { return; }
		
		var DeltaX:Float = MouseInputSystem.X - _LastDragX;
		var DeltaY:Float = MouseInputSystem.Y - _LastDragY;
		
		_MomemtumX = DeltaX;
		_MomemtumY = DeltaY;
		
		_LastDragX = MouseInputSystem.X;
		_LastDragY = MouseInputSystem.Y;
	}
	
	override public function Render(ParentX:Float, ParentY:Float, Canvas:DrawStack):Void 
	{
		//momemtum check
		_CurrentDragX += _MomemtumX;
		_CurrentDragY += _MomemtumY;
		if (_CurrentDragX < _MinX)
		{
			_CurrentDragX = _MinX;
			_MomemtumX = 0;
		}
		else if (_CurrentDragX > _MaxX)
		{
			_CurrentDragX = _MaxX;
			_MomemtumX = 0;
		}
		
		if (_CurrentDragY < _MinY)
		{
			_CurrentDragY = _MinY;
			_MomemtumY = 0;
		}
		else if (_CurrentDragY > _MaxY)
		{
			_CurrentDragY = _MaxY;
			_MomemtumY = 0;
		}
		if (_MomemtumX != 0)
		{
			var DireX:Int = RueMath.AbsoluteDirection(_MomemtumX);
			_MomemtumX -= Profiler.ElapsedTime*_MomemtumX*2;
			if (DireX != RueMath.AbsoluteDirection(_MomemtumX))
			{
				_MomemtumX = 0;
			}
		}
		
		if (_MomemtumY != 0)
		{
			var DireY:Int = RueMath.AbsoluteDirection(_MomemtumY);
			_MomemtumY -= Profiler.ElapsedTime *_MomemtumY*2;
			if (DireY != RueMath.AbsoluteDirection(_MomemtumY))
			{
				_MomemtumY = 0;
			}
		}
	
		//render portion
		if (_IsHidden) { return; }
		_OnDraw.TriggerAll();
		
		if (_RenderTarget.Owner == null)
		{
			_RenderTarget.SetOwner(Canvas.Target);
		}
		else
		if (_RenderTarget.Owner != Canvas.Target)
		{
			_RenderTarget.SetOwner(Canvas.Target);
		}
		
		_RenderTarget.SetFocusRect(_Position._X + ParentX, _Position._Y+ParentY, _Width, _Height);
		var X:Float = ParentX + _CurrentDragX + _Position._X;
		var Y:Float = ParentY + _CurrentDragY + _Position._Y;
		
		_Graphics.DrawAll(X , Y,_RenderTarget, _CameraBound);
		_DrawChildren.Render(X, Y, _RenderTarget);
	}
	
	public function SetWidthHeight(NewWidth:Float):Void
	{
		_Width = NewWidth;
		_ClickRec.Width = _Width;
		_RenderTarget.SetFocusRect(_Position._X, _Position._Y, _Width, _Height);
	}
	
	public function SetHeight(NewHeight:Float):Void
	{
		_Height = NewHeight;
		_ClickRec.Height = _Height;
		_RenderTarget.SetFocusRect(_Position._X, _Position._Y, _Width, _Height);
	}
	
	override public function CheckScreenInput(ClickX:Float, ClickY:Float, ParentX:Float, ParentY:Float):RueView 
	{
		if (!_TakesUserInput) { return null; }
		if (_ClickRec != null)
		{
			_ClickRec.X = ParentX + _Position._X;
			_ClickRec.Y = ParentY + _Position._Y;
			if (_ClickRec.ContainsFPoint(ClickX, ClickY))
			{
				if (MouseInputSystem.Clicked)
				{
					var Attempt:RueView = _DrawChildren.CheckInput(ClickX, ClickY, ParentX + _Position._X + _CurrentDragX, ParentY + _Position._Y+_CurrentDragY);
					if ( Attempt == null) //if no children are being clicked then this one is being clicked
					{
						return RueScrollSelf;
					}
					else
					{
						return Attempt;
					}
				}
				else
				{
					return RueScrollSelf;
				}
			}
		}
		return null;
	}
	
	
	public function AddGraphicHooked(Desc:TileDesc, Layer:Int = 0, X:Float = 0, Y:Float = 0, Alpha:Float = 1.0, Hook:ScreenGraphic = null):RueScrollView
	{
		Hook = ScreenGraphic.Create(Desc, Layer, X, Y, Alpha);
		_Graphics.Add(Hook);
		return RueScrollSelf;
	}
	

	override public function Recycle():Void 
	{
		if (!InPool)
		{
			_RenderTarget.Recycle();
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void 
	{
		RueScrollNext = RueScrollHead;
		RueScrollHead = RueScrollSelf;
	}
	
}