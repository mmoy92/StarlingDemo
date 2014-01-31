package {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	
	/**
	 * ...
	 * @author Michael M
	 */
	public class Bullet {
		[Embed(source="fireball.png")]
		private static const bulletImage:Class
		private var img:Image;
		private var stage:Stage;
		private var vel:Point;
		
		public function Bullet(spawn:Point, rot:Number, stage:Stage) {
			super();
			var myBitmap:Bitmap = new bulletImage();
			img = Image.fromBitmap(myBitmap);
			
			// Change images origin to it's center
			// (Otherwise by default it's top left)
			img.pivotX = img.width / 2;
			img.pivotY = img.height / 2;
			
			// Where to place the image on screen
			img.x = spawn.x;
			img.y = spawn.y;
			img.rotation = rot - 3.14 / 2;
			
			vel = new Point(Math.cos(img.rotation) * Math.PI, Math.sin(img.rotation)*Math.PI);
			this.stage = stage;
			stage.addChild(img);
			MyStarlingApp.inst.bullets.push(this);
		}
		
		public function update():void {
			img.x += vel.x * 10;
			img.y += vel.y * 10;
			if (img.x > stage.stageWidth || img.x < 0 || img.y > stage.stageHeight || img.y < 0) {
				stage.removeChild(img);
				MyStarlingApp.inst.bullets.splice(MyStarlingApp.inst.bullets.indexOf(this), 1);
			}
		}
	}

}