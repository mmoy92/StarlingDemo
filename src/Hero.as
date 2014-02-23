package {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Hero extends Sprite {
		private var main:MainGame;
		private var spawn:Point;
		
		public var isDead:Boolean;
		
		private var ground_y:Number;
		private var slashImg:Image;
		private var slashTween:Tween;
		private var attacking:Boolean;
		public var isGround:Boolean;
		
		public function Hero() {
			super();
			main = MainGame.inst;
			addChild( new Image(Assets.getAtlas().getTexture("STHOMAS")));
			
			spawn = new Point(main.stage.stageWidth * 0.3, main.stage.stageHeight / 2);
			
			pivotX = width / 2;
			pivotY = height / 2;
			touchable = false;
			
			ground_y = main.ground_y - height / 2;
		}
		
		public function initPosition():void {
			x = spawn.x;
			y = spawn.y;
			rotation = 0;
			isGround = false;
		}
		
		public function loseAnimation():void {
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_OUT);
			tween.animate("y", y - 100);
			tween.animate("rotation", -5);
			tween.animate("x", x - 50);
			Starling.juggler.add(tween);
		}
		
		/**
		 * Game loop.
		 * Applies gravity and ground hit.
		 * Calls slash animation when falling near the ground.
		 * @param	passedTime
		 */
		public function update():void {
			y += main.velocity.y * 1.67; // 100 * 1 / 60
			
			if (!isGround) {
				if (y >= ground_y - 50 && main.velocity.y > 0 && !attacking) {
					main.slashAnimation();
					attacking = true;
				}
			}
			if (y >= ground_y) {
				y = ground_y;
				main.velocity.y = 0;
				isGround = true;
				attacking = false;
			}
		}
		
		public function getRect():Rectangle {
			return getBounds(main);
		}
	
	}

}