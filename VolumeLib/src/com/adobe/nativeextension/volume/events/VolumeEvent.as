package com.adobe.nativeextension.volume.events
{
	import flash.events.Event;
	
	public class VolumeEvent extends Event
	{
		//----------------------------------------
		//
		// Constants
		//
		//----------------------------------------
		
		public static const VOLUME_CHANGED:String = "volumeChanged";
		
		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------
		
		public var volume:Number;
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		public function VolumeEvent( type:String, volume:Number, bubbles:Boolean=false, cancelable:Boolean=false ) {
			this.volume = volume;
			super(type, bubbles, cancelable);
		}
	}
}