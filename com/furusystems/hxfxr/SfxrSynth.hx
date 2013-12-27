package com.furusystems.hxfxr;
import flash.display.Shape;
import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.Lib;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.Vector;
/**
 * SfxrSynth
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
 * @author Tomas Pettersson
 * @author Andreas Rønning
 */
class SfxrSynth
{
	
	//--------------------------------------------------------------------------
	//
	//  Sound Parameters
	//
	//--------------------------------------------------------------------------
	
	var _params:SfxrParams;	// Params instance
	
	var _sound:Sound;							// Sound instance used to play the sound
	var _channel:SoundChannel;					// SoundChannel instance of playing Sound
	
	var _mutation:Bool;							// If the current sound playing or caching is a mutation
	
	var _cachedWave:ByteArray;					// Cached wave data from a cacheSound() call
	var _cachingNormal:Bool;					// If the synth is caching a normal sound
	
	var _cachingMutation:Int;					// Current caching ID
	var _cachedMutation:ByteArray;				// Current caching wave data for mutation
	var _cachedMutations:Vector<ByteArray>;		// Cached mutated wave data
	var _cachedMutationsNum:Int;				// Float of cached mutations
	var _cachedMutationAmount:Float;			// Amount to mutate during cache
	
	var _cachingAsync:Bool;						// If the synth is currently caching asynchronously
	var _cacheTimePerFrame:Int;					// Maximum time allowed per frame to cache sound asynchronously
	var _cachedCallback:Void->Void;				// Function to call when finished caching asynchronously
	var _cacheTicker:Shape;						// Shape used for enterFrame event
	
	var _waveData:ByteArray;					// Full wave, read out in chuncks by the onSampleData method
	var _waveDataPos:Int;						// Current position in the waveData
	var _waveDataLength:Int;					// Float of bytes in the waveData
	var _waveDataBytes:Int;						// Float of bytes to write to the soundcard
	
	var _original:SfxrParams;					// Copied properties for mutation base
	
	//--------------------------------------------------------------------------
	//
	//  Synth Variables
	//
	//--------------------------------------------------------------------------
	
	var _finished:Bool;						// If the sound has finished
	
	var _masterVolume:Float;					// masterVolume * masterVolume (for quick calculations)
	
	var _waveType:Int;							// The type of wave to generate
	
	var _envelopeVolume:Float;					// Current volume of the envelope
	var _envelopeStage:Int;						// Current stage of the envelope (attack, sustain, decay, end)
	var _envelopeTime:Float;					// Current time through current enelope stage
	var _envelopeLength:Float;					// Length of the current envelope stage
	var _envelopeLength0:Float;				// Length of the attack stage
	var _envelopeLength1:Float;				// Length of the sustain stage
	var _envelopeLength2:Float;				// Length of the decay stage
	var _envelopeOverLength0:Float;			// 1 / _envelopeLength0 (for quick calculations)
	var _envelopeOverLength1:Float;			// 1 / _envelopeLength1 (for quick calculations)
	var _envelopeOverLength2:Float;			// 1 / _envelopeLength2 (for quick calculations)
	var _envelopeFullLength:Float;				// Full length of the volume envelop (and therefore sound)
	
	var _sustainPunch:Float;					// The punch factor (louder at begining of sustain)
	
	var _phase:Int;								// Phase through the wave
	var _pos:Float;							// Phase expresed as a Float from 0-1, used for fast sin approx
	var _period:Float;							// Period of the wave
	var _periodTemp:Float;						// Period modified by vibrato
	var _maxPeriod:Float;						// Maximum period before sound stops (from minFrequency)
	
	var _slide:Float;							// Note slide
	var _deltaSlide:Float;						// Change in slide
	var _minFreqency:Float;					// Minimum frequency before stopping
	
	var _vibratoPhase:Float;					// Phase through the vibrato sine wave
	var _vibratoSpeed:Float;					// Speed at which the vibrato phase moves
	var _vibratoAmplitude:Float;				// Amount to change the period of the wave by at the peak of the vibrato wave
	
