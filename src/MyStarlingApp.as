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
		
		private var thomImg:Image;
		private var sphereImg:Image;
		private var barImg:Image;
		private var ggImg:Image;
		public var enemies:Vector.<Enemy>;
		public static var inst:MyStarlingApp;
		private var velocity:Point;
		private var timer:uint;
		
		public function MyStarlingApp() {
			super();
			
			inst = this;
			enemies = new Vector.<Enemy>();
			velocity = new Point(0, 0);
			timer = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		}
		
		private function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touch) {
				var localPos:Point = touch.getLocation(this);
				if (localPos.x < stage.stageWidth / 2) {
					moveLeft();
				} else {
					attackRight();
				}
				
			}
		}
		
		private function moveLeft():void {
			velocity.x = -8;
		}
		
		private function attackRight():void {
			velocity.y = -25;
			velocity.x = 15;
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			createAndShowImage();
		}
		
		private function createAndShowImage():void {
			var textField:TextField = new TextField(400, 300, "Welcome to Starling!");
			addChild(textField);
			
			var myBitmap:Bitmap = new barImage();
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
			if (velocity.x != 0) {
				var endVel:Number;
				if (velocity.x > 0) {
					endVel = velocity.x - 1;
					if (endVel > 0) {
						velocity.x = endVel;
					} else {
						velocity.x = 0;
					}
				} else {
					endVel = velocity.x + 1;
					if (endVel < 0) {
						velocity.x = endVel;
					} else {
						velocity.x = 0;
					}
				}
			}
			velocity.y += 3;
			
			if (thomImg.y + velocity.y >= stage.stageHeight * 0.75) {
				thomImg.y = stage.stageHeight * 0.75;
				velocity.y = 0;
			}
			
			thomImg.x += velocity.x;
			thomImg.y += velocity.y;
			
			timer++;
			if (timer > 120) {
				timer = 0;
				var newEnemy:Enemy = new Enemy(new Point(stage.stageWidth + 50, stage.stageHeight * 0.75), stage);
			}
			
			for each (var b:Enemy in enemies) {
				b.update();
			}
		}
	}
}