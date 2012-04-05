package net.digitalprimates.volume;

import net.digitalprimates.volume.monitor.SettingsContentObserver;
import android.content.Context;
import android.media.AudioManager;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

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