	var _changeAmount:Float;					// Amount to change the note by
	var _changeTime:Int;						// Counter for the note change
	var _changeLimit:Int;						// Once the time reaches this limit, the note changes
	
	var _squareDuty:Float;						// Offset of center switching point in the square wave
	var _dutySweep:Float;						// Amount to change the duty by
	
	var _repeatTime:Int;						// Counter for the repeats
	var _repeatLimit:Int;						// Once the time reaches this limit, some of the variables are reset
	
	var _phaser:Bool;						// If the phaser is active
	var _phaserOffset:Float;					// Phase offset for phaser effect
	var _phaserDeltaOffset:Float;				// Change in phase offset
	var _phaserInt:Int;							// Integer phaser offset, for bit maths
	var _phaserPos:Int;							// Position through the phaser buffer
	var _phaserBuffer:Vector<Float>;			// Buffer of wave values used to create the out of phase second wave
	
	var _filters:Bool;						// If the filters are active
	var _lpFilterPos:Float;					// Adjusted wave position after low-pass filter
	var _lpFilterOldPos:Float;					// Previous low-pass wave position
	var _lpFilterDeltaPos:Float;				// Change in low-pass wave position, as allowed by the cutoff and damping
	var _lpFilterCutoff:Float;					// Cutoff multiplier which adjusts the amount the wave position can move
	var _lpFilterDeltaCutoff:Float;			// Speed of the low-pass cutoff multiplier
	var _lpFilterDamping:Float;				// Damping muliplier which restricts how fast the wave position can move
	var _lpFilterOn:Bool;					// If the low pass filter is active
	
	var _hpFilterPos:Float;					// Adjusted wave position after high-pass filter
	var _hpFilterCutoff:Float;					// Cutoff multiplier which adjusts the amount the wave position can move
	var _hpFilterDeltaCutoff:Float;			// Speed of the high-pass cutoff multiplier
	
	var _noiseBuffer:Vector<Float>;			// Buffer of random values used to generate noise
	
	var _superSample:Float;					// Actual sample writen to the wave
	var _sample:Float;							// Sub-sample calculated 8 times per actual sample, averaged out to get the super sample
	var _sampleCount:Int;						// Float of samples added to the buffer sample
	var _bufferSample:Float;					// Another supersample used to create a 22050Hz wave
	
	
	public function new() {
		_params = new SfxrParams();
	}
	
	//--------------------------------------------------------------------------
	//	
	//  Getters / Setters
	//
	//--------------------------------------------------------------------------
	
	/** The sound parameters */
	public var params(get, set):SfxrParams;
	function get_params():SfxrParams { return _params; }
	function set_params(value:SfxrParams):SfxrParams
	{
		_params = value;
		_params.paramsDirty = true;
		return _params;
	}
	
	//--------------------------------------------------------------------------
	//	
	//  Sound Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Plays the sound. If the parameters are dirty, synthesises sound as it plays, caching it for later. 
	 * If they're not, plays from the cached sound. 
	 * Won't play if caching asynchronously. 
	 */
	public function play():Void
	{
		
		if (_cachingAsync) return;
		
		stop();
		
		_mutation = false;
		
		if (_params.paramsDirty || _cachingNormal || _cachedWave==null) 
		{
			// Needs to cache new data
			_cachedWave = new ByteArray();
			_cachingNormal = true;
			_waveData = null;
			
			reset(true);
		}
		else
		{
			// Play from cached data
			_waveData = _cachedWave;
			_waveData.position = 0;
			_waveDataLength = _waveData.length;
			_waveDataBytes = 24576;
			_waveDataPos = 0; 
		}
		
		if (_sound==null) (_sound = new Sound()).addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
		
		_channel = _sound.play();
	}
	
