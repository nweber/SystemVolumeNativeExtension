/**
 * Copyright (C) 2011 Digital Primates
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/

package com.adobe.nativeextension.volume;

import android.content.Context;
import android.media.AudioManager;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.adobe.nativeextension.volume.monitor.SettingsContentObserver;

public class VolumeExtension implements FREExtension {
	public static final String TAG = "VolumeExtension";
	
	public static FREContext extensionContext;
	public static Context appContext;
	public static SettingsContentObserver mSettingsWatcher;
	
	private static float NO_VALUE = (float)-1.0;
	private static Float lastSystemVolume = NO_VALUE;
	
	public static void notifyVolumeChange() {
		AudioManager aManager = (AudioManager) appContext.getSystemService(Context.AUDIO_SERVICE);
		Float maxVolume = Float.valueOf(aManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC));
		Float systemVolume = Float.valueOf(aManager.getStreamVolume(AudioManager.STREAM_MUSIC));
		
		// Only dispatch the event if the volume actually changed.
		// The settings watcher is going to see *any* settings change,
		// so it's possible that we'll get in here but the volume hasn't
		// changed.  We shouldn't tell Flash if that's the case.
		if (systemVolume != lastSystemVolume) {
			lastSystemVolume = systemVolume;
			
			Float flashVolume = systemVolume / maxVolume;
			
			Log.i(TAG, "system volume: " + systemVolume);
			Log.i(TAG, "adjusted volume: " + flashVolume);
			
			String volume = String.valueOf( flashVolume );
			String eventName = "volumeChanged";
			
			extensionContext.dispatchStatusEventAsync(eventName, volume);
		}
	}
	
	@Override
	public FREContext createContext(String contextType) {
		return new VolumeExtensionContext();
	}

	@Override
	public void dispose() {
		Log.d(TAG, "Extension disposed.");
		
		// Stop watching settings for volume changes.
		VolumeExtension.appContext.getContentResolver().unregisterContentObserver(mSettingsWatcher);
		
		appContext = null;
		extensionContext = null;
		mSettingsWatcher = null;
		lastSystemVolume = NO_VALUE;
	}

	@Override
	public void initialize() {
		Log.d(TAG, "Extension initialized.");
	}
}
