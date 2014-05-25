package  {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.media.SoundChannel;
	
	public class Game extends Sprite {

		private static const JUMP_SPEED:int = 17;
		private static const GRAVITY:int = 15;
		private var jumpvy = -50;
		private var jumpcount = 5;	
		private var jumpcounter = 0;
		
		var jumping:Boolean;
		var counter:int = 0;
		var jumpState:String;
		var pulling:Boolean;

		var walking:Boolean = false;
		var walkDirection:int = 0; // 1 left 2 right 0 jump
		
		var jumpSound:Sound = new JumpSound();
		var cherrySound:Sound = new CherrySound();
		var pickSound:Sound = new PickSound();
		var throwSound:Sound = new ThrowSound();
		var killSound:Sound = new KillSound();
		var shrinkSound:Sound = new ShrinkSound();
		var deadSound:Sound = new DeadSound();
		//var climbSound:Sound = new ClimbSound();
		
		var upPressed = false;
		
		var scaling = false;
		
		var test = false;
		var veg:MovieClip;
		//var throwVeg:Boolean;
		var tvegs:Array = [];
		
		//var picked;
		//var pickables:Array = [];
		
		var badguyf:MovieClip;
		
		//var remsh1 = false;
		
		var bad1;
		var bad2;
		
		var hea = 2;
		var hitable = true;
		
		var gameover = false;
		var testmc:MovieClip;
		var onFloor:Boolean = true;
		
		var floors:Array = [];
		
		var soundControl:SoundChannel = new SoundChannel();
		var carringVeg:MovieClip;
		var ranges:Array = [
			[818, 918, 1595, "myf3"],
			[981, 993, 1675, "myf4"],
			[1059, 1079, 1688, "myf5"],
			[1139, 1155, 1663, "myf6"],
			[1250, 1312, 1674, "myf7"],
			[1218, 1268, 1626, "myf8"],
			[1252, 1299, 1592, "myf9"],
			[1283, 1492, 1587, "myf10"]
		];
		
		var rectangles:Array = [
			new Rectangle(976.5, 1713.9, 24, 44),
			new Rectangle(1056.5, 1710.9, 25, 44),
			new Rectangle(1139, 1695.9, 22, 59)
		];
		
		var playerx;
		var playery;
		
		public function Game() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			stage.addEventListener("vegetable", onVegetable);
			
			player.anim.stop();
			
			this.x = -410;
			this.y = -1525;
			
			//background.walls.visible = false;
			background.floor.visible = false;
			background.scalable.visible = false;
			
			bad1 = background.badguys.sh1;
			bad2 = background.badguys.sh2;
			bad1.dir = 1;
			
			//pickables.push(background.plants.pow)
			
			testmc = new MovieClip();
			testmc.x = 0;
			testmc.y = player.height - 1;
			
			var testshape:Shape = new Shape();
			testshape.graphics.lineStyle(1, 0xFF0000, 1);
			testshape.graphics.moveTo(0, 0);
			testshape.graphics.lineTo(player.width, 0);
			
			testmc.addChild(testshape);
			
			player.addChild(testmc);
			//trace("x:",player.x);
			//trace("width:", player.width);
			//player.addChild(testshape);
			
			//mc.parent.addChild(testmc);
		
			for (var i = 0; i < background.floor.numChildren; i++) {
				floors.push(background.floor.getChildAt(i));
			}
			
			playerx = player.x;
			playery = player.y;
			
			stage.focus = stage;
		}
		
		function drawTestShape(p:Point):void {
			var test:Sprite = new Sprite();
			addChild(test);
			test.graphics.lineStyle(1,0xFF0000);
			test.graphics.beginFill(0xFF0000);
			test.graphics.drawCircle(p.x,p.y,2);
			test.graphics.endFill();
		}
		
		var playerD = -2;
		//var playerDvel = 1;
		var initY;
		
		var backmin = 300;
		
		var jumpingStart = false;
		var ccc = 0;
		
		var startScalingLoop = true; 
		function enterFrame(evt:Event):void {
			if (!animLocked) {
				if (gameover) {
					player.y += playerD;
					if (player.y <= (initY - 50)) {
						playerD *= -1;
						//playerD += 2;
					}
					else if (player.y >= initY + 100) {
						//removeChild(player);
					}
					
				} else {
					//trace(background.y);
					if (playery > 1760) {
						player.gotoAndStop(14);
						initY = player.y
						gameover = true;
						deadSound.play();
						return;
					}
					if (upPressed) {
						if (hitsScalable(player)) { //scale
							//if (startScalingLoop) {
								//soundControl = climbSound.play();
								//soundControl.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
								//startScalingLoop = false;
							//}
							player.gotoAndStop(5);
							//trace("after going", (player as MovieClip).currentFrame)
							scaling = true;
							//background.y += 2;
							player.y -= 2;
							playery -= 2;
							if (carringVeg) {
								carringVeg.y -= 2;
							}
							walkDirection = 0;
						}
						else { //jump
							if (onFloor) {
								scaling = false;
								jumpSound.play();
								jumping = true;
								//jumpingStart = true;
							}
						}
					}
					
					if (jumping) {
						if (++jumpcounter < jumpcount) {
							//jumpvy += GRAVITY;
							//background.y += GRAVITY * 1.2;
							player.y -= GRAVITY * 1.2;
							playery -= GRAVITY * 1.2;
							if (carringVeg) {
								trace("decr caarin");
								carringVeg.y -= GRAVITY * 1.2;
							}
							//jumpingStart = false;
						}
						else {
							jumping = false;
							jumpcounter = 0;
						}
						
						
						//if (counter ==  0) {
							//background.y += JUMP_SPEED;
							//jumpSound.play();
							//counter++;
						//
						//} else if (counter < 8) {
							//background.y += JUMP_SPEED;
							//counter++;
							//
						//} else if (counter < 16) {
							//counter++;
							//
						//} else {
							//counter = 0;
							//jumping = false;
						//}
					}
					
					if (!walking && !scaling) { //idle
						if (!pulling) {
						 if (walkDirection == 1) { //left
							player.gotoAndStop(4);
						 } else if (walkDirection == 2) { //right
							player.gotoAndStop(3);
						}} 
						else {
							if (walkDirection == 1) { //left
							player.gotoAndStop(13);
						 } else if (walkDirection == 2) { //right
							player.gotoAndStop(12);
						 } 
						}

					} else { //walking / pulling
						//trace("entering else, walkDir:" + walkDirection);
						if (walking) {
							if (walkDirection == 1) { //left
								if (!hitTestLeft(player.getBounds(this))) {
									background.x += 5;
									playerx -= 5;
									//if (jumping) {
										//background.x += 10;
										//playerx -= 10;
									//}
									
									if (!scaling) {
										if (pulling) {
											player.gotoAndStop(9);
										} else {
											player.gotoAndStop(2);
										}
									}
								}
								
							} else if (walkDirection == 2) { //right
								//trace("walkDirection");
								if (!hitTestRight(player.getBounds(this))) {
									//trace("background.x -= 5;");
									background.x -= 5;
									playerx += 5;
									//if (jumping) {
										//background.x -= 10;
										//playerx += 10;
									//}
									if (!scaling) {
										if (pulling) {
											player.gotoAndStop(8);
										} else {
											player.gotoAndStop(1);
										}
									}
								}
							}
						}	
						
						if (!hitsScalable(player)) {
							scaling = false;
						}
					}
					
					eat();
					
					if (!scaling) {
						var distance = distanceToFloor2();
						//trace("diiistance:" + distance);
						//if (background.y > backmin) 
						//background.y -= distance;
						player.y += distance;
						playery += distance;
						if (carringVeg) {
							carringVeg.y += distance;
						}
					}}
					
					if (tvegs.length > 0) {
						var veg;
						for (var i:int = 0; i < tvegs.length; i++) {
							veg = tvegs[i];
							veg["vy"] += g;
							veg.y += veg["vy"];
							
							if (veg["dir"] == 2) {
								veg.x += (vx + 2);
							} else {
								veg.x -= (vx + 2);
							}
						
							if (veg.y > 1760) {
								removeChild(veg);
								tvegs.splice(i, 1);
								//throwVeg = false;
								vx = 5;
								vy = -3; // negative is up
							}
						}
						
						
						var badguys:MovieClip = background.badguys;
						for (var i:int = 0; i < badguys.numChildren; i++) {
						if (veg.hitTestObject(badguys.getChildAt(i))) {
							killSound.play();
							var badguy = badguys.getChildAt(i);
							
							badguyf = badguy;
							badguyf.gotoAndStop(2);
							//badguys.removeChildAt(i);
							
						}
					}
					}
					
					//move bad guy 1
					if (bad1) {
						if (bad1.dir == 2) { //right
							bad1.x += 1;
							if (bad1.x >= 210) {
								bad1.dir = 1;
								bad1.gotoAndStop(1);
							}
							
						} else { //left
							bad1.x -= 1;
							if (bad1.x <= -340) {
								bad1.dir = 2;
								bad1.gotoAndStop(3);
							}
						}
					}
					
					//move bad guy 2
					if (bad2) {
						if (bad2.dir == 2) { //right
							bad2.x += 1;
							if (bad2.x >= 150) {
								bad2.dir = 1;
								bad2.gotoAndStop(1);
							}
							
						} else { //left
							bad2.x -= 1;
							if (bad2.x <= 65) {
								bad2.dir = 2;
								bad2.gotoAndStop(3);
							}
						}
					}
					if (hitable && (player.hitTestObject(bad1) || player.hitTestObject(bad2))) {
						shrinkSound.play();
						--hea;
						hitable = false;
						if (hea == 1) {
							l2.gotoAndStop(2);
						} else if (hea == 0) {
							l1.gotoAndStop(2);
						} else {
							initY = player.y;
							player.gotoAndStop(14);
							gameover = true;
							deadSound.play();
						}
						var myTimer:Timer = new Timer(2000, 1);
						myTimer.addEventListener(TimerEvent.TIMER, onImmuneOver);
						myTimer.start();
					}
					
					if (badguyf) {
						badguyf.y += fally;
						if (badguyf.y > 50) {
							background.badguys.removeChild(badguyf);
							badguyf = null;
						}
					}
				}
		}
			
		
		var animLocked = false;
		
		var vx:Number = 5;
		var vy:Number = -3; // negative is up
		var g:Number = 1; // gravity
		
		var fally = 4;
		
		function eat():void {
			var food:MovieClip = background.food;
			for (var i:int = 0; i < food.numChildren; i++) {
				if (player.hitTestObject(food.getChildAt(i))) {
					cherrySound.play();
					food.removeChildAt(i);
				}
			}
		}
		
		function onImmuneOver(e:TimerEvent):void {
			hitable = true;
		}
		
		function hitsScalable(mc:MovieClip):Boolean {
			return background.scalable.hitTestObject(mc);
			
			//var bounds:Rectangle = mc.getBounds(this);
			//var topMidGlob = localToGlobal(new Point(bounds.topLeft.x + bounds.width / 2, bounds.topLeft.y + bounds.height / 2));
			//
			//return background.scalable.hitTestPoint(topMidGlob.x, topMidGlob.y, true);
		}
		
		var ttt = 0;
		function distanceToFloor2():int {
			if (isOnFloor()) {
				onFloor = true;
				return 0;
			} else {
				onFloor = false;
				var distance:int;
				var initY = testmc.y;
				
				var mcname:String;
				for each (var range in ranges) {
					if (playerx > range[0] && playerx < range[1] && playery < range[2]) {
						mcname = range[3];
					}
				};
				if (!mcname) {
					mcname = "myf1"
				}
				var counter = 0;
				while (counter < 4 && !testmc.hitTestObject(background.floor[mcname])) {
					testmc.y++;
					counter++;
				}
				//distance = testmc.y - initY;
				testmc.y = initY;
				//
				//if (distance > 4) {
					//distance = 4;
				//}
				return counter;
			}
		}
		
		private function isOnFloor():Boolean {
			for (var i = 0; i < background.floor.numChildren; i++) {
				if (testmc.hitTestObject(background.floor.getChildAt(i))) {
					//trace("returning isOnFloor true for:" +  background.floor.getChildAt(i).name);
					return true;
				}
			}
			return false;
		}
		
		 //function distanceToFloor(mc:MovieClip):int {
			//var bounds:Rectangle = player.getBounds(this);
			//var bottomLeft:Point = new Point(bounds.bottomRight.x - bounds.width, bounds.bottomRight.y);
	//
			//var globalLeft = localToGlobal(new Point(bottomLeft.x, bottomLeft.y + 1));
			//var globalMiddle = localToGlobal(new Point(bottomLeft.x + player.width / 2, bottomLeft.y + 1));
			//var globalRight = localToGlobal(new Point(bottomLeft.x + player.width, bottomLeft.y + 1));
			//
			//trace("backgorund.walls:" + background.walls.x + ", " + background.walls.y + "globalLef:" + globalLeft + "globalMiddle:" + globalMiddle + "globalRight:" + globalRight +
			//"bool:" + background.walls.hitTestPoint(globalLeft.x, globalLeft.y, true) || /*background.plants.pow.hitTestPoint(globalLeft.x, globalLeft.y, true) || */
				//background.walls.hitTestPoint(globalMiddle.x, globalMiddle.y, true) || /*background.plants.pow.hitTestPoint(globalMiddle.x, globalMiddle.y, true) ||*/
				//background.walls.hitTestPoint(globalRight.x, globalRight.y, true));
			//
			//if (background.walls.hitTestObject(mc)) {
				//return 0;
			//}
				//
			//tt
			//if (background.walls.hitTestPoint(globalLeft.x, globalLeft.y, true) || /*background.plants.pow.hitTestPoint(globalLeft.x, globalLeft.y, true) || */
				//background.walls.hitTestPoint(globalMiddle.x, globalMiddle.y, true) || /*background.plants.pow.hitTestPoint(globalMiddle.x, globalMiddle.y, true) ||*/
				//background.walls.hitTestPoint(globalRight.x, globalRight.y, true) /*|| background.plants.pow.hitTestPoint(globalRight.x, globalRight.y, true)*/) {
				//return 0;
			//}
			//
			//var testmc = new MovieClip();
			//testmc.x = bottomLeft.x;
			//testmc.y = mc.y + mc.height + GRAVITY;
			//
			//var testshape:Shape = new Shape();
			//testshape.graphics.lineStyle(2, 0x990000, .1);
			//testshape.graphics.moveTo(0, 0); 
			//testshape.graphics.lineTo(bounds.bottomRight.x, 0);
			//
			//testmc.addChild(testshape);
			//
			//mc.parent.addChild(testmc);
			//
			//globalLeft = localToGlobal(new Point(bottomLeft.x, bottomLeft.y + GRAVITY));
			//globalMiddle = localToGlobal(new Point(bottomLeft.x + player.width / 2, bottomLeft.y + GRAVITY));
			//globalRight = localToGlobal(new Point(bottomLeft.x + player.width, bottomLeft.y + GRAVITY));
			//
			//trace("backgorund.walls:" + background.walls + "globalLef:" + globalLeft + "globalMiddle:" + globalMiddle + "globalRight:" + globalRight);
			//
			//var hitpow:Boolean = false;
			//
			//var hitPickable = false;
			//var l =  background.plants.pow.hitTestPoint(globalLeft.x, globalLeft.y, true);
			//var m =  background.plants.pow.hitTestPoint(globalMiddle.x, globalMiddle.y, true);
			//var r =  background.plants.pow.hitTestPoint(globalRight.x, globalRight.y, true);
			//
			//if (l || m || r) {
				//hitpow = true;
			//}
//
			//tt
			//var leftHit = background.walls.hitTestPoint(globalLeft.x, globalLeft.y, true)/* || l*/;
			//var midHit = background.walls.hitTestPoint(globalMiddle.x, globalMiddle.y, true)/* || m*/;
			//var rightHit = background.walls.hitTestPoint(globalRight.x, globalRight.y, true)/* || r*/;
			//
			//trace("lefthit:" + leftHit + "midHit:" + midHit + "rightHit:" +rightHit);
		//
			//tt
			//if (!(leftHit || midHit || rightHit)) {
			//if (!(testmc.hitTestObject(background.walls))) {
				//return 10;
			//} else { //collided
			//
		///*	trace("---------------------------------------");
			//trace(leftHit);
			//trace(midHit);
			//trace(rightHit);
			//trace("---------------------------------------");
			//*/
				//var maxY = Math.min(globalLeft.y - 10, Math.min(globalMiddle.y - 10, globalRight.y - 10));
				//trace("maxY:", maxY);
				//
				//var min = globalLeft.y < globalMiddle.y ? globalLeft.y < globalRight.y ? globalLeft 
				///********************************************************************************************************************************************/
				//var leftDistance = 0;
				//while (!testmc.hitTestObject(background.walls)) {
					//testmc.y++;
					//leftDistance++;
				//}
				//return leftDistance;
				//
				//var min = globalLeft.y < globalMiddle.y ? globalLeft : globalMiddle;
				//min = min < globalRight ? min : globalRight;
				//
				//var testX = leftHit ? globalLeft.x : (midHit ? globalMiddle.x : globalRight.x);
				//
				//var leftDistance = 100;
				//var midDistance = 100;
				//var rightDistance = 100;
				//
				//if (leftHit) {
					//trace("lefthit!");
					//var testPoint = new Point(globalLeft.x, globalLeft.y - GRAVITY);
					//leftDistance = 0; 
					//if (hitpow) {
						//while (!background.plants.pow.hitTestPoint(testPoint.x, testPoint.y, true)) {
							//	trace("incrementing left", leftDistance);
							//trace("didnt hit:",  testPoint.y);
							//testPoint.y++;
							//leftDistance++;
						//}
					//} else {
						//while (!background.walls.hitTestPoint(testPoint.x, testPoint.y, true)) {
							//	trace("incrementing left", leftDistance);
							//trace("didnt hit:",  testPoint.y);
							//testPoint.y++;
							//leftDistance++;
						//}
					//}
				//}
				//
				//if (midHit) {
				//	trace("midHit!");
					//testPoint = new Point(globalMiddle.x, globalMiddle.y - GRAVITY);
					//midDistance = 0;
					//if (hitpow) {
						//while (!background.plants.pow.hitTestPoint(testPoint.x, testPoint.y, true)) {
							//	trace("incrementing left", leftDistance);
							//trace("didnt hit:",  testPoint.y);
							//testPoint.y++;
							//leftDistance++;
						//}
					//} else {
						//while (!background.walls.hitTestPoint(testPoint.x, testPoint.y, true)) {
								//trace("incrementing mid", midDistance);
							//trace("didnt hit:",  testPoint.y);
							//testPoint.y++;
							//midDistance++;
						//}
					//}
				//}
				//
				//if (rightHit) {
					//trace("rightHit!");
					//testPoint = new Point(globalRight.x, globalRight.y - GRAVITY);
					//rightDistance = 0;
					//if (hitpow) {
						//while (!background.plants.pow.hitTestPoint(testPoint.x, testPoint.y, true)) {
							//	trace("incrementing left", leftDistance);
							//trace("didnt hit:",  testPoint.y);
							//testPoint.y++;
							//leftDistance++;
						//}
					//} else {
					//while (!background.walls.hitTestPoint(testPoint.x, testPoint.y, true)) {
							//trace("incrementing right", rightDistance);
							//trace("didnt hit:",  testPoint.y);
							//testPoint.y++;
							//rightDistance++;
						//}
					//}
				//}
				///********************************************************************************************************************************************/
			//	var testPoint = new Point(min.x, min.y);
				//trace("the point:", testPoint);
				//var distance = 0;
				//
				//
				//
				//while (!background.walls.hitTestPoint(testPoint.x, testPoint.y, true)) {
					//trace("didnt hit:",  testPoint.y);
					//testPoint.y++;
					//distance++;
				//}
				//
				//tt
				//return Math.min(leftDistance, Math.min(midDistance, rightDistance)) - 1;
			//}
			//
		//}
		//
		function hitTestLeft(rect:Rectangle):Boolean {
			//var leftTop = rect.topLeft;
			//var global = localToGlobal(new Point(leftTop.x - 5, leftTop.y + rect.height));
			//return background.walls.hitTestPoint(global.x, global.y, true) /*|| background.plants.pow.hitTestPoint(global.x, global.y, true)*/;
			
			//for (var i = 0; i < background.walls.numChildren; i++) {
				//if (testmc.hitTestObject(background.walls.getChildAt(i))) {
					//trace("returning isOnFloor true for:" +  background.floor.getChildAt(i).name);
					//trace("returning true! left");
					//return true;
				//}
			//}
			//return false;
			
			for each (var r:Rectangle in rectangles) {
				//trace("testing" + testmc.x);
				
				var testx = playerx;
				//trace("testx:" + testx);
				if (testx > r.x && testx < (r.x + r.width) && (playery + player.height - 5) > r.y) {
					//trace("1:" + player.y + player.height);
					//trace("2:" + r.y);
					return true;
				}
			}
			return false;
		}

		function hitTestRight(rect:Rectangle):Boolean {
			//var rightBottom = rect.bottomRight;
			//var global = localToGlobal(new Point(rightBottom.x + 5, rightBottom.y));
			//trace("test: "+ global + "#" + background.walls.hitTestPoint(global.x, global.y, true));
			//return background.walls.hitTestPoint(global.x, global.y, true) /*|| background.plants.pow.hitTestPoint(global.x, global.y, true)*/;
			
			//for (var i = 0; i < background.walls.numChildren; i++) {
				//if (testmc.hitTestObject(background.walls.getChildAt(i))) {
					//trace("returning isOnFloor true for:" +  background.floor.getChildAt(i).name);
					//trace("returning true! right");
					//return true;
				//}
			//}
			//return false;
			
			for each (var r:Rectangle in rectangles) {
				//trace("testing" + testmc.x);
				
				var testx = playerx + player.width;
				//trace("testx:" + testx);
				if (testx > r.x && testx < (r.x + r.width) && (playery + player.height - 5) > r.y) {
					return true;
				}
			}
			return false;
		}
		
		function onKeyDown(event:KeyboardEvent):void {
			
			switch (event.keyCode) {
				case Keyboard.LEFT:
					walking = true;
					walkDirection = 1;
					
					break;
				
				case Keyboard.RIGHT:
					walking = true;
					walkDirection = 2;
					
					break;
				
				case Keyboard.UP:
					upPressed = true;
					
					break;
					
				case 65:
					tryToLift();
					break;
			}
		}
		
		//private function soundCompleteHandler(e:Event):void {
			//soundControl.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			//soundControl = climbSound.play();
			//soundControl.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		//}

		function tryToLift() {
			if (!pulling) {
				var plants:MovieClip = background.plants;
				for (var i:int = 0; i < plants.numChildren; i++) {
					if (player.hitTestObject(plants.getChildAt(i))) {
						pickSound.play();
						//picked = plants.getChildAt(i);
						
						trace("carringveg:" + carringVeg);
						plants.removeChildAt(i);
						
						//trace("!!picked after removing:" + picked);
						animLocked = true;
						pulling = true;
						if (walkDirection == 2) { //right
							player.gotoAndStop(6);
						} else {
							player.gotoAndStop(7);
						}
					}
				}
			} else { //throw
				//picked = null;
				if (carringVeg) {
				carringVeg["vy"] = -3;
				carringVeg["dir"] = walkDirection;
				tvegs.push(carringVeg);
				carringVeg = null;
				throwSound.play();
				//throwVeg = true;
				
				pulling = false;
				}
			}
		}
		
		function onVegetable(event:Event) {
			veg = new veg1();
			veg.x = player.x;
			veg.y = player.y;
			
			veg.y -= (veg.height - 4);
			//veg["vy"] = -3;
			//veg["dir"] = walkDirection;
			addChild(veg);
			carringVeg = veg;
			animLocked = false;
		}
		
		function onKeyUp(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					walking = false;
					
				break;
				case Keyboard.UP:
					upPressed = false;
					if (scaling) {
						//trace("the anim:", player.anim, (player as MovieClip).currentFrame);
						if (player.anim) {
							player.anim.stop();
						}
						//soundControl.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
						//soundControl.stop();
						//startScalingLoop = true;
					}
				break;
			}
		}
		
		function onClick(event:MouseEvent):void {
			//trace("click on:", event.stageX, event.stageY);
			//trace("click on local:", event.localX, event.localY);
			//trace( background.walls.hitTestPoint(event.stageX, event.stageY, true));
			 //trace( background.walls.hitTestPoint(event.localX, event.localY, true));
			 
			 trace(localToGlobal(new Point(event.localX, event.localX)));
			// trace("isonfloor:", isOnFloor(new Point(event.stageX, event.stageY),new Point(event.stageX, event.stageY)));
			//trace("isonfloor2:", isOnFloor(new Point(event.localX, event.localY),new Point(event.localX, event.localY)));
		}
	}
}