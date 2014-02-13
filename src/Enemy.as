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
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Enemy {
		[Embed(source="carb.png")]
		private static const carbImage:Class
		public var img:Image;
		private var main:MyStarlingApp;
		private var vel:Point;
		private var dead:Boolean = false;
		
		public function Enemy(spawn:Point, main:MyStarlingApp) {
			super();
			var myBitmap:Bitmap = new carbImage();
			img = Image.fromBitmap(myBitmap);
			
			// Change images origin to it's center
			// (Otherwise by default it's top left)
			img.pivotX = img.width / 2;
			img.pivotY = img.height / 2;
			
			// Where to place the image on screen
			img.x = spawn.x;
			img.y = spawn.y;
			
			vel = new Point(-3, 0);
			this.main = main;
			main.addChild(img);
			main.enemies.push(this);
		}
		
		public function kill():void {
			if (!dead) {
				var tween:Tween = new Tween(img, 1, Transitions.EASE_OUT);
				tween.animate("y", main.stage.stageHeight + 100);
				tween.animate("rotation", 10);
				tween.animate("x", img.x + Math.random() * 200);
				tween.onComplete = remove;
				dead = true;
				Starling.juggler.add(tween);
			}
		
		}
		
		public function remove():void {
			Starling.juggler.removeTweens(img);
			main.enemies.splice(main.enemies.indexOf(this), 1);
			img.removeFromParent(true);
			img = null;
		}
		
		public function getRect():Rectangle {
			var rect:Rectangle;
			return img.getBounds(main, rect);
		}
		
		public function update(passedTime:Number):void {
			if (!dead) {
				img.x += passedTime * 100 * (vel.x - main.velocity.x);
				img.y += passedTime * 100 * vel.y;
				if (img.x < -100 || img.y > main.stage.stageHeight || img.y < 0) {
					dead = true;
					remove();
				}
			}
		}
	}

}