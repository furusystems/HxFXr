package com.furusystems.hxfxr;
/**
 * SfxrParams
 * 
 * Copyright 2010 Thomas Vian
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * @author Thomas Vian
 */
class SfxrParams
{
	
	public function new() { };
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/** If the parameters have been changed since last time (shouldn't used cached sound) */
	public var paramsDirty:Bool;	
	
	var _waveType			:Int = 	0;		// Shape of the wave (0:square, 1:saw, 2:sin or 3:noise)
	
	var _masterVolume		:Float = 	0.5;	// Overall volume of the sound (0 to 1)
	
	var _attackTime			:Float =	0.0;	// Length of the volume envelope attack (0 to 1)
	var _sustainTime		:Float = 	0.0;	// Length of the volume envelope sustain (0 to 1)
	var _sustainPunch		:Float = 	0.0;	// Tilts the sustain envelope for more 'pop' (0 to 1)
	var _decayTime			:Float = 	0.0;	// Length of the volume envelope decay (yes, I know it's called release) (0 to 1)
	
	var _startFrequency		:Float = 	0.0;	// Base note of the sound (0 to 1)
	var _minFrequency		:Float = 	0.0;	// If sliding, the sound will stop at this frequency, to prevent really low notes (0 to 1)
	
	var _slide				:Float = 	0.0;	// Slides the note up or down (-1 to 1)
	var _deltaSlide			:Float = 	0.0;	// Accelerates the slide (-1 to 1)
	
	var _vibratoDepth		:Float = 	0.0;	// Strength of the vibrato effect (0 to 1)
	var _vibratoSpeed		:Float = 	0.0;	// Speed of the vibrato effect (i.e. frequency) (0 to 1)
	
	var _changeAmount		:Float = 	0.0;	// Shift in note, either up or down (-1 to 1)
	var _changeSpeed		:Float = 	0.0;	// How fast the note shift happens (only happens once) (0 to 1)
	
	var _squareDuty			:Float = 	0.0;	// Controls the ratio between the up and down states of the square wave, changing the tibre (0 to 1)
	var _dutySweep			:Float = 	0.0;	// Sweeps the duty up or down (-1 to 1)
	
	var _repeatSpeed		:Float = 	0.0;	// Speed of the note repeating - certain variables are reset each time (0 to 1)
	
	var _phaserOffset		:Float = 	0.0;	// Offsets a second copy of the wave by a small phase, changing the tibre (-1 to 1)
	var _phaserSweep		:Float = 	0.0;	// Sweeps the phase up or down (-1 to 1)
	
	var _lpFilterCutoff		:Float = 	0.0;	// Frequency at which the low-pass filter starts attenuating higher frequencies (0 to 1)
	var _lpFilterCutoffSweep:Float = 	0.0;	// Sweeps the low-pass cutoff up or down (-1 to 1)
	var _lpFilterResonance	:Float = 	0.0;	// Changes the attenuation rate for the low-pass filter, changing the timbre (0 to 1)
	
	var _hpFilterCutoff		:Float = 	0.0;	// Frequency at which the high-pass filter starts attenuating lower frequencies (0 to 1)
	var _hpFilterCutoffSweep:Float = 	0.0;	// Sweeps the high-pass cutoff up or down (-1 to 1)
	
	//--------------------------------------------------------------------------
	//
	//  Getters / Setters
	//
	//--------------------------------------------------------------------------
	
	/** Shape of the wave (0:square, 1:saw, 2:sin or 3:noise) */
	public var waveType(get, set):Int;
	function get_waveType():Int { return _waveType; }
	function set_waveType(value:Int):Int { _waveType = value > 3 ? 0 : value; paramsDirty = true; return _waveType; }
	
	/** Overall volume of the sound (0 to 1) */
	public var masterVolume(get, set):Float;
	function get_masterVolume():Float { return _masterVolume; }
	function set_masterVolume(value:Float):Float { _masterVolume = clamp1(value); paramsDirty = true; return _masterVolume; }
	
