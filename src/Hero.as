package {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Hero extends Sprite {
		public static const STAND:uint = 0;
		public static const DIE:uint = 1;
		public static const JUMP:uint = 2;
		public static const FALL:uint = 3;
		
		private var main:MainGame;
		private var spawn:Point;
		
		private var objVector:Vector.<Quad>;
		
		public var stance:uint = STAND;
		
		public var isDead:Boolean;
		
		private var ground_y:Number;
		private var slashImg:Image;
		private var slashTween:Tween;
		private var attacking:Boolean;
		public var isGround:Boolean;
		private var bound:Rectangle;
		
		public function Hero() {
			super();
			main = MainGame.inst;
			
			spawn = new Point(main.stage.stageWidth * 0.3, main.stage.stageHeight / 2);
			
			pivotX = width / 2;
			pivotY = height / 2;
			touchable = false;
			
			bound = new Rectangle(0, 0, 83, 147);
			
			ground_y = main.ground_y - height / 2;
			
			initAnimations();
		}
		
		private function initAnimations():void {
			var a:AssetManager = MainGame.inst.assets;
			
			var standIMG:Image = new Image(a.getTexture("butter_stand"));
			standIMG.y = -80;
			//standIMG.y = -25;
			standIMG.pivotX = standIMG.width / 2;
			standIMG.pivotY = standIMG.height / 2;
			
			var dieIMG:Image = new Image(a.getTexture("butter_die"));
			dieIMG.y = -80;
			//dieIMG.y = -25;
			dieIMG.pivotX = 15
			dieIMG.pivotY = 15
			
			var jumpIMG:Image = new Image(a.getTexture("butter_jump"));
			jumpIMG.y = -80;
			//jumpIMG.y = -25;
			jumpIMG.pivotX = jumpIMG.width / 2;
			jumpIMG.pivotY = jumpIMG.height / 2;
			
			var fallIMG:Image = new Image(a.getTexture("butter_fall"));
			fallIMG.y = -80;
			//fallIMG.y = -25;
			fallIMG.pivotX = fallIMG.width / 2;
			fallIMG.pivotY = fallIMG.height / 2;
			
			objVector = new Vector.<Quad>();
			objVector[STAND] = standIMG;
			objVector[DIE] = dieIMG;
			objVector[JUMP] = jumpIMG;
			objVector[FALL] = fallIMG;
			
			addChild(fallIMG);
		}
		
		public function initPosition():void {
			x = spawn.x;
			y = spawn.y;
			rotation = 0;
			isGround = false;
		}
		
		public function getMC(i:int = -1):Quad {
			if (i == -1) {
				i = stance;
			}
			return objVector[i];
		}
		
		public function changeStance(newStance:uint):void {
			if (newStance != stance) {
				var curObject:DisplayObject = objVector[stance];
				if (curObject) {
					removeChild(curObject);
				}
				stance = newStance;
				curObject = objVector[stance];
				if (curObject) {
					addChild(curObject);
				}
			}
		}
		
		public function loseAnimation():void {
			changeStance(DIE);
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_OUT);
			//tween.animate("y", y - 100);
			//tween.animate("rotation", -5);
			tween.animate("x", x - 150);
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
				if (main.velocity.y > 0) {
					changeStance(FALL);
				}
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
				changeStance(STAND);
			}
			if (main.velocity.x < 0) {
				changeStance(FALL);
			}
		}
		
		public function getRect():Rectangle {
			bound.x = x - bound.width / 2;
			bound.y = y - bound.height * 1.2;
			return bound;
		}
	
	}

}