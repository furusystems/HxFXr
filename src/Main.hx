package ;

import com.furusystems.hxfxr.SfxrParams;
import com.furusystems.hxfxr.SfxrSynth;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Andreas Rønning
 */

class Main 
{
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		var synth:SfxrSynth = new SfxrSynth();
		synth.params.setSettingsString("0,,0.271,,0.18,0.395,,0.201,,,,,,0.284,,,,,0.511,,,,,0.5");
		synth.play();
	}
	
}