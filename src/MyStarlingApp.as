package {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class MyStarlingApp extends Sprite {
		[Embed(source="STHOMAS.png")]
		private static const thomImage:Class
		[Embed(source="bg.png")]
		private static const backImage:Class;
		[Embed(source="slash.png")]
		private static const slashImage:Class;
		
		private var thomImg:Image;
		private var ggImg:Image;
		private var bgSprite:Sprite;
		private var bgSpriteB:Sprite;
		private var slashImg:Image;
		public var enemies:Vector.<Enemy>;
		public static var inst:MyStarlingApp;
		public var velocity:Point;
		private var timer:Number;
		private var attacking:Boolean;
		public static var ground_y:Number;
		private var score:uint = 0;
		private var textField:TextField;
		private var gameover:Boolean;
		
		public function MyStarlingApp() {
			super();
			
			init();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		
		}
		
		private function init():void {
			inst = this;
			enemies = new Vector.<Enemy>();
			velocity = new Point(0, 0);
			timer = 0;
			attacking = false;
			gameover = false;
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			ground_y = stage.stageHeight * 0.75;
			createAndShowImage();
		}
		
		private function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touch) {
				if (!gameover) {
					var localPos:Point = touch.getLocation(this);
					if (localPos.x < stage.stageWidth * 0.3) {
						moveLeft();
					} else {
						attackRight();
					}
				} else {
					Starling.juggler.purge();
					thomImg.x = stage.stageWidth * 0.3;
					thomImg.y = stage.stageHeight / 2;
					thomImg.rotation = 0;
					
					for each (var b:Enemy in enemies) {
						b.img.removeFromParent(true);
						b.img = null;
					}
					init();
				}
			}
		}
		
		private function moveLeft():void {
			velocity.x = -20;
		}
		
		private function attackRight():void {
			//if (thomImg.y >= ground_y) {
			velocity.y = -22;
			velocity.x = 10;
			//}
			attacking = true;
		}
		
		private function createAndShowImage():void {
			textField = new TextField(400, 300, "Score: 0");
			addChild(textField);
			
			bgSprite = new Sprite();
			bgSpriteB = new Sprite();
			
			var myBitmap:Bitmap = new backImage();
			
			var bgImg:Image = Image.fromBitmap(myBitmap);
			bgImg.x = 0;
			bgImg.y = stage.stageHeight - bgImg.height;
			bgSprite.addChild(bgImg);
			
			bgImg = Image.fromBitmap(myBitmap);
			bgImg.x = bgImg.width;
			bgImg.y = stage.stageHeight - bgImg.height;
			bgSprite.addChild(bgImg);
			
			addChild(bgSprite);
			
			bgImg = Image.fromBitmap(myBitmap);
			bgImg.x = 0;
			bgImg.y = stage.stageHeight - bgImg.height;
			bgSpriteB.addChild(bgImg);
			
			bgImg = Image.fromBitmap(myBitmap);
			bgImg.x = bgImg.width;
			bgImg.y = stage.stageHeight - bgImg.height;
			
			bgSpriteB.addChild(bgImg);
			
			bgSpriteB.x = bgSprite.width;
			
			addChild(bgSpriteB);
			
			myBitmap = new thomImage();
			thomImg = Image.fromBitmap(myBitmap);
			
			thomImg.pivotX = thomImg.width / 2;
			thomImg.pivotY = thomImg.height / 2;
			thomImg.scaleX = thomImg.scaleY = 0.2;
			thomImg.x = stage.stageWidth * 0.3;
			thomImg.y = stage.stageHeight / 2;
			
			addChild(thomImg);
			
			myBitmap = new slashImage();
			slashImg = Image.fromBitmap(myBitmap);
			slashImg.x = thomImg.x + thomImg.width / 2;
			slashImg.alpha = 0;
			addChild(slashImg);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!gameover) {
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
				
				if (velocity.x != 0) {
					bgSprite.x -= velocity.x * 100 * e.passedTime;
					bgSpriteB.x -= velocity.x * 100 * e.passedTime;
					if (bgSprite.x < -bgSprite.width) {
						bgSprite.x = bgSpriteB.x + bgSpriteB.width;
					}
					if (bgSpriteB.x < -bgSpriteB.width) {
						bgSpriteB.x = bgSprite.x + bgSprite.width;
					}
					if (bgSprite.x > bgSprite.width) {
						bgSprite.x = bgSpriteB.x - bgSpriteB.width;
					}
					if (bgSpriteB.x > bgSpriteB.width) {
						bgSpriteB.x = bgSprite.x - bgSprite.width;
					}
				}
				
				if (velocity.y != 0) {
					thomImg.y += velocity.y * 100 * e.passedTime;
					if (thomImg.y >= ground_y - thomImg.height / 2) {
						thomImg.y = ground_y - thomImg.height / 2;
						velocity.y = 0;
					}
				}
				timer += e.passedTime;
				if (timer > 0.2 + Math.random() * 0.8) {
					timer = 0;
					var newEnemy:Enemy = new Enemy(new Point(stage.stageWidth + 50, ground_y - 40), this);
				}
				var b:Enemy;
				var hitRect:Rectangle;
				var tween:Tween;
				if (attacking && thomImg.y > ground_y - 120 && velocity.y > 0) {
					
					slashImg.y = thomImg.y;
					Starling.juggler.removeTweens(slashImg);
					
					slashImg.alpha = 1;
					tween = new Tween(slashImg, 0.5, Transitions.EASE_OUT);
					tween.animate("alpha", 0);
					tween.animate("y", slashImg.y + 10);
					
					Starling.juggler.add(tween);
					
					for each (b in enemies) {
						hitRect = slashImg.getBounds(this);
						
						if (hitRect.intersects(b.getRect())) {
							b.kill();
							score++;
						}
					}
					
					textField.text = "Score: " + score;
					attacking = false;
				}
				
				for each (b in enemies) {
					b.update(e.passedTime);
					if (!gameover) {
						hitRect = thomImg.getBounds(this);
						if (hitRect.intersects(b.getRect())) {
							gameover = true;
							textField.text = "Game Over! Score: " + score;
							
							tween = new Tween(thomImg, 0.5, Transitions.EASE_OUT);
							tween.animate("y", thomImg.y - 100);
							tween.animate("rotation", -5);
							tween.animate("x", thomImg.x - 50);
							//tween.onComplete = remove;
							Starling.juggler.add(tween);
						}
					}
				}
			}
		}
	}
}