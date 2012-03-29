package com.adobe.nativeextension.volume
{
	import com.adobe.nativeextension.volume.events.VolumeEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class VolumeController extends EventDispatcher
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		private var extContext:ExtensionContext;
		
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		/**
		 * Initializes the native extension. 
		 */		
		public function init():void {
			extContext.call( "init" );
		}
		
		/**
		 * Changes the device's system volume. 
		 */		
		public function setVolume( newVolume:Number ):void {
			if ( newVolume < 0 ) {
				newVolume = 0;
			}
			
			if ( newVolume > 1 ) {
				newVolume = 1;
			}
			
			extContext.call( "setVolume", newVolume );
		}
		
		/**
		 * Cleans up the instance of the native extension. 
		 */		
		public function dispose():void { 
			extContext.dispose(); 
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		private function onStatus( event:StatusEvent ):void {
			dispatchEvent( new VolumeEvent( VolumeEvent.VOLUME_CHANGED, Number(event.level), false, false ) );
		}
		
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		public function VolumeController() {
			super();
			
			extContext = ExtensionContext.createExtensionContext( "com.adobe.volume", "" );
			
			if ( !extContext ) {
				throw new Error( "Volume native extension is not supported on this platform." );
			}
			
			extContext.addEventListener( StatusEvent.STATUS, onStatus );
		}
	}
}