	/** Length of the volume envelope attack (0 to 1) */
	public var attackTime(get, set):Float;
	function get_attackTime():Float { return _attackTime; }
	function set_attackTime(value:Float):Float { _attackTime = clamp1(value); paramsDirty = true; return _attackTime; }
	
	/** Length of the volume envelope sustain (0 to 1) */
	public var sustainTime(get, set):Float;
	function get_sustainTime():Float { return _sustainTime; }
	function set_sustainTime(value:Float):Float { _sustainTime = clamp1(value); paramsDirty = true; return _sustainTime; }
	
	/** Tilts the sustain envelope for more 'pop' (0 to 1) */
	public var sustainPunch(get, set):Float;
	function get_sustainPunch():Float { return _sustainPunch; }
	function set_sustainPunch(value:Float):Float { _sustainPunch = clamp1(value); paramsDirty = true; return _sustainPunch; }
	
	/** Length of the volume envelope decay (yes, I know it's called release) (0 to 1) */
	public var decayTime(get, set):Float;
	function get_decayTime():Float { return _decayTime; }
	function set_decayTime(value:Float):Float { _decayTime = clamp1(value); paramsDirty = true; return _decayTime; }

	/** Base note of the sound (0 to 1) */
	public var startFrequency(get, set):Float;
	function get_startFrequency():Float { return _startFrequency; }
	function set_startFrequency(value:Float):Float { _startFrequency = clamp1(value); paramsDirty = true; return _startFrequency; }
	
	/** If sliding, the sound will stop at this frequency, to prevent really low notes (0 to 1) */
	public var minFrequency(get, set):Float;
	function get_minFrequency():Float { return _minFrequency; }
	function set_minFrequency(value:Float):Float { _minFrequency = clamp1(value); paramsDirty = true; return _minFrequency; }
	
	/** Slides the note up or down (-1 to 1) */
	public var slide(get, set):Float;
	function get_slide():Float { return _slide; }
	function set_slide(value:Float):Float { _slide = clamp2(value); paramsDirty = true; return _slide; }
	
	/** Accelerates the slide (-1 to 1) */
	public var deltaSlide(get, set):Float;
	function get_deltaSlide():Float { return _deltaSlide; }
	function set_deltaSlide(value:Float):Float { _deltaSlide = clamp2(value); paramsDirty = true; return _deltaSlide; }
	
	/** Strength of the vibrato effect (0 to 1) */
	public var vibratoDepth(get, set):Float;
	function get_vibratoDepth():Float { return _vibratoDepth; }
	function set_vibratoDepth(value:Float):Float { _vibratoDepth = clamp1(value); paramsDirty = true; return _vibratoDepth; }
	
	/** Speed of the vibrato effect (i.e. frequency) (0 to 1) */
	public var vibratoSpeed(get, set):Float;
	function get_vibratoSpeed():Float { return _vibratoSpeed; }
	function set_vibratoSpeed(value:Float):Float { _vibratoSpeed = clamp1(value); paramsDirty = true; return _vibratoSpeed; }
	
	/** Shift in note, either up or down (-1 to 1) */
	public var changeAmount(get, set):Float;
	function get_changeAmount():Float { return _changeAmount; }
	function set_changeAmount(value:Float):Float { _changeAmount = clamp2(value); paramsDirty = true; return _changeAmount; }
	
	/** How fast the note shift happens (only happens once) (0 to 1) */
	public var changeSpeed(get, set):Float;
	function get_changeSpeed():Float { return _changeSpeed; }
	function set_changeSpeed(value:Float):Float { _changeSpeed = clamp1(value); paramsDirty = true; return _changeSpeed; }
	
	/** Controls the ratio between the up and down states of the square wave, changing the tibre (0 to 1) */
	public var squareDuty(get, set):Float;
	function get_squareDuty():Float { return _squareDuty; }
	function set_squareDuty(value:Float):Float { _squareDuty = clamp1(value); paramsDirty = true; return _squareDuty; }
	
	/** Sweeps the duty up or down (-1 to 1) */
	public var dutySweep(get, set):Float;
	function get_dutySweep():Float { return _dutySweep; }
	function set_dutySweep(value:Float):Float { _dutySweep = clamp2(value); paramsDirty = true; return _dutySweep; }
	
