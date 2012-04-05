package net.digitalprimates.volume;

import java.util.HashMap;
import java.util.Map;

import net.digitalprimates.volume.functions.InitFunction;
import net.digitalprimates.volume.functions.SetVolumeFunction;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class VolumeExtensionContext extends FREContext {
	public static final String TAG = "VolumeExtensionContext";
	
	@Override
	public void dispose() {
		Log.d(TAG,"Context disposed.");
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
		
		functions.put("init", new InitFunction());
		functions.put("setVolume", new SetVolumeFunction());
		
		return functions;
	}
}
