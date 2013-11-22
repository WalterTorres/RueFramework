package engine.templates;
import engine.base.Entity;
import engine.base.RueObject;
import engine.helpers.render.DrawStack;
import flash.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

/**
 * ...
 * @author Jakegr
 */

class RueTextField extends RueObject implements IScreenGraphic
{
	static var RueTextFieldHead:RueTextField;
	var RueTextFieldNext:RueTextField;
	var RueTextFieldSelf:RueTextField;
	
	var _Parent:Sprite;
	public var _Text:TextField;
	public var _DropShadow:TextField;
	public var _HasDropShadow:Bool;
	var _Font:Font;
	public var _X:Float;
	public var _Y:Float;
	var _Size:Int;
	var _Color:UInt;
	var _Selectable:Bool;
	var _Editable:Bool;
	
	private function new() 
	{
		
		super();
		RueTextFieldSelf = this;
	}
	
	public static function Create(X:Float, Y:Float, Size:Int, TheFont:Font, Editable:Bool = false, Selectable:Bool = false, color:UInt = 0x5a1516, HasDropShadow:Bool = false):RueTextField
	{
		var Vessel:RueTextField;
		if(RueTextFieldHead != null) { Vessel = RueTextFieldHead; RueTextFieldHead = RueTextFieldHead.RueTextFieldNext; }
		else { Vessel = new RueTextField(); }
		Vessel.InPool = false;
		
		Vessel._Font = TheFont;
		Vessel._Selectable = Selectable;
		Vessel._Editable = Editable;

		Vessel._HasDropShadow = HasDropShadow;
		Vessel._X = X;
		Vessel._Y = Y;
		Vessel._Size = Size;
		Vessel._Color = color;
		Vessel.ChangeTextTo("");

		return Vessel;
	}
	
	public function ChangeTextTo(ToThis:String):Void
	{
		if (_Text != null)
		{
			if (ToThis == _Text.text) { return; }
		}
		
		var X:Float = 0;
		var Y:Float = 0;
		
		if (_Text != null)
		{
			X = _Text.x;
			Y = _Text.y;	
		}
		
		
		if (_Parent != null)
		{
			_Parent.removeChild(_Text); 
		}

		_Text = new TextField();
		_Text.multiline = true;
		_Text.mouseEnabled = _Editable;
		_Text.selectable = _Selectable;
		if (_Editable)
		{
			_Text.type = TextFieldType.INPUT;
		}
		_Text.embedFonts = true;
		_Text.width = ToThis.length * (_Size+1);
		_Text.height = (_Size*1.5);
		_Text.text = ToThis;
		var _TextForm:TextFormat = new TextFormat(_Font.fontName, _Size, _Color );
		_Text.setTextFormat(_TextForm);
	
		_Text.x = X;
		_Text.y = Y;
		
		if (_HasDropShadow)
		{

			if (_Text != null)
			{
				X = _Text.x;
				Y = _Text.y;	
			}
			if (_Parent != null)
			{
				_Parent.removeChild(_DropShadow); 
			}
	
			_DropShadow = new TextField();
			_DropShadow.mouseEnabled = false;
			_DropShadow.selectable = false;
			_DropShadow.embedFonts = true;
			_DropShadow.width = ToThis.length * (_Size+1);
			_DropShadow.height = (_Size*2.5);
			_DropShadow.text = ToThis;
			var _TextFormShadow:TextFormat = new TextFormat(_Font.fontName, _Size, 0x000000 );
			_DropShadow.setTextFormat(_TextFormShadow);
			if (_Parent != null)
			{
				_Parent.addChild(_DropShadow); 
			}
			_DropShadow.x = X+2;
			_DropShadow.y = Y+2;
		}
		
			if (_Parent != null)
		{
			_Parent.addChild(_Text); 
		}
	}
	
