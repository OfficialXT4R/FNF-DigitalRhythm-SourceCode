package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flash.system.System;

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hello there!   \n
			Welcome to the mod! Before you play, I'd like to say something to you.\n
			This mod includes flashing lights and animated backgrounds\n
            (animated backgrounds that can't be turned off),\n
			\n
            If you are triggered by these stuff, press the Esc key to stop playing,\n
            Oooor...you can press Enter to continue playing!\n
            With all that been said..\n
			Have fun!",
			16);
		warnText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
        warnText.screenCenter(X);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
			if (controls.ACCEPT) {
                LoadingState.loadAndSwitchState(new TitleState());
			}
            else if (controls.BACK) 
            {
                {
                    System.exit(0);
                }
		    }
		super.update(elapsed);
   }
}