	/** Speed of the note repeating - certain variables are reset each time (0 to 1) */
	public var repeatSpeed(get, set):Float;
	function get_repeatSpeed():Float { return _repeatSpeed; }
	function set_repeatSpeed(value:Float):Float { _repeatSpeed = clamp1(value); paramsDirty = true; return _repeatSpeed; }
	
	/** Offsets a second copy of the wave by a small phase, changing the tibre (-1 to 1) */
	public var phaserOffset(get, set):Float;
	function get_phaserOffset():Float { return _phaserOffset; }
	function set_phaserOffset(value:Float):Float { _phaserOffset = clamp2(value); paramsDirty = true; return _phaserOffset; }
	
	/** Sweeps the phase up or down (-1 to 1) */
	public var phaserSweep(get, set):Float;
	function get_phaserSweep():Float { return _phaserSweep; }
	function set_phaserSweep(value:Float):Float { _phaserSweep = clamp2(value); paramsDirty = true; return _phaserSweep; }
	
	/** Frequency at which the low-pass filter starts attenuating higher frequencies (0 to 1) */
	public var lpFilterCutoff(get, set):Float;
	function get_lpFilterCutoff():Float { return _lpFilterCutoff; }
	function set_lpFilterCutoff(value:Float):Float { _lpFilterCutoff = clamp1(value); paramsDirty = true; return _lpFilterCutoff; }
	
	/** Sweeps the low-pass cutoff up or down (-1 to 1) */
	public var lpFilterCutoffSweep(get, set):Float;
	function get_lpFilterCutoffSweep():Float { return _lpFilterCutoffSweep; }
	function set_lpFilterCutoffSweep(value:Float):Float { _lpFilterCutoffSweep = clamp2(value); paramsDirty = true; return _lpFilterCutoffSweep; }
	
	/** Changes the attenuation rate for the low-pass filter, changing the timbre (0 to 1) */
	public var lpFilterResonance(get, set):Float;
	function get_lpFilterResonance():Float { return _lpFilterResonance; }
	function set_lpFilterResonance(value:Float):Float { _lpFilterResonance = clamp1(value); paramsDirty = true; return _lpFilterResonance; }
	
	/** Frequency at which the high-pass filter starts attenuating lower frequencies (0 to 1) */
	public var hpFilterCutoff(get, set):Float;
	function get_hpFilterCutoff():Float { return _hpFilterCutoff; }
	function set_hpFilterCutoff(value:Float):Float { _hpFilterCutoff = clamp1(value); paramsDirty = true; return _hpFilterCutoff; }
	
	/** Sweeps the high-pass cutoff up or down (-1 to 1) */
	public var hpFilterCutoffSweep(get, set):Float;
	function get_hpFilterCutoffSweep():Float { return _hpFilterCutoffSweep; }
	function set_hpFilterCutoffSweep(value:Float):Float { _hpFilterCutoffSweep = clamp2(value); paramsDirty = true; return _hpFilterCutoffSweep; }
	
	//--------------------------------------------------------------------------
	//
	//  Generator Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Sets the parameters to generate a pickup/coin sound
	 */
	public function generatePickupCoin():Void
	{
		resetParams();
		
		_startFrequency = 0.4 + Math.random() * 0.5;
		
		_sustainTime = Math.random() * 0.1;
		_decayTime = 0.1 + Math.random() * 0.4;
		_sustainPunch = 0.3 + Math.random() * 0.3;
		
		if(Math.random() < 0.5) 
		{
			_changeSpeed = 0.5 + Math.random() * 0.2;
			_changeAmount = 0.2 + Math.random() * 0.4;
		}
	}
	