	public function ChangeColor(ToThisColor:UInt):Void
	{
		_Color = ToThisColor;
		var ToThis:String = _Text.text;
		
		var X:Float = 0;
		var Y:Float = 0;
		if (_Text != null)
		{
			X = _Text.x;
			Y = _Text.y;	
		}
		if (_Parent != null)
		{
			_Parent.removeChild(_Text); 
		}

		_Text = new TextField();
		_Text.mouseEnabled = _Editable;
		_Text.selectable = _Selectable;
		if (_Editable)
		{
			_Text.type = TextFieldType.INPUT;
		}
		_Text.embedFonts = true;
		_Text.width = ToThis.length * (_Size+1);
		_Text.height = (_Size*2.5);
		_Text.text = ToThis;
		var _TextForm:TextFormat = new TextFormat(_Font.fontName, _Size, _Color );
		_Text.setTextFormat(_TextForm);
		
		_Text.x = X;
		_Text.y = Y;
		
		if (_HasDropShadow)
		{
			_Color = ToThisColor;
			
			if (_Text != null)
			{
				X = _Text.x;
				Y = _Text.y;	
			}
			if (_Parent != null)
			{
				_Parent.removeChild(_DropShadow); 
			}
	
			_DropShadow = new TextField();
			_DropShadow.mouseEnabled = false;
			_DropShadow.selectable = false;
			_DropShadow.embedFonts = true;
			_DropShadow.width = ToThis.length * (_Size+1);
			_DropShadow.height = (_Size*2.5);
			_DropShadow.text = ToThis;
			var _TextFormShadow:TextFormat = new TextFormat(_Font.fontName, _Size, 0x000000 );
			_DropShadow.setTextFormat(_TextFormShadow);
			if (_Parent != null)
			{
				_Parent.addChild(_DropShadow); 
			}
			_DropShadow.x = X+2;
			_DropShadow.y = Y+2;
		}
		
		if (_Parent != null)
		{
			_Parent.addChild(_Text); 
		}
	}
	
	public function CenterTo(X:Float):Void
	{
		_X = X - _Text.textWidth / 2;
	}
	
	public function AlignTo(Y:Float):Void
	{
		_Y = Y - _Text.textHeight / 2;
	}
	
	public function LeftAlignAt(X:Float):Void
	{
		_X = X - _Text.textWidth;
	}
	
	
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			if (_Parent != null)
			{
				_Parent.removeChild(_Text);
				if (_HasDropShadow)
				{
					_Parent.removeChild(_DropShadow);
				}
			}
			_Text = null;
			_Parent = null;
			_DropShadow = null;
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		RueTextFieldNext = RueTextFieldHead;
		RueTextFieldHead = RueTextFieldSelf;
	}
	
	/* INTERFACE engine.templates.IScreenGraphic */
	
	public function DrawFrom(ParentX:Float, ParentY:Float, RenderTarget:DrawStack, CameraBound:Bool):Void 
	{
		if (_Parent == null)
		{
			_Parent = RenderTarget.Target;
				if (_HasDropShadow)
			{
				_Parent.addChild(_DropShadow);
			}
			_Parent.addChild(_Text);
		
		}
		else
		if (RenderTarget.Target != _Parent)
		{
			if (_HasDropShadow)
			{
				RenderTarget.Target.addChild(_DropShadow);
			}
			_Parent.removeChild(_Text);
			RenderTarget.Target.addChild(_Text);
			_Parent = RenderTarget.Target;
			
		}
	
		
		//textfields are always camera bound
		_Text.x = ParentX + _X;
		_Text.y = ParentY + _Y;
		if (_HasDropShadow)
		{
			if (_Text.text != _DropShadow.text)
			{
				var Text:String = _Text.text;
				_Text.text = "";
				ChangeTextTo(Text);
			}
			_DropShadow.x = ParentX + _X + 2;
			_DropShadow.y = ParentY + _Y + 2;
		}
		
		_Text.width = _Text.textWidth*2;
		_Text.height = _Text.textHeight*2;
	}
	
	public function SetRotation(Rot:Float):Void 
	{
		_Text.rotation = Rot;
	}
	
	public function SetAlpha(Alpha:Float):Void 
	{
		_Text.alpha = Alpha;
		if (_HasDropShadow)
		{
			_DropShadow.alpha = Alpha;
		}
	}
		
	
}