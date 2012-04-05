/** * Copyright (C) <year> <copyright holders> *  * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. **/package net.digitalprimates.volume{	import flash.events.EventDispatcher;
	/**	 * A controller used to interact with the system volume on iOS and	 * Android devices.  Ways to change the volume programatically	 * and to respond to the hardware volume buttons are included.	 *  	 * @author Nathan Weber	 */		public class VolumeController extends EventDispatcher	{		//----------------------------------------		//		// Variables		//		//----------------------------------------
		private static var _instance:VolumeController;
		//----------------------------------------		//		// Properties		//		//----------------------------------------
		private var _systemVolume:Number = 1;
		public function get systemVolume():Number {			return _systemVolume;		}
		public function set systemVolume( value:Number ):void {			if ( _systemVolume == value ) {				return;			}
			_systemVolume = value;		}
		//----------------------------------------		//		// Public Methods		//		//----------------------------------------
		public static function get instance():VolumeController {			if ( !_instance ) {				_instance = new VolumeController( new SingletonEnforcer() );				_instance.init();			}
			return _instance;		}
		/**		 * Changes the device's system volume.		 *  		 * @param newVolume The new system volume.  This value should be between 0 and 1.		 */				public function setVolume( newVolume:Number ):void {			if ( isNaN(newVolume) )  {				newVolume = 1;			}
			if ( newVolume < 0 ) {				newVolume = 0;			}
			if ( newVolume > 1 ) {				newVolume = 1;			}
			systemVolume = newVolume;		}
		/**		 * Cleans up the instance of the native extension. 		 */				public function dispose():void { 
		}
		//----------------------------------------		//		// Handlers		//		//----------------------------------------
		private function init():void {
		}
		//----------------------------------------		//		// Constructor		//		//----------------------------------------
		/**		 * Constructor. 		 */				public function VolumeController( enforcer:SingletonEnforcer ) {			super();		}	}}class SingletonEnforcer {
}