	/**
	 * Sets the parameters to generate a laser/shoot sound
	 */
	public function generateLaserShoot():Void
	{
		resetParams();
		
		_waveType = Std.int(Math.random() * 3);
		if(_waveType == 2 && Math.random() < 0.5) _waveType = Std.int(Math.random() * 2);
		
		_startFrequency = 0.5 + Math.random() * 0.5;
		_minFrequency = _startFrequency - 0.2 - Math.random() * 0.6;
		if(_minFrequency < 0.2) _minFrequency = 0.2;
		
		_slide = -0.15 - Math.random() * 0.2;
		
		if(Math.random() < 0.33)
		{
			_startFrequency = 0.3 + Math.random() * 0.6;
			_minFrequency = Math.random() * 0.1;
			_slide = -0.35 - Math.random() * 0.3;
		}
		
		if(Math.random() < 0.5) 
		{
			_squareDuty = Math.random() * 0.5;
			_dutySweep = Math.random() * 0.2;
		}
		else
		{
			_squareDuty = 0.4 + Math.random() * 0.5;
			_dutySweep =- Math.random() * 0.7;	
		}
		
		_sustainTime = 0.1 + Math.random() * 0.2;
		_decayTime = Math.random() * 0.4;
		if(Math.random() < 0.5) _sustainPunch = Math.random() * 0.3;
		
		if(Math.random() < 0.33)
		{
			_phaserOffset = Math.random() * 0.2;
			_phaserSweep = -Math.random() * 0.2;
		}
		
		if(Math.random() < 0.5) _hpFilterCutoff = Math.random() * 0.3;
	}
	
	/**
	 * Sets the parameters to generate an explosion sound
	 */
	public function generateExplosion():Void
	{
		resetParams();
		_waveType = 3;
		
		if(Math.random() < 0.5)
		{
			_startFrequency = 0.1 + Math.random() * 0.4;
			_slide = -0.1 + Math.random() * 0.4;
		}
		else
		{
			_startFrequency = 0.2 + Math.random() * 0.7;
			_slide = -0.2 - Math.random() * 0.2;
		}
		
		_startFrequency *= _startFrequency;
		
		if(Math.random() < 0.2) _slide = 0.0;
		if(Math.random() < 0.33) _repeatSpeed = 0.3 + Math.random() * 0.5;
		
		_sustainTime = 0.1 + Math.random() * 0.3;
		_decayTime = Math.random() * 0.5;
		_sustainPunch = 0.2 + Math.random() * 0.6;
		
		if(Math.random() < 0.5)
		{
			_phaserOffset = -0.3 + Math.random() * 0.9;
			_phaserSweep = -Math.random() * 0.3;
		}
		
		if(Math.random() < 0.33)
		{
			_changeSpeed = 0.6 + Math.random() * 0.3;
			_changeAmount = 0.8 - Math.random() * 1.6;
		}
	}
	
	/**
	 * Sets the parameters to generate a powerup sound
	 */
	public function generatePowerup():Void
	{
		resetParams();
		
		if(Math.random() < 0.5) _waveType = 1;
		else 					_squareDuty = Math.random() * 0.6;
		
		if(Math.random() < 0.5)
		{
			_startFrequency = 0.2 + Math.random() * 0.3;
			_slide = 0.1 + Math.random() * 0.4;
			_repeatSpeed = 0.4 + Math.random() * 0.4;
		}
		else
		{
			_startFrequency = 0.2 + Math.random() * 0.3;
			_slide = 0.05 + Math.random() * 0.2;
			
			if(Math.random() < 0.5)
			{
				_vibratoDepth = Math.random() * 0.7;
				_vibratoSpeed = Math.random() * 0.6;
			}
		}
		
		_sustainTime = Math.random() * 0.4;
		_decayTime = 0.1 + Math.random() * 0.4;
	}
	
	/**
	 * Sets the parameters to generate a hit/hurt sound
	 */
	public function generateHitHurt():Void
	{
		resetParams();
		
		_waveType = Std.int(Math.random() * 3);
		if(_waveType == 2) _waveType = 3;
		else if(_waveType == 0) _squareDuty = Math.random() * 0.6;
		
		_startFrequency = 0.2 + Math.random() * 0.6;
		_slide = -0.3 - Math.random() * 0.4;
		
		_sustainTime = Math.random() * 0.1;
		_decayTime = 0.1 + Math.random() * 0.2;
		
		if(Math.random() < 0.5) _hpFilterCutoff = Math.random() * 0.3;
	}
	
