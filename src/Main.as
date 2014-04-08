package {
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	
	public class Main extends Sprite {
		[Embed(source="../assets/graphics/Splash.png")]
		public static const SplashPNG:Class;
		public static var inst:Main;
		private var _starling:Starling;
		private var splashBmp:Bitmap;
		
		public function Main():void {
			// This time we won't scale our application (check next post for that :).
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP_LEFT;
			
			// Trigger an event handler when application looses focus (see note in handler).
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			stage.addEventListener(Event.ACTIVATE, activate);
			
			inst = this;
			
			splashBmp = new SplashPNG();
			stage.addChild(splashBmp);
			
			SetupStarling();
		}
		
		public function removeSplash():void {
			stage.removeChild(splashBmp);
		}
		
		private function SetupStarling():void {
			// Create a new instance and pass our class and the stage
			//var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), StageScaleMode.SHOW_ALL);
			
			var viewPort:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			
			_starling = new Starling(MainGame, stage, viewPort);
			_starling.stage.stageWidth  = 854;
			_starling.stage.stageHeight = 480;
			
			// Show debug stats
			//_starling.showStats = true;
			
			// Define level of antialiasing, 
			_starling.antiAliasing = 0;
			
			_starling.start();
		}
		
		private function deactivate(e:Event):void {
			_starling.stop();
		}
		
		private function activate(e:Event):void
		{
			_starling.start();
		}
	}

}