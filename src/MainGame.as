package {
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
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
	import starling.utils.AssetManager;
	import starling.utils.HAlign;
	
	public class MainGame extends Sprite {
		public static var inst:MainGame;
		public var enemyPool:SpritePool;
		public var liveEnemies:Vector.<Enemy>;
		
		public var velocity:Point;
		public var hero:Hero;
		public var ground_y:Number;
		public var gameover:Boolean;
		
		private var bgSprite:Sprite;
		private var bgSpriteB:Sprite;
		
		private var bgWidth:Number;
		
		private var timer:Number;
		private var score:Number;
		private var textField:TextField;
		private var highTxt:TextField;
		private var aboutTxt:TextField;
		
		private var slashImg:Image;
		private var slashTween:Tween;
		
		private var firstPlay:uint;
		private var directionsImg:Image;
		private var creditsImg:Image;
		private var hiscore:Number;
		public var isPause:Boolean;
		
		public var assets:AssetManager;
		
		public static var sharedObject:SharedObject;
		public static const DATA_SHARED_OBJECT:String = "dataSharedObject"; //just a string
		
		public function MainGame() {
			super();
			
			assets = new AssetManager();
			assets.verbose = true;
			
			assets.enqueue(Assets); //yes, enqueue the entire class
			assets.loadQueue(function(ratio:Number):void {
					trace("Loading assets, progress:", ratio); //track the progress with this ratio
					if (ratio == 1.0)
						initGame();
				});
		
		}
		
		private function initGame():void {
			Main.inst.removeSplash();
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			inst = this;
			
			firstPlay = 0;
			
			ground_y = stage.stageHeight * 0.7;
			enemyPool = new SpritePool(Enemy, 15);
			
			initLevel();
			init();
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function init():void {
			liveEnemies = new Vector.<Enemy>();
			velocity = new Point(0, 0);
			
			isPause = false;
			timer = 0;
			score = 0;
			gameover = false;
			
			hiscore = load("hiscore");
			if (isNaN(hiscore)) {
				save("hiscore", 0);
				hiscore = 0;
			}
			
			highTxt.text = "Best:" + hiscore;
			
			if (firstPlay < 3) {
				directionsImg = new Image(assets.getTexture("directions"));
				directionsImg.y = ground_y;
				directionsImg.x = hero.x - directionsImg.width / 2;
				TweenLite.to(directionsImg, 3, {delay: 5, alpha: 0, onComplete: removeDirections});
				addChild(directionsImg);
				firstPlay++;
			}
		}
		
		public static function save(string:String, value:*):void {
			sharedObject = SharedObject.getLocal(DATA_SHARED_OBJECT);
			sharedObject.data[string] = (value);
			sharedObject.flush();
		}
		
		public static function load(string:String):* {
			sharedObject = SharedObject.getLocal(DATA_SHARED_OBJECT);
			return sharedObject.data[string];
		
		}
		
		private function onTouch(event:TouchEvent):void {
			var btnTouch:Touch = event.getTouch(aboutTxt, TouchPhase.BEGAN);
			if (btnTouch) {
				if (!isPause) {
					isPause = true;
					aboutTxt.text = "Resume";
					setChildIndex(creditsImg, numChildren - 1);
					creditsImg.visible = true;
				} else {
					isPause = false;
					aboutTxt.text = "Pause";
					creditsImg.visible = false
				}
			} else if (!isPause) {
				var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
				if (touch) {
					if (!gameover) {
						var localPos:Point = touch.getLocation(stage);
						if (localPos.x < stage.stageWidth * 0.3) {
							moveLeft();
						} else {
							attackRight();
						}
						textField.text = "Distance: " + score;
					} else {
						Starling.juggler.purge();
						
						while (liveEnemies.length > 0) {
							var b:Enemy = liveEnemies[0];
							b.free();
						}
						hero.initPosition();
						init();
					}
				}
			}
		}
		
		private function moveLeft():void {
			velocity.x = -23;
			score += velocity.x;
		}
		
		private function attackRight():void {
			if (hero.isGround) {
				hero.isGround = false;
				hero.changeStance(Hero.JUMP);
				velocity.y = -23;
				velocity.x = 18;
				
				score += velocity.x;
			}
		}
		
		/**
		 * Sets up score, background, hero, and slash effect.
		 * Called only once.
		 */
		private function initLevel():void {
			
			initBackground();
			
			//Create textfield
			textField = new TextField(stage.stageWidth, 45, "Distance: 0");
			textField.y = 0;
			textField.hAlign = HAlign.LEFT;
			textField.autoScale = true;
			textField.fontSize = 58;
			textField.color = 0x084141
			addChild(textField);
			
			highTxt = new TextField(stage.stageWidth, 45, "Distance: 0");
			highTxt.y = 0;
			highTxt.x = 0;
			highTxt.hAlign = HAlign.RIGHT;
			highTxt.autoScale = true;
			highTxt.fontSize = 58;
			highTxt.color = 0x084141
			addChild(highTxt);
			
			aboutTxt = new TextField(100, 45, "Pause");
			aboutTxt.y = 0;
			aboutTxt.x = stage.stageWidth / 2 - 50;
			//aboutTxt.border = true;
			aboutTxt.hAlign = HAlign.CENTER;
			aboutTxt.autoScale = true;
			aboutTxt.fontSize = 58;
			aboutTxt.color = 0x084141
			addChild(aboutTxt);
			
			//Create hero
			hero = new Hero();
			hero.initPosition();
			addChild(hero);
			
			initSlashImage();
			
			creditsImg = new Image(assets.getTexture("credits"));
			creditsImg.alpha = 0.6;
			creditsImg.x = stage.stageWidth / 2;
			creditsImg.y = 75;
			creditsImg.visible = false;
			addChild(creditsImg);
		
		}
		
		private function removeDirections():void {
			removeChild(directionsImg);
			directionsImg = null;
		}
		
		private function initSlashImage():void {
			
			slashImg = new Image(MainGame.inst.assets.getTexture("slash"));
			slashImg.x = hero.x + hero.width / 2;
			slashImg.alpha = 0;
			slashImg.touchable = false;
			slashImg.scaleX = slashImg.scaleY = .7;
			addChild(slashImg);
			slashTween = new Tween(slashImg, 0.5, Transitions.EASE_OUT);
		}
		
		/**
		 * Creates 2 container sprites, each holding 2 copies of the BG texture.
		 */
		private function initBackground():void {
			addChild(new Image(assets.getTexture("farBg")));
			
			bgSprite = new Sprite();
			bgSpriteB = new Sprite();
			bgWidth = 854;
			var bgImg:Image = new Image(MainGame.inst.assets.getTexture("bg"));
			
			bgImg = new Image(MainGame.inst.assets.getTexture("bg"));
			bgImg.width = bgWidth;
			bgImg.y = stage.stageHeight - bgImg.height * 1.4;
			bgSprite.addChild(bgImg);
			bgSprite.touchable = false;
			
			addChild(bgSprite);
			
			bgImg = new Image(MainGame.inst.assets.getTexture("bg"));
			bgImg.width = bgWidth;
			
			bgImg.y = stage.stageHeight - bgImg.height * 1.4;
			bgSpriteB.addChild(bgImg);
			bgSpriteB.touchable = false;
			
			bgSpriteB.x = bgWidth;
			addChild(bgSpriteB);
			
			var numGround:int = Math.ceil(stage.stageWidth / 284) + 3;
			trace("numground:" + numGround)
			for (var i:uint = 0; i < numGround; i++) {
				var g:Ground = new Ground();
				g.init(i * g.WIDTH);
			}
		}
		
		public function loseGame():void {
			
			if (score > hiscore) {
				save("hiscore", score);
			}
			
			gameover = true;
			//textField.text = "Game Over! Distance: " + score;
			hero.loseAnimation();
		}
		
		public function slashAnimation():void {
			//Animation effect
			Starling.juggler.removeTweens(slashImg);
			slashImg.alpha = 1;
			slashImg.y = ground_y - 80;
			slashTween.reset(slashImg, 0.5, Transitions.EASE_OUT);
			
			slashTween.animate("alpha", 0);
			slashTween.animate("y", slashImg.y + 10);
			Starling.juggler.add(slashTween);
			
			//Hit detection against all live enemies
			var hitRect:Rectangle = slashImg.getBounds(this);
			for each (var b:Enemy in liveEnemies) {
				if (hitRect.intersects(b.getRect())) {
					b.deathAnimation();
				}
			}
		}
		
		public function addGround(sX:Number):void {
			var g:Ground = new Ground();
			g.init(sX);
			//if (Math.random() > 0.8) {
			//g.x += hero.width;
			//}
		}
		
		/**
		 * Main game loop. Runs at ~60 times per second.
		 * @param	e
		 */
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!gameover && !isPause) {
				if (velocity.x != 0) {
					horizontalFriction();
					scrollBackground();
				}
				
				velocity.y += 3;
				
				hero.update();
				
				//Create new enemy every couple second
				timer += 1 / 30;
				if (timer > 0.55 + Math.random() * 0.8) {
					timer = 0;
					addEnemy();
				}
				
			}
		}
		
		/**
		 * Applies friction against velocity.x
		 */
		private function horizontalFriction():void {
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
		
		/**
		 * Moves the background depending on the current velocity.x.
		 */
		private function scrollBackground():void {
			bgSprite.x -= velocity.x / 2;
			bgSpriteB.x -= velocity.x / 2;
			if (bgSprite.x < -bgWidth) {
				bgSprite.x = bgSpriteB.x + bgWidth;
			}
			if (bgSpriteB.x < -bgWidth) {
				bgSpriteB.x = bgSprite.x + bgWidth;
			}
			if (bgSprite.x > bgWidth) {
				bgSprite.x = bgSpriteB.x - bgWidth;
			}
			if (bgSpriteB.x > bgWidth) {
				bgSpriteB.x = bgSprite.x - bgWidth;
			}
		}
		
		/**
		 * Pulls an enemy from the pool, initializes it.
		 */
		private function addEnemy():void {
			var newEnemy:Enemy = Enemy(enemyPool.getSprite());
			if (newEnemy) {
				newEnemy.init();
			}
		}
	}
}