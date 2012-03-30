/**
 * Copyright (C) 2011 Digital Primates
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/
package com.adobe.nativeextension.volume
{
	import com.adobe.nativeextension.volume.events.VolumeEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	/**
	 * A controller used to interact with the system volume on iOS and
	 * Android devices.  Ways to change the volume programatically
	 * and to respond to the hardware volume buttons are included.
	 *  
	 * @author Nathan Weber
	 */	
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
		 * <p>This method must be called for the native extension to
		 * monitor the for volume changes originating from the device iOS.</p>
		 * <p>Immediately following this call a <code>VOLUME_CHANGED</code>
		 * event will be dispatched with the current system volume.  Add an
		 * event listener for VOLUME_CHANGED before calling <code>init()</code></p> 
		 */		
		public function init():void {
			extContext.call( "init" );
		}
		
		/**
		 * Changes the device's system volume.
		 *  
		 * @param newVolume The new system volume.  This value should be between 0 and 1.
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
		
		/**
		 * Constructor. 
		 */		
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