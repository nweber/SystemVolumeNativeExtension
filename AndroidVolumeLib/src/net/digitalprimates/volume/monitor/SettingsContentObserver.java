package net.digitalprimates.volume.monitor;

import net.digitalprimates.volume.VolumeExtension;
import android.database.ContentObserver;
import android.os.Handler;
import android.util.Log;


public class SettingsContentObserver extends ContentObserver {
	public static final String TAG = "SettingsContentObserver";
	
	public SettingsContentObserver(Handler handler) {
	    super(handler);
	} 

	@Override
	public boolean deliverSelfNotifications() {
	     return super.deliverSelfNotifications(); 
	}

	@Override
	public void onChange(boolean selfChange) {
	    super.onChange(selfChange);
	    Log.v(TAG, "Settings change detected");
	    
		// Dispatch event to AIR.
		VolumeExtension.notifyVolumeChange();
	}
}