	/**
	 * Sets the parameters to generate a jump sound
	 */
	public function generateJump():Void
	{
		resetParams();
		
		_waveType = 0;
		_squareDuty = Math.random() * 0.6;
		_startFrequency = 0.3 + Math.random() * 0.3;
		_slide = 0.1 + Math.random() * 0.2;
		
		_sustainTime = 0.1 + Math.random() * 0.3;
		_decayTime = 0.1 + Math.random() * 0.2;
		
		if(Math.random() < 0.5) _hpFilterCutoff = Math.random() * 0.3;
		if(Math.random() < 0.5) _lpFilterCutoff = 1.0 - Math.random() * 0.6;
	}
	
	/**
	 * Sets the parameters to generate a blip/select sound
	 */
	public function generateBlipSelect():Void
	{
		resetParams();
		
		_waveType = Std.int(Math.random() * 2);
		if(_waveType == 0) _squareDuty = Math.random() * 0.6;
		
		_startFrequency = 0.2 + Math.random() * 0.4;
		
		_sustainTime = 0.1 + Math.random() * 0.1;
		_decayTime = Math.random() * 0.2;
		_hpFilterCutoff = 0.1;
	}
	
	/**
	 * Resets the parameters, used at the start of each generate function
	 */
	function resetParams():Void
	{
		paramsDirty = true;
		
		_waveType = 0;
		_startFrequency = 0.3;
		_minFrequency = 0.0;
		_slide = 0.0;
		_deltaSlide = 0.0;
		_squareDuty = 0.0;
		_dutySweep = 0.0;
		
		_vibratoDepth = 0.0;
		_vibratoSpeed = 0.0;
		
		_attackTime = 0.0;
		_sustainTime = 0.3;
		_decayTime = 0.4;
		_sustainPunch = 0.0;
		
		_lpFilterResonance = 0.0;
		_lpFilterCutoff = 1.0;
		_lpFilterCutoffSweep = 0.0;
		_hpFilterCutoff = 0.0;
		_hpFilterCutoffSweep = 0.0;
		
		_phaserOffset = 0.0;
		_phaserSweep = 0.0;
		
		_repeatSpeed = 0.0;
		
		_changeSpeed = 0.0;
		_changeAmount = 0.0;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Randomize Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Randomly adjusts the parameters ever so slightly
	 */
	public function mutate(mutation:Float = 0.05):Void
	{
		if (Math.random() < 0.5) startFrequency += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) minFrequency += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) slide += 				Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) deltaSlide += 			Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) squareDuty += 			Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) dutySweep += 			Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) vibratoDepth += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) vibratoSpeed += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) attackTime += 			Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) sustainTime += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) decayTime += 			Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) sustainPunch += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) lpFilterCutoff += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) lpFilterCutoffSweep += Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) lpFilterResonance += 	Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) hpFilterCutoff += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) hpFilterCutoffSweep += Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) phaserOffset += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) phaserSweep += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) repeatSpeed += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) changeSpeed += 		Math.random() * mutation*2 - mutation;
		if (Math.random() < 0.5) changeAmount += 		Math.random() * mutation*2 - mutation;
	}
	
	/**
	 * Sets all parameters to random values
	 */
	public function randomize():Void
	{
		paramsDirty = true;
		
		_waveType = Std.int(Math.random() * 4);
		
		_attackTime =  		pow(Math.random()*2-1, 4);
		_sustainTime =  	pow(Math.random()*2-1, 2);
		_sustainPunch =  	pow(Math.random()*0.8, 2);
		_decayTime =  		Math.random();

		_startFrequency =  	(Math.random() < 0.5) ? pow(Math.random()*2-1, 2) : (pow(Math.random() * 0.5, 3) + 0.5);
		_minFrequency =  	0.0;
		
		_slide =  			pow(Math.random()*2-1, 5);
		_deltaSlide =  		pow(Math.random()*2-1, 3);
		
		_vibratoDepth =  	pow(Math.random()*2-1, 3);
		_vibratoSpeed =  	Math.random()*2-1;
		
		_changeAmount =  	Math.random()*2-1;
		_changeSpeed =  	Math.random()*2-1;
		
		_squareDuty =  		Math.random()*2-1;
		_dutySweep =  		pow(Math.random()*2-1, 3);
		
		_repeatSpeed =  	Math.random()*2-1;
		
		_phaserOffset =  	pow(Math.random()*2-1, 3);
		_phaserSweep =  	pow(Math.random()*2-1, 3);
		
		_lpFilterCutoff =  		1 - pow(Math.random(), 3);
		_lpFilterCutoffSweep = 	pow(Math.random()*2-1, 3);
		_lpFilterResonance =  	Math.random()*2-1;
		
		_hpFilterCutoff =  		pow(Math.random(), 5);
		_hpFilterCutoffSweep = 	pow(Math.random()*2-1, 5);
		
		if(_attackTime + _sustainTime + _decayTime < 0.2)
		{
			_sustainTime = 0.2 + Math.random() * 0.3;
			_decayTime = 0.2 + Math.random() * 0.3;
		}
		
		if((_startFrequency > 0.7 && _slide > 0.2) || (_startFrequency < 0.2 && _slide < -0.05)) 
		{
			_slide = -_slide;
		}
		
		if(_lpFilterCutoff < 0.1 && _lpFilterCutoffSweep < -0.05) 
		{
			_lpFilterCutoffSweep = -_lpFilterCutoffSweep;
		}
	}
	
	//--------------------------------------------------------------------------
	//	
	//  Settings String Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a string representation of the parameters for copy/paste sharing
	 * @return	A comma-delimited list of parameter values
	 */
	function getSettingsString():String
	{
		var string:String = ""+waveType;
		string += "," + to4DP(_attackTime) + 			"," + to4DP(_sustainTime) 
				+ "," + to4DP(_sustainPunch) + 			"," + to4DP(_decayTime) 
				+ "," + to4DP(_startFrequency) + 		"," + to4DP(_minFrequency)
				+ "," + to4DP(_slide) + 				"," + to4DP(_deltaSlide)
				+ "," + to4DP(_vibratoDepth) + 			"," + to4DP(_vibratoSpeed)
				+ "," + to4DP(_changeAmount) + 			"," + to4DP(_changeSpeed)
				+ "," + to4DP(_squareDuty) + 			"," + to4DP(_dutySweep)
				+ "," + to4DP(_repeatSpeed) + 			"," + to4DP(_phaserOffset)
				+ "," + to4DP(_phaserSweep) + 			"," + to4DP(_lpFilterCutoff)
				+ "," + to4DP(_lpFilterCutoffSweep) + 	"," + to4DP(_lpFilterResonance)
				+ "," + to4DP(_hpFilterCutoff)+ 		"," + to4DP(_hpFilterCutoffSweep)
				+ "," + to4DP(_masterVolume);		
		
		return string;
	}
	
	/**
	 * Parses a settings string into the parameters
	 * @param	string	Settings string to parse
	 * @return			If the string successfully parsed
	 */
	
	inline function stringToFloat(input:String):Float{
		var val = Std.parseFloat(input);
		return Math.isNaN(val)?0:val;
	}
	inline function stringToInt(input:String):Int {
		var val = Std.parseInt(input);
		return Math.isNaN(val)?0:val;
	}
	public function setSettingsString(string:String):Bool
	{
		var values = string.split(",");
		
		if (values.length != 24) return false;
		
		waveType = 				stringToInt(values[0]);
		attackTime =  			stringToFloat(values[1]);
		sustainTime =  			stringToFloat(values[2]);
		sustainPunch =  		stringToFloat(values[3]);
		decayTime =  			stringToFloat(values[4]);
		startFrequency =  		stringToFloat(values[5]);
		minFrequency =  		stringToFloat(values[6]);
		slide =  				stringToFloat(values[7]);
		deltaSlide =  			stringToFloat(values[8]);
		vibratoDepth =  		stringToFloat(values[9]);
		vibratoSpeed =  		stringToFloat(values[10]);
		changeAmount =  		stringToFloat(values[11]);
		changeSpeed =  			stringToFloat(values[12]);
		squareDuty =  			stringToFloat(values[13]);
		dutySweep =  			stringToFloat(values[14]);
		repeatSpeed =  			stringToFloat(values[15]);
		phaserOffset =  		stringToFloat(values[16]);
		phaserSweep =  			stringToFloat(values[17]);
		lpFilterCutoff =  		stringToFloat(values[18]);
		lpFilterCutoffSweep =  	stringToFloat(values[19]);
		lpFilterResonance =  	stringToFloat(values[20]);
		hpFilterCutoff =  		stringToFloat(values[21]);
		hpFilterCutoffSweep =  	stringToFloat(values[22]);
		masterVolume = 			stringToFloat(values[23]);
		
		return true;
	}   
	
	
	//--------------------------------------------------------------------------
	//	
	//  Copying Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a copy of this SfxrParams with all settings duplicated
	 * @return	A copy of this SfxrParams
	 */
	public function clone():SfxrParams
	{
		var out:SfxrParams = new SfxrParams();
		out.copyFrom(this);		
		
		return out;
	}
	
	/**
	 * Copies parameters from another instance
	 * @param	params	Instance to copy parameters from
	 */
	public function copyFrom(params:SfxrParams, makeDirty:Bool = false):Void
	{
		_waveType = 			params.waveType;
		_attackTime =           params.attackTime;
		_sustainTime =          params.sustainTime;
		_sustainPunch =         params.sustainPunch;
		_decayTime =			params.decayTime;
		_startFrequency = 		params.startFrequency;
		_minFrequency = 		params.minFrequency;
		_slide = 				params.slide;
		_deltaSlide = 			params.deltaSlide;
		_vibratoDepth = 		params.vibratoDepth;
		_vibratoSpeed = 		params.vibratoSpeed;
		_changeAmount = 		params.changeAmount;
		_changeSpeed = 			params.changeSpeed;
		_squareDuty = 			params.squareDuty;
		_dutySweep = 			params.dutySweep;
		_repeatSpeed = 			params.repeatSpeed;
		_phaserOffset = 		params.phaserOffset;
		_phaserSweep = 			params.phaserSweep;
		_lpFilterCutoff = 		params.lpFilterCutoff;
		_lpFilterCutoffSweep = 	params.lpFilterCutoffSweep;
		_lpFilterResonance = 	params.lpFilterResonance;
		_hpFilterCutoff = 		params.hpFilterCutoff;
		_hpFilterCutoffSweep = 	params.hpFilterCutoffSweep;
		_masterVolume = 		params.masterVolume;
		
		if (makeDirty) paramsDirty = true;
	}   
	
	
	//--------------------------------------------------------------------------
	//
	//  Util Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Clams a value to betwen 0 and 1
	 * @param	value	Input value
	 * @return			The value clamped between 0 and 1
	 */
	function clamp1(value:Float):Float { return (value > 1.0) ? 1.0 : ((value < 0.0) ? 0.0 : value); }
	
	/**
	 * Clams a value to betwen -1 and 1
	 * @param	value	Input value
	 * @return			The value clamped between -1 and 1
	 */
	function clamp2(value:Float):Float { return (value > 1.0) ? 1.0 : ((value < -1.0) ? -1.0 : value); }
	
	/**
	 * Quick power function
	 * @param	base		Base to raise to power
	 * @param	power		Power to raise base by
	 * @return				The calculated power
	 */
	function pow(base:Float, power:Int):Float
	{
		switch(power)
		{
			case 2: return base*base;
			case 3: return base*base*base;
			case 4: return base*base*base*base;
			case 5: return base*base*base*base*base;
		}
		
		return 1.0;
	}
	
	
	/**
	 * Returns the number as a string to 4 decimal places
	 * @param	value	Float to convert
	 * @return			Float to 4dp as a string
	 */
	function to4DP(value:Float):String
	{
		if (value < 0.0001 && value > -0.0001) return "";
		
		var string:String = ""+value;
		var split = string.split(".");
		if (split.length == 1) 	
		{
			return string;
		}
		else 					
		{
			var out:String = split[0] + "." + split[1].substr(0, 4);
			while (out.substr(out.length - 1, 1) == "0") out = out.substr(0, out.length - 1);
			
			return out;
		}
	}
}