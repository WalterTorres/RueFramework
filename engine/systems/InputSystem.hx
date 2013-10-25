package engine.systems;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;


	
	/**
	 * ...
	 * @author Jakegr
	 */
	
    class InputSystem
	{
		public static var KeyDictionary:Array<Bool>;
		
		public static var BACKSPACE:Int = Keyboard.BACKSPACE;
		public static var TAB:Int = Keyboard.TAB;
		public static var MIDDLE:Int = 12;
		public static var ENTER:Int = Keyboard.ENTER;
		public static var SHIFT:Int = Keyboard.SHIFT;
		public static var CONTROL:Int = Keyboard.CONTROL;
		public static var PAUSE:Int = 19;
		public static var BREAK:Int = 19;
		public static var CAPS_LOCK:Int = Keyboard.CAPS_LOCK;
		public static var ESCAPE:Int = Keyboard.ESCAPE;
		public static var SPACEBAR:Int = Keyboard.SPACE;
		public static var PAGE_UP:Int = Keyboard.PAGE_UP;
		public static var PAGE_DOWN:Int = Keyboard.PAGE_DOWN;
		public static var END:Int = Keyboard.END;
		public static var HOME:Int = Keyboard.HOME;
		public static var LEFT_ARROW:Int = Keyboard.LEFT;
		public static var UP_ARROW:Int = Keyboard.UP;
		public static var RIGHT_ARROW:Int = Keyboard.RIGHT;
		public static var DOWN_ARROW:Int = Keyboard.DOWN;
		public static var INSERT:Int = Keyboard.INSERT;
		public static var DELETE:Int = Keyboard.DELETE;
		public static var NUM_0:Int = 48;
		public static var NUM_1:Int = 49;
		public static var NUM_2:Int = 50;
		public static var NUM_3:Int = 51;
		public static var NUM_4:Int = 52;
		public static var NUM_5:Int = 53;
		public static var NUM_6:Int = 54;
		public static var NUM_7:Int = 55;
		public static var NUM_8:Int = 56;
		public static var NUM_9:Int = 57;
		public static var A:Int = 65;
		public static var B:Int = 66;
		public static var C:Int = 67;
		public static var D:Int = 68;
		public static var E:Int = 69;
		public static var F:Int = 70;
		public static var G:Int = 71;
		public static var H:Int = 72;
		public static var I:Int = 73;
		public static var J:Int = 74;
		public static var K:Int = 75;
		public static var L:Int = 76;
		public static var M:Int = 77;
		public static var N:Int = 78;
		public static var O:Int = 79;
		public static var P:Int = 80;
		public static var Q:Int = 81;
		public static var R:Int = 82;
		public static var S:Int = 83;
		public static var T:Int = 84;
		public static var U:Int = 85;
		public static var V:Int = 86;
		public static var W:Int = 87;
		public static var X:Int = 88;
		public static var Y:Int = 89;
		public static var Z:Int = 90;
		public static var LEFT_WINDOWS:Int = 91;
		public static var RIGHT_WINDOWS:Int = 92;
		public static var MENU:Int = 93;
		public static var NUMPAD_0:Int = Keyboard.NUMPAD_0;
		public static var NUMPAD_1:Int = Keyboard.NUMPAD_1;
		public static var NUMPAD_2:Int = Keyboard.NUMPAD_2;
		public static var NUMPAD_3:Int = Keyboard.NUMPAD_3;
		public static var NUMPAD_4:Int = Keyboard.NUMPAD_4;
		public static var NUMPAD_5:Int = Keyboard.NUMPAD_5;
		public static var NUMPAD_6:Int = Keyboard.NUMPAD_6;
		public static var NUMPAD_7:Int = Keyboard.NUMPAD_7;
		public static var NUMPAD_8:Int = Keyboard.NUMPAD_8;
		public static var NUMPAD_9:Int = Keyboard.NUMPAD_9;
		public static var NUMPAD_MULTIPLY:Int = Keyboard.NUMPAD_MULTIPLY;
		public static var NUMPAD_ADD:Int = Keyboard.NUMPAD_ADD;
		public static var NUMPAD_SUBTRACT:Int = Keyboard.NUMPAD_SUBTRACT;
		public static var NUMPAD_DECIMAL:Int = Keyboard.NUMPAD_DECIMAL;
		public static var NUMPAD_DIVIDE:Int = Keyboard.NUMPAD_DIVIDE;
		public static var F1:Int = Keyboard.F1;
		public static var F2:Int = Keyboard.F2;
		public static var F3:Int = Keyboard.F3;
		public static var F4:Int = Keyboard.F4;
		public static var F5:Int = Keyboard.F5;
		public static var F6:Int = Keyboard.F6;
		public static var F7:Int = Keyboard.F7;
		public static var F8:Int = Keyboard.F8;
		public static var F9:Int = Keyboard.F9;
		public static var F10:Int = Keyboard.F10;
		public static var F11:Int = Keyboard.F11;
		public static var F12:Int = Keyboard.F12;
		public static var F13:Int = Keyboard.F13;
		public static var F14:Int = Keyboard.F14;
		public static var F15:Int = Keyboard.F15;
		public static var NUM_LOCK:Int = 144;
		public static var SCROLL_LOCK:Int = 145;
		public static var SEMICOLON:Int = 186;
		public static var COLON:Int = 186;
		public static var EQUALS:Int = 187;
		public static var PLUS:Int = 187;
		public static var COMMA:Int = 188;
		public static var LEFT_ANGLE:Int = 188;
		public static var MINUS:Int = 189;
		public static var UNDERSCORE:Int = 189;
		public static var PERIOD:Int = 190;
		public static var RIGHT_ANGLE:Int = 190;
		public static var FORWARD_SLASH:Int = 191;
		public static var QUESTION_MARK:Int = 191;
		public static var BACKQUOTE:Int = 192;
		public static var TILDE:Int = 192;
		public static var LEFT_BRACKET:Int = 219;
		public static var BACKSLASH:Int = 220;
		public static var BAR:Int = 220;
		public static var RIGHT_BRACKET:Int = 221;
		public static var QUOTE:Int = 222;
		
		public static function Init(stage:Main):Void
		{
			KeyDictionary = new Array<Bool>();
			stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private static function onKeyDown(e:KeyboardEvent):Void
		{
			if (e.keyCode < 222)
			{
				KeyDictionary[e.keyCode] = true;
			}
		}
		
		private static function onKeyUp(e:KeyboardEvent):Void
		{
			if (e.keyCode < 222)
			{
				KeyDictionary[e.keyCode] = false;
			}
		}
		
		public static function CheckKeyPress(keycode:Int):Bool
		{
			return KeyDictionary[keycode];
		}
		

	
	}

