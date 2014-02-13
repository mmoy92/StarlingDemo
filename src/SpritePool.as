package {
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class SpritePool {
		private var pool:Array;
		private var counter:int;
		
		public function SpritePool(type:Class, len:int) {
			pool = new Array();
			counter = len;
			
			var i:int = len;
			while (--i >= 0) {
				pool[i] = new type();
				
			}
		}
		public function getSprite():DisplayObject {
			if (counter > 0) {
				return pool[--counter];
			} else {
				throw new Error("Pool exhausted");
			}
		}
		
		public function freeSprite(s:DisplayObject):void {
			pool[counter++] = s;
		}
	
	}

}