	/**
	 * Plays a mutation of the sound.  If the parameters are dirty, synthesises sound as it plays, caching it for later. 
	 * If they're not, plays from the cached sound. 
	 * Won't play if caching asynchronously. 
	 * @param	mutationAmount	Amount of mutation
	 * @param	mutationsNum	The number of mutations to cache before picking from them
	 */
	public function playMutated(mutationAmount:Float = 0.05, mutationsNum:Int = 15):Void
	{
		stop();
		
		if (_cachingAsync) return;
		
		_mutation = true;
		
		_cachedMutationsNum = mutationsNum;
		
		if (_params.paramsDirty || _cachedMutations==null) 
		{
			// New set of mutations
			_cachedMutations = new Vector<ByteArray>();
			_cachingMutation = 0;
		}
		
		if (_cachingMutation != -1)
		{
			// Continuing caching new mutations
			_cachedMutation = new ByteArray();
			_cachedMutations[_cachingMutation] = _cachedMutation;
			_waveData = null;
			
			_original = _params.clone();
			_params.mutate(mutationAmount);
			reset(true);
		}
		else
		{
			// Play from random cached mutation
			_waveData = _cachedMutations[Std.int(_cachedMutations.length * Math.random())];
			_waveData.position = 0;
			_waveDataLength = _waveData.length;
			_waveDataBytes = 24576;
			_waveDataPos = 0;
		}
		
		if (_sound==null) (_sound = new Sound()).addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
		
		_channel = _sound.play();
	}
	
	/**
	 * Stops the currently playing sound
	 */
	public function stop():Void
	{
		if(_channel!=null) 
		{
			_channel.stop();
			_channel = null;
		}
		
		if(_original!=null)
		{
			_params.copyFrom(_original);
			_original = null;
		}
	}
	
