package {
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	
	public class Main extends Sprite {
		private var _starling:Starling;
		
		public function Main():void {
			// This time we won't scale our application (check next post for that :).
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Trigger an event handler when application looses focus (see note in handler).
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			SetupStarling();
		}
		
		private function SetupStarling():void {
			// Create a new instance and pass our class and the stage
			var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), StageScaleMode.SHOW_ALL);
			_starling = new Starling(MyStarlingApp, stage, viewPort);
			
			// Show debug stats
			_starling.showStats = true;
			
			// Define level of antialiasing, 
			_starling.antiAliasing = 1;
			
			_starling.start();
		}
		
		private function deactivate(e:Event):void {
			// Auto-close the application when it looses focus. This is what you want 
			// to do if you don't want that your application continues to run in the 
			// background if the user switch program, answer a call or anything else 
			// that would cause your application to lose focus.
			//
			// If you want to keep it running you should at least pause it until the 
			// user returns. That's achieved by calling _starling.stop(). You should 
			// also add an event listener for the Event.ACTIVATE event that will 
			// trigger _starling.start() once the application get's focus again.
			//
			NativeApplication.nativeApplication.exit();
		}
	}

}