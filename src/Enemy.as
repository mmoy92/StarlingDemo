package {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Enemy extends Sprite{
		private var main:MyStarlingApp;
		private var vel:Point;
		private var spawn:Point;
		
		public var isDead:Boolean;
		
		public function Enemy() {
			super();
			main = MyStarlingApp.inst;
			addChild(new Image(Assets.carbTexture));
			spawn = new Point(main.stage.stageWidth + 50, main.ground_y - height/2);
			
			// Change images origin to it's center
			pivotX = width / 2;
			pivotY = height / 2;
			touchable = false;
			
			vel = new Point(-3, 0);
		}
		
		public function init():void {
			isDead = false;
			
			visible = true;
			x = spawn.x;
			y = spawn.y;
			rotation = 0;
			
			main.liveEnemies.push(this);
			main.addChild(this);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		/**
		 * Game loop.
		 * Applies velocity for movement.
		 * Disposes once off screen.
		 * Checks hit against hero.
		 * @param	e
		 */
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!isDead && !main.gameover) {
				x += e.passedTime * 100 * (vel.x - main.velocity.x);
				y += e.passedTime * 100 * vel.y;
				if (x < -100 || y > main.stage.stageHeight || y < 0) {
					free();
				} else {
					if (main.hero.getRect().intersects(getRect())) {
						main.loseGame();
					}
				}
			}
		}
		/**
		 * Death animation.
		 * 
		 * Calls free() once animation finishes.
		 */
		public function deathAnimation():void {
			if (!isDead) {
				isDead = true;
				var tween:Tween = new Tween(this, 1, Transitions.EASE_OUT);
				tween.animate("y", main.stage.stageHeight + 100);
				tween.animate("rotation", 10);
				tween.animate("x", x + Math.random() * 200);
				tween.onComplete = free;
				Starling.juggler.add(tween);
			}
		}
		/**
		 * Removed from liveEnemies array, and animation juggler.
		 * Sent to back of pool.
		 */
		public function free():void {
			main.liveEnemies.splice(main.liveEnemies.indexOf(this), 1);
			main.enemyPool.freeSprite(this);
			main.removeChild(this);
			
			Starling.juggler.removeTweens(this);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			visible = false;
		}
		
		public function getRect():Rectangle {
			var rect:Rectangle;
			return getBounds(main, rect);
		}
	}

}