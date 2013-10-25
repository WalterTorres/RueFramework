package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end


class RueFramework {
	
	
	public static function sampleMethod (inputValue:Int):Int {
		
		return rueframework_sample_method(inputValue);
		
	}
	
	
	private static var rueframework_sample_method = Lib.load ("rueframework", "rueframework_sample_method", 1);
	
	
}