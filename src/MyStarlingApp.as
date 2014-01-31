package {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class MyStarlingApp extends Sprite {
		[Embed(source="STHOMAS.png")]
		private static const thomImage:Class
		[Embed(source="sphere.png")]
		private static const sphereImage:Class;
		[Embed(source="bar.png")]
		private static const barImage:Class;
		[Embed(source="GGvect_100x100.png")]
		private static const MyImage:Class
		
		private var thomImg:Image;
		private var sphereImg:Image;
		private var barImg:Image;
		private var ggImg:Image;
		public var bullets:Vector.<Bullet>;
		public static var inst:MyStarlingApp;
		public function MyStarlingApp() {
			super();
			
			inst = this;
			bullets = new Vector.<Bullet>();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
			trace("test");
		}
		
		private function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this, TouchPhase.MOVED);
			if (touch) {
				var localPos:Point = touch.getLocation(this);
				sphereImg.x = localPos.x;
				thomImg.rotation = ((localPos.x / stage.stageWidth) * 6.283) - 3.14;
				var newBullet:Bullet = new Bullet(new Point(thomImg.x, thomImg.y), thomImg.rotation, stage);
			}
		}
		
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createAndShowImage();
		}
		
		private function createAndShowImage():void {
			// Create bitmap instance and use it to create an image 
			var myBitmap:Bitmap = new MyImage();
			ggImg = Image.fromBitmap(myBitmap);
			
			// Change images origin to it's center
			// (Otherwise by default it's top left)
			ggImg.pivotX = ggImg.width / 2;
			ggImg.pivotY = ggImg.height / 2;
			
			// Where to place the image on screen
			ggImg.x = stage.stageWidth / 2;
			ggImg.y = stage.stageHeight / 2;
			
			// Add image to display in order to show it
			addChild(ggImg);
			
			var textField:TextField = new TextField(400, 300, "Welcome to Starling!");
			addChild(textField);
			
			myBitmap = new barImage();
			barImg = Image.fromBitmap(myBitmap);
			barImg.pivotX = barImg.width / 2;
			barImg.pivotY = barImg.height / 2;
			
			// Where to place the image on screen
			barImg.x = stage.stageWidth / 2;
			barImg.y = stage.stageHeight - barImg.height / 2;
			
			addChild(barImg);
			
			myBitmap = new sphereImage();
			sphereImg = Image.fromBitmap(myBitmap);
			sphereImg.pivotX = sphereImg.width / 2;
			sphereImg.pivotY = sphereImg.height / 2;
			
			// Where to place the image on screen
			sphereImg.x = barImg.x;
			sphereImg.y = barImg.y;
			
			addChild(sphereImg);
			
			myBitmap = new thomImage();
			thomImg = Image.fromBitmap(myBitmap);
			
			thomImg.pivotX = thomImg.width / 2;
			thomImg.pivotY = thomImg.height / 2;
			thomImg.scaleX = thomImg.scaleY = 0.2;
			thomImg.x = stage.stageWidth / 2;
			thomImg.y = stage.stageHeight / 2;
			
			addChild(thomImg);
		}
		
		private function onEnterFrame(e:Event):void {
			// Rotate slightly each frame
			ggImg.rotation -= 0.01;
			for each(var b:Bullet in bullets) {
				b.update();
			}
		}
	}
}