	/**
	 * If there is a cached sound to play, reads out of the data. 
	 * If there isn't, synthesises new chunch of data, caching it as it goes. 
	 * @param	e	SampleDataEvent to write data to
	 */
	function onSampleData(e:SampleDataEvent):Void
	{
		if(_waveData!=null)
		{
			if(_waveDataPos + _waveDataBytes > _waveDataLength) _waveDataBytes = _waveDataLength - _waveDataPos;
			
			if(_waveDataBytes > 0) e.data.writeBytes(_waveData, _waveDataPos, _waveDataBytes);
			
			_waveDataPos += _waveDataBytes;
		}
		else
		{	
			var length:Int;
			var i:Int, l:Int;
			
			if (_mutation)
			{
				if (_original!=null)
				{
					_waveDataPos = _cachedMutation.position;
					
					if (synthWave(_cachedMutation, 3072, true))
					{
						_params.copyFrom(_original);
						_original = null;
						
						_cachingMutation++;
						
						if ((length = _cachedMutation.length) < 24576)
						{
							// If the sound is smaller than the buffer length, add silence to allow it to play
							_cachedMutation.position = length;
							var l = 24576 - length;
							for (i in 0...l) {
								_cachedMutation.writeFloat(0.0);
							}
						}
						
						if (_cachingMutation >= _cachedMutationsNum)
						{
							_cachingMutation = -1;
						}
					}
					
					_waveDataBytes = _cachedMutation.length - _waveDataPos;
					
					e.data.writeBytes(_cachedMutation, _waveDataPos, _waveDataBytes);
				}
			}
			else
			{
				if (_cachingNormal)
				{
					_waveDataPos = _cachedWave.position;
					
					if (synthWave(_cachedWave, 3072, true))
					{
						if ((length = _cachedWave.length) < 24576)
						{
							// If the sound is smaller than the buffer length, add silence to allow it to play
							_cachedWave.position = length;
							var l = 24576 - length;
							for(i in 0...l) _cachedWave.writeFloat(0.0);
						}
						
						_cachingNormal = false;
					}
					
					_waveDataBytes = _cachedWave.length - _waveDataPos;
					
					e.data.writeBytes(_cachedWave, _waveDataPos, _waveDataBytes);
				}
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//	
	//  Cached Sound Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Cache the sound for speedy playback. 
	 * If a callback is passed in, the caching will be done asynchronously, taking maxTimePerFrame milliseconds 
	 * per frame to cache, them calling the callback when it's done. 
	 * If not, the whole sound is cached imidiately - can freeze the player for a few seconds, especially in debug mode. 
	 * @param	callback			Function to call when the caching is complete
	 * @param	maxTimePerFrame		Maximum time in milliseconds the caching will use per frame
	 */
	public function cacheSound(?callback:Void->Void, maxTimePerFrame:Int = 5):Void
	{
		stop();
		
		if (_cachingAsync) return;
		
		reset(true);
		
		_cachedWave = new ByteArray();
		
		if (callback!=null) 
		{
			_mutation = false;
			_cachingNormal = true;
			_cachingAsync = true;
			_cacheTimePerFrame = maxTimePerFrame;
			
			_cachedCallback = callback;
			
			if (_cacheTicker==null) _cacheTicker = new Shape();
			
			_cacheTicker.addEventListener(Event.ENTER_FRAME, cacheSection);
		}
		else
		{
			_cachingNormal = false;
			_cachingAsync = false;
			
			synthWave(_cachedWave, cast _envelopeFullLength, true);
			
			var length:Int = _cachedWave.length;
			
			if(length < 24576)
			{
				// If the sound is smaller than the buffer length, add silence to allow it to play
				_cachedWave.position = length;
				var l = 24576 - length;
				for(i in 0...l) _cachedWave.writeFloat(0.0);
			}
		}
	}
	
	/**
	 * Caches a series of mutations on the source sound. 
	 * If a callback is passed in, the caching will be done asynchronously, taking maxTimePerFrame milliseconds 
	 * per frame to cache, them calling the callback when it's done. 
	 * If not, the whole sound is cached imidiately - can freeze the player for a few seconds, especially in debug mode. 
	 * @param	mutationsNum		Float of mutations to cache
	 * @param	mutationAmount		Amount of mutation
	 * @param	callback			Function to call when the caching is complete
	 * @param	maxTimePerFrame		Maximum time in milliseconds the caching will use per frame
	 */
	public function cacheMutations(mutationsNum:Int, mutationAmount:Float = 0.05, ?callback:Void->Void, maxTimePerFrame:Int = 5):Void
	{
		stop();
		
		if (_cachingAsync) return;
		
		_cachedMutationsNum = mutationsNum;
		_cachedMutations = new Vector<ByteArray>();
		
		if (callback!=null)
		{
			_mutation = true;
			
			_cachingMutation = 0;
			_cachedMutation = new ByteArray();
			_cachedMutations[0] = _cachedMutation;
			_cachedMutationAmount = mutationAmount;
			
			_original = _params.clone();
			_params.mutate(mutationAmount);
			
			reset(true);
			
			_cachingAsync = true;
			_cacheTimePerFrame = maxTimePerFrame;
			
			_cachedCallback = callback;
			
			if (_cacheTicker==null) _cacheTicker = new Shape();
			
			_cacheTicker.addEventListener(Event.ENTER_FRAME, cacheSection);
		}
		else
		{
			var original:SfxrParams = _params.clone();
			
			for(i in 0..._cachedMutationsNum)
			{
				_params.mutate(mutationAmount);
				cacheSound();
				_cachedMutations[i] = _cachedWave;
				_params.copyFrom(original);
			}
			
			_cachingMutation = -1;
		}
	}
	
	/**
	 * Performs the asynchronous cache, working for up to _cacheTimePerFrame milliseconds per frame
	 * @param	e	enterFrame event
	 */
	function cacheSection(e:Event):Void 
	{
		var cacheStartTime:Int = Lib.getTimer();
		
		while (Lib.getTimer() - cacheStartTime < _cacheTimePerFrame)
		{
			if (_mutation)
			{
				_waveDataPos = _cachedMutation.position;
				
				if (synthWave(_cachedMutation, 500, true))
				{
					_params.copyFrom(_original);
					_params.mutate(_cachedMutationAmount);
					reset(true);
					
					_cachingMutation++;
					_cachedMutation = new ByteArray();
					_cachedMutations[_cachingMutation] = _cachedMutation;
					
					if (_cachingMutation >= _cachedMutationsNum)
					{
						_cachingMutation = -1;
						_cachingAsync = false;
						
						_params.paramsDirty = false;
						
						_cachedCallback();
						_cachedCallback = null;
						_cacheTicker.removeEventListener(Event.ENTER_FRAME, cacheSection);
						
						return;
					}
				}
			}
			else
			{
				_waveDataPos = _cachedWave.position;
				
				if (synthWave(_cachedWave, 500, true))
				{
					_cachingNormal = false;
					_cachingAsync = false;
					
					_cachedCallback();
					_cachedCallback = null;
					_cacheTicker.removeEventListener(Event.ENTER_FRAME, cacheSection);
					
					return;
				}
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//	
	//  Synth Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Resets the runing variables from the params
	 * Used once at the start (total reset) and for the repeat effect (partial reset)
	 * @param	totalReset	If the reset is total
	 */
	function reset(totalReset:Bool):Void
	{
		// Shorter reference
		var p:SfxrParams = _params;
		
		_period = 100.0 / (p.startFrequency * p.startFrequency + 0.001);
		_maxPeriod = 100.0 / (p.minFrequency * p.minFrequency + 0.001);
		
		_slide = 1.0 - p.slide * p.slide * p.slide * 0.01;
		_deltaSlide = -p.deltaSlide * p.deltaSlide * p.deltaSlide * 0.000001;
		
		if (p.waveType == 0)
		{
			_squareDuty = 0.5 - p.squareDuty * 0.5;
			_dutySweep = -p.dutySweep * 0.00005;
		}
		
		if (p.changeAmount > 0.0) 	_changeAmount = 1.0 - p.changeAmount * p.changeAmount * 0.9;
		else 						_changeAmount = 1.0 + p.changeAmount * p.changeAmount * 10.0;
		
		_changeTime = 0;
		
		if(p.changeSpeed == 1.0) 	_changeLimit = 0;
		else 						_changeLimit = Std.int((1.0 - p.changeSpeed) * (1.0 - p.changeSpeed) * 20000 + 32);
		
		if(totalReset)
		{
			p.paramsDirty = false;
			
			_masterVolume = p.masterVolume * p.masterVolume;
			
			_waveType = p.waveType;
			
			if (p.sustainTime < 0.01) p.sustainTime = 0.01;
			
			var totalTime:Float = p.attackTime + p.sustainTime + p.decayTime;
			if (totalTime < 0.18) 
			{
				var multiplier:Float = 0.18 / totalTime;
				p.attackTime *= multiplier;
				p.sustainTime *= multiplier;
				p.decayTime *= multiplier;
			}
			
			_sustainPunch = p.sustainPunch;
			
			_phase = 0;
			
			_minFreqency = p.minFrequency;
			
			_filters = p.lpFilterCutoff != 1.0 || p.hpFilterCutoff != 0.0;
			
			_lpFilterPos = 0.0;
			_lpFilterDeltaPos = 0.0;
			_lpFilterCutoff = p.lpFilterCutoff * p.lpFilterCutoff * p.lpFilterCutoff * 0.1;
			_lpFilterDeltaCutoff = 1.0 + p.lpFilterCutoffSweep * 0.0001;
			_lpFilterDamping = 5.0 / (1.0 + p.lpFilterResonance * p.lpFilterResonance * 20.0) * (0.01 + _lpFilterCutoff);
			if (_lpFilterDamping > 0.8) _lpFilterDamping = 0.8;
			_lpFilterDamping = 1.0 - _lpFilterDamping;
			_lpFilterOn = p.lpFilterCutoff != 1.0;
			
			_hpFilterPos = 0.0;
			_hpFilterCutoff = p.hpFilterCutoff * p.hpFilterCutoff * 0.1;
			_hpFilterDeltaCutoff = 1.0 + p.hpFilterCutoffSweep * 0.0003;
			
			_vibratoPhase = 0.0;
			_vibratoSpeed = p.vibratoSpeed * p.vibratoSpeed * 0.01;
			_vibratoAmplitude = p.vibratoDepth * 0.5;
			
			_envelopeVolume = 0.0;
			_envelopeStage = 0;
			_envelopeTime = 0;
			_envelopeLength0 = p.attackTime * p.attackTime * 100000.0;
			_envelopeLength1 = p.sustainTime * p.sustainTime * 100000.0;
			_envelopeLength2 = p.decayTime * p.decayTime * 100000.0 + 10;
			_envelopeLength = _envelopeLength0;
			_envelopeFullLength = _envelopeLength0 + _envelopeLength1 + _envelopeLength2;
			
			_envelopeOverLength0 = 1.0 / _envelopeLength0;
			_envelopeOverLength1 = 1.0 / _envelopeLength1;
			_envelopeOverLength2 = 1.0 / _envelopeLength2;
			
			_phaser = p.phaserOffset != 0.0 || p.phaserSweep != 0.0;
			
			_phaserOffset = p.phaserOffset * p.phaserOffset * 1020.0;
			if(p.phaserOffset < 0.0) _phaserOffset = -_phaserOffset;
			_phaserDeltaOffset = p.phaserSweep * p.phaserSweep * p.phaserSweep * 0.2;
			_phaserPos = 0;
			
			if(_phaserBuffer == null) _phaserBuffer = new Vector<Float>(1024, true);
			if(_noiseBuffer == null) _noiseBuffer = new Vector<Float>(32, true);
			
			for(i in 0...1024) _phaserBuffer[i] = 0.0;
			for(i in 0...32) _noiseBuffer[i] = Math.random() * 2.0 - 1.0;
			
			_repeatTime = 0;
			
			if (p.repeatSpeed == 0.0) 	_repeatLimit = 0;
			else 						_repeatLimit = Std.int((1.0-p.repeatSpeed) * (1.0-p.repeatSpeed) * 20000) + 32;
		}
	}
	
	/**
	 * Writes the wave to the supplied buffer ByteArray
	 * @param	buffer		A ByteArray to write the wave to
	 * @param	waveData	If the wave should be written for the waveData
	 * @return				If the wave is finished
	 */
	function synthWave(buffer:ByteArray, length:Int, waveData:Bool = false, sampleRate:Int = 44100, bitDepth:Int = 16):Bool
	{
		_finished = false;
		
		_sampleCount = 0;
		_bufferSample = 0.0;
		
		for(i in 0...length)
		{
			if (_finished) {
				return true;
			}
			
			// Repeats every _repeatLimit times, partially resetting the sound parameters
			if(_repeatLimit != 0)
			{
				if(++_repeatTime >= _repeatLimit)
				{
					_repeatTime = 0;
					reset(false);
				}
			}
			
			// If _changeLimit is reached, shifts the pitch
			if(_changeLimit != 0)
			{
				if(++_changeTime >= _changeLimit)
				{
					_changeLimit = 0;
					_period *= _changeAmount;
				}
			}
			
			// Acccelerate and apply slide
			_slide += _deltaSlide;
			_period *= _slide;
			
			// Checks for frequency getting too low, and stops the sound if a minFrequency was set
			if(_period > _maxPeriod)
			{
				_period = _maxPeriod;
				if(_minFreqency > 0.0) _finished = true;
			}
			
			_periodTemp = _period;
			
			// Applies the vibrato effect
			if(_vibratoAmplitude > 0.0)
			{
				_vibratoPhase += _vibratoSpeed;
				_periodTemp = _period * (1.0 + Math.sin(_vibratoPhase) * _vibratoAmplitude);
			}
			
			_periodTemp = Std.int(_periodTemp);
			if(_periodTemp < 8) _periodTemp = 8;
			
			// Sweeps the square duty
			if (_waveType == 0)
			{
				_squareDuty += _dutySweep;
					 if(_squareDuty < 0.0) _squareDuty = 0.0;
				else if (_squareDuty > 0.5) _squareDuty = 0.5;
			}
			
			// Moves through the different stages of the volume envelope
			if(++_envelopeTime > _envelopeLength)
			{
				_envelopeTime = 0;
				
				switch(++_envelopeStage)
				{
					case 1: _envelopeLength = _envelopeLength1;
					case 2: _envelopeLength = _envelopeLength2;
				}
			}
			
			// Sets the volume based on the position in the envelope
			switch(_envelopeStage)
			{
				case 0: _envelopeVolume = _envelopeTime * _envelopeOverLength0; 									
				case 1: _envelopeVolume = 1.0 + (1.0 - _envelopeTime * _envelopeOverLength1) * 2.0 * _sustainPunch; 
				case 2: _envelopeVolume = 1.0 - _envelopeTime * _envelopeOverLength2; 								
				case 3: _envelopeVolume = 0.0; _finished = true; 													
			}
			
			// Moves the phaser offset
			if (_phaser)
			{
				_phaserOffset += _phaserDeltaOffset;
				_phaserInt = Std.int(_phaserOffset);
				if(_phaserInt < 0) 	_phaserInt = -_phaserInt;
				else if (_phaserInt > 1023) _phaserInt = 1023;
			}
			
			// Moves the high-pass filter cutoff
			if(_filters && _hpFilterDeltaCutoff != 0.0)
			{
				_hpFilterCutoff *= _hpFilterDeltaCutoff;
					 if(_hpFilterCutoff < 0.00001) 	_hpFilterCutoff = 0.00001;
				else if(_hpFilterCutoff > 0.1) 		_hpFilterCutoff = 0.1;
			}
			
			_superSample = 0.0;
			for(j in 0...8)
			{
				// Cycles through the period
				_phase++;
				if(_phase >= _periodTemp)
				{
					_phase = _phase - Std.int(_periodTemp);
					
					// Generates new random noise for this period
					if(_waveType == 3) 
					{ 
						for(n in 0...32) _noiseBuffer[n] = Math.random() * 2.0 - 1.0;
					}
				}
				
				// Gets the sample from the oscillator
				switch(_waveType)
				{
					case 0: // Square wave
						_sample = ((_phase / _periodTemp) < _squareDuty) ? 0.5 : -0.5;
					case 1: // Saw wave
						_sample = 1.0 - (_phase / _periodTemp) * 2.0;
					case 2: // Sine wave (fast and accurate approx)
						_pos = _phase / _periodTemp;
						_pos = _pos > 0.5 ? (_pos - 1.0) * 6.28318531 : _pos * 6.28318531;
						_sample = _pos < 0 ? 1.27323954 * _pos + .405284735 * _pos * _pos : 1.27323954 * _pos - 0.405284735 * _pos * _pos;
						_sample = _sample < 0 ? .225 * (_sample *-_sample - _sample) + _sample : .225 * (_sample * _sample - _sample) + _sample;
					case 3: // Noise
						_sample = _noiseBuffer[Std.int(_phase * 32 / Std.int(_periodTemp))];
				}
				
				// Applies the low and high pass filters
				if (_filters)
				{
					_lpFilterOldPos = _lpFilterPos;
					_lpFilterCutoff *= _lpFilterDeltaCutoff;
					_lpFilterCutoff = Math.max(0, Math.min(_lpFilterCutoff, 0.1));
					
					if(_lpFilterOn)
					{
						_lpFilterDeltaPos += (_sample - _lpFilterPos) * _lpFilterCutoff;
						_lpFilterDeltaPos *= _lpFilterDamping;
					}
					else
					{
						_lpFilterPos = _sample;
						_lpFilterDeltaPos = 0.0;
					}
					
					_lpFilterPos += _lpFilterDeltaPos;
					
					_hpFilterPos += _lpFilterPos - _lpFilterOldPos;
					_hpFilterPos *= 1.0 - _hpFilterCutoff;
					_sample = _hpFilterPos;
				}
				
				// Applies the phaser effect
				if (_phaser)
				{
					_phaserBuffer[_phaserPos&1023] = _sample;
					_sample += _phaserBuffer[(_phaserPos - _phaserInt + 1024) & 1023];
					_phaserPos = (_phaserPos + 1) & 1023;
				}
				
				_superSample += _sample;
			}
			
			// Averages out the super samples and applies volumes
			_superSample = _masterVolume * _envelopeVolume * _superSample * 0.125;
			
			// Clipping if too loud
			_superSample = Math.max( -1.0, Math.min(_superSample, 1.0));
			
			if(waveData)
			{
				// Writes same value to left and right channels
				buffer.writeFloat(_superSample);
				buffer.writeFloat(_superSample);
			}
			else
			{
				_bufferSample += _superSample;
				
				_sampleCount++;
				
				// Writes mono wave data to the .wav format
				if(sampleRate == 44100 || _sampleCount == 2)
				{
					_bufferSample /= _sampleCount;
					_sampleCount = 0;
					
					if(bitDepth == 16) 	buffer.writeShort(Std.int(32000.0 * _bufferSample));
					else 				buffer.writeByte(Std.int(_bufferSample * 127 + 128));
					
					_bufferSample = 0.0;
				}
			}
		}
		return false;
	}
	
	
	//--------------------------------------------------------------------------
	//	
	//  .wav File Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a ByteArray of the wave in the form of a .wav file, ready to be saved out
	 * @param	sampleRate		Sample rate to generate the .wav at	
	 * @param	bitDepth		Bit depth to generate the .wav at	
	 * @return					Wave in a .wav file
	 */
	function getWavFile(sampleRate:Int = 44100, bitDepth:Int = 16):ByteArray
	{
		stop();
		
		reset(true);
		
		if (sampleRate != 44100) sampleRate = 22050;
		if (bitDepth != 16) bitDepth = 8;
		
		var soundLength:Int = Std.int(_envelopeFullLength);
		if (bitDepth == 16) soundLength *= 2;
		if (sampleRate == 22050) soundLength = cast soundLength * 0.5;
		
		var filesize:Int = 36 + soundLength;
		var blockAlign:Int = Std.int(bitDepth / 8);
		var bytesPerSec:Int = sampleRate * blockAlign;
		
		var wav:ByteArray = new ByteArray();
		
		// Header
		wav.endian = Endian.BIG_ENDIAN;
		wav.writeUnsignedInt(0x52494646);		// Chunk ID "RIFF"
		wav.endian = Endian.LITTLE_ENDIAN;
		wav.writeUnsignedInt(filesize);			// Chunk Data Size
		wav.endian = Endian.BIG_ENDIAN;
		wav.writeUnsignedInt(0x57415645);		// RIFF Type "WAVE"
		
		// Format Chunk
		wav.endian = Endian.BIG_ENDIAN;
		wav.writeUnsignedInt(0x666D7420);		// Chunk ID "fmt "
		wav.endian = Endian.LITTLE_ENDIAN;
		wav.writeUnsignedInt(16);				// Chunk Data Size
		wav.writeShort(1);						// Compression Code PCM
		wav.writeShort(1);						// Float of channels
		wav.writeUnsignedInt(sampleRate);		// Sample rate
		wav.writeUnsignedInt(bytesPerSec);		// Average bytes per second
		wav.writeShort(blockAlign);				// Block align
		wav.writeShort(bitDepth);				// Significant bits per sample
		
		// Data Chunk
		wav.endian = Endian.BIG_ENDIAN;
		wav.writeUnsignedInt(0x64617461);		// Chunk ID "data"
		wav.endian = Endian.LITTLE_ENDIAN;
		wav.writeUnsignedInt(soundLength);		// Chunk Data Size
		
		synthWave(wav, Std.int(_envelopeFullLength), false, sampleRate, bitDepth);
		
		wav.position = 0;
		
		return wav;
	}
}