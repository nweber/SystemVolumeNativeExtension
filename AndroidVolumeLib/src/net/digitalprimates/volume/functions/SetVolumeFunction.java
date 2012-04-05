package net.digitalprimates.volume.functions;

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
