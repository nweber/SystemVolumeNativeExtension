package net.digitalprimates.volume.events{	import flash.events.Event;
	/**	 * An event used by the native extension for	 * events related to the volume controls.	 *  	 * @author Nathan Weber	 */		public class VolumeEvent extends Event	{		//----------------------------------------		//		// Constants		//		//----------------------------------------
		/**		 * Disatched when the system volume on the decive changes. 		 */				public static const VOLUME_CHANGED:String = "volumeChanged";
		//----------------------------------------		//		// Properties		//		//----------------------------------------
		/**		 * The system volume of the device. 		 */				public var volume:Number;
		//----------------------------------------		//		// Constructor		//		//----------------------------------------
		/**		 * Constructor.		 *  		 * @param type Event type.		 * @param volume The system volume.		 * @param bubbles Whether or not the event bubbles.		 * @param cancelable Whether or not the event is cancelable.		 */				public function VolumeEvent( type:String, volume:Number, bubbles:Boolean=false, cancelable:Boolean=false ) {			this.volume = volume;
			super(type, bubbles, cancelable);		}	}}