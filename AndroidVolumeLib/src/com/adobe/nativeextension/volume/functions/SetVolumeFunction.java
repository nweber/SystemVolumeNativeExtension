/**
 * Copyright (C) 2011 Digital Primates
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/

package com.adobe.nativeextension.volume.functions;

import android.content.Context;
import android.media.AudioManager;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetVolumeFunction implements FREFunction {
	public static final String TAG = "SetVolumeFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		Context appContext = context.getActivity().getApplicationContext();
		AudioManager aManager = (AudioManager) appContext.getSystemService(Context.AUDIO_SERVICE);
		
		double volume = 1;
		try {
			volume = args[0].getAsDouble();
		} catch (Exception e) {
			
		}
		
		int maxVolume = aManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		volume = volume * maxVolume;
		int index = (int) volume;
		
		aManager.setStreamVolume(AudioManager.STREAM_MUSIC, index, 0);
		
		return null;
	}
}
