package net.digitalprimates.volume.functions;

import net.digitalprimates.volume.VolumeExtension;
import net.digitalprimates.volume.monitor.SettingsContentObserver;
import android.content.Context;
import android.os.Handler;
import android.provider.Settings.System;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class InitFunction implements FREFunction {
	public static final String TAG = "InitFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		VolumeExtension.extensionContext = context;
		
		Context appContext = context.getActivity().getApplicationContext();
		VolumeExtension.appContext = appContext;
		
		// Start watching settings for volume changes.
		VolumeExtension.mSettingsWatcher = new SettingsContentObserver( new Handler() );
		VolumeExtension.appContext.getContentResolver().registerContentObserver(System.CONTENT_URI, true, VolumeExtension.mSettingsWatcher);
		
		Log.i(TAG, "in init");
		
		// Tell AIR what the volume is right now.
		VolumeExtension.notifyVolumeChange();
		
		return null;
	}
}
