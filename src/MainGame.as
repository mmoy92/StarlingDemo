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
	
	public class MainGame extends Sprite {
		public static var inst:MainGame;
		public var enemyPool:SpritePool;
		public var groundPool:SpritePool;
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
		private var slashImg:Image;
		private var slashTween:Tween;
		
		public function MainGame() {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		
		}
		
		private function init():void {
			liveEnemies = new Vector.<Enemy>();
			velocity = new Point(0, 0);
			
			timer = 0;
			score = 0;
			
			gameover = false;
		
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			inst = this;
			
			init();
			
			ground_y = stage.stageHeight * 0.75;
			enemyPool = new SpritePool(Enemy, 10);
			groundPool = new SpritePool(Ground, 10);
			
			initLevel();
		}
		
		private function onTouch(event:TouchEvent):void {
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
		
		private function moveLeft():void {
			velocity.x = -23;
			score += velocity.x;
		}
		
		private function attackRight():void {
			if (hero.isGround) {
				hero.isGround = false;
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
			//Create textfield
			textField = new TextField(stage.stageWidth, 300, "Distance: 0");
			textField.autoScale = true;
			textField.fontSize = 20;
			addChild(textField);
			
			initBackground();
			
			//Create hero
			hero = new Hero();
			hero.initPosition();
			addChild(hero);
			
			initSlashImage();
		
		}
		
		private function initSlashImage():void {
			slashImg = new Image(Assets.getAtlas().getTexture("slash"));
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
			bgSprite = new Sprite();
			bgSpriteB = new Sprite();
			bgWidth = 854;
			var bgImg:Image = new Image(Assets.getAtlas().getTexture("bg"));
			
			bgImg = new Image(Assets.getAtlas().getTexture("bg"));
			bgImg.width = bgWidth;
			bgImg.y = stage.stageHeight - bgImg.height * 1.2;
			bgSprite.addChild(bgImg);
			bgSprite.touchable = false;
			
			addChild(bgSprite);
			
			bgImg = new Image(Assets.getAtlas().getTexture("bg"));
			bgImg.width = bgWidth;
			
			bgImg.y = stage.stageHeight - bgImg.height * 1.2;
			bgSpriteB.addChild(bgImg);
			bgSpriteB.touchable = false;
			
			bgSpriteB.x = bgWidth;
			addChild(bgSpriteB);
			
			var numGround:int = Math.ceil(stage.stageWidth / 170);
			for (var i:uint = 0; i < numGround; i++) {
				var g:Ground = Ground(groundPool.getSprite());
				g.init();
				g.x = i * g.width;
			}
		}
		
		public function loseGame():void {
			gameover = true;
			textField.text = "Game Over! Distance: " + score;
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
		
		public function addGround():void {
			var g:Ground = Ground(groundPool.getSprite());
			g.init();
			if (Math.random() > 0.8) {
				g.x += hero.width;
			}
		}
		
		/**
		 * Main game loop. Runs at ~60 times per second.
		 * @param	e
		 */
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!gameover) {
				if (velocity.x != 0) {
					horizontalFriction();
					scrollBackground();
				}
				velocity.y += 3;
				
				hero.update();
				
				//Create new enemy every couple seconds
				timer += 1/30;
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
			} else if (bgSprite.x > bgWidth) {
				bgSprite.x = bgSpriteB.x - bgWidth;
			}
			if (bgSpriteB.x < -bgWidth) {
				bgSpriteB.x = bgSprite.x + bgWidth;
			} else if (bgSpriteB.x > bgWidth) {
				bgSpriteB.x = bgSprite.x - bgWidth;
			}
		}
		
		/**
		 * Pulls an enemy from the pool, initializes it.
		 */
		private function addEnemy():void {
			var newEnemy:Enemy = Enemy(enemyPool.getSprite());
			newEnemy.init();
		}
	}
}