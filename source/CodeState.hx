package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.ui.FlxSpriteButton;
import editors.ChartingState;

using StringTools;

class CodeState extends MusicBeatState
{
    // sprites and text
    var windowPopUp:FlxSprite;
    var text:FlxText;
    var ok:FlxSpriteButton;
    var cancel:FlxSpriteButton;
    var exit:FlxSpriteButton;
    var lengthCode:FlxText;
    var resetCode:FlxText;
    var wrongCode:FlxText;
    var goodCode:FlxText;
    var image:FlxSprite;

    // secret code
    var curCode:String = '';
    var codeInt = 0;
    var neededCode:Array<String> = ['M', 'A', 'L', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N'];
    var code:String = "";

    override function create()
    {
		FlxG.mouse.visible = true;

		windowPopUp = new FlxSprite(-80).loadGraphic(Paths.image('SymbolWindowPopup'));
        windowPopUp.scale.set(1.1, 1.1);
		windowPopUp.updateHitbox();
		windowPopUp.screenCenter();
        windowPopUp.x -= 25;
		windowPopUp.antialiasing = ClientPrefs.globalAntialiasing;
		add(windowPopUp);

        text = new FlxText(0, 0, FlxG.width, "", 20);
		text.setFormat(Paths.font("tahoma.ttf"), 100, FlxColor.BLACK, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		text.screenCenter();
        text.x -= 70;
        text.y -= 21;
		text.scrollFactor.set();
		text.borderSize = 0.1;
        text.scale.set(0.15, 0.15);
        add(text);

        lengthCode = new FlxText(0, 0, FlxG.width, "", 20);
		lengthCode.setFormat(Paths.font("tahoma.ttf"), 100, FlxColor.RED, FlxTextBorderStyle.OUTLINE,FlxColor.RED);
		lengthCode.screenCenter();
        lengthCode.y += 25;
		lengthCode.scrollFactor.set();
		lengthCode.borderSize = 0.1;
        lengthCode.alpha = 0;
        lengthCode.scale.set(0.15, 0.15);
        lengthCode.text = 'Code Too Long';
        add(lengthCode);

        resetCode = new FlxText(0, 0, FlxG.width, "", 20);
		resetCode.setFormat(Paths.font("tahoma.ttf"), 100, FlxColor.RED, FlxTextBorderStyle.OUTLINE,FlxColor.RED);
		resetCode.screenCenter();
        resetCode.y += 25;
		resetCode.scrollFactor.set();
		resetCode.borderSize = 0.1;
        resetCode.alpha = 0;
        resetCode.scale.set(0.15, 0.15);
        resetCode.text = 'Code Resetted';
        add(resetCode);

        wrongCode = new FlxText(0, 0, FlxG.width, "", 20);
		wrongCode.setFormat(Paths.font("tahoma.ttf"), 100, FlxColor.RED, FlxTextBorderStyle.OUTLINE,FlxColor.RED);
		wrongCode.screenCenter();
        wrongCode.y += 25;
		wrongCode.scrollFactor.set();
		wrongCode.borderSize = 0.1;
        wrongCode.alpha = 0;
        wrongCode.scale.set(0.15, 0.15);
        wrongCode.text = 'Invalid Code';
        add(wrongCode);

        goodCode = new FlxText(0, 0, FlxG.width, "", 20);
		goodCode.setFormat(Paths.font("tahoma.ttf"), 100, FlxColor.GREEN, FlxTextBorderStyle.OUTLINE,FlxColor.GREEN);
		goodCode.screenCenter();
        goodCode.y += 25;
		goodCode.scrollFactor.set();
		goodCode.borderSize = 0.1;
        goodCode.alpha = 0;
        goodCode.scale.set(0.15, 0.15);
        goodCode.text = 'Valid Code';
        add(goodCode);

        var hintCode = new FlxText(0, 0, FlxG.width, "", 20);
		hintCode.setFormat(Paths.font("vcr.ttf"), 100, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		hintCode.screenCenter();
        hintCode.x += 0;
        hintCode.y -= 250;
		hintCode.scrollFactor.set();
		hintCode.borderSize = 0.1;
        hintCode.scale.set(0.3, 0.3);
        hintCode.text = 'Use Your Mouse To Click The Buttons';
        add(hintCode);

        ok = new FlxSpriteButton(875, 452, null, function()
            {
                okClick();
            });
            ok.screenCenter();
            ok.y -= 20;
            ok.x += 155;
            ok.width = 388;
            ok.height = 78;
            ok.updateHitbox();
            ok.alpha = 0;
            add(ok);
    
            cancel = new FlxSpriteButton(875, 452, null, function()
            {
                cancelClick();
            });
            cancel.screenCenter();
            cancel.y += 10;
            cancel.x += 155;
            cancel.width = 388;
            cancel.height = 78;
            cancel.updateHitbox();
            cancel.alpha = 0;
            add(cancel);

            exit = new FlxSpriteButton(875, 452, null, function()
                {
                    exitClick();
                });
                exit.screenCenter();
                exit.y -= 60;
                exit.x += 185;
                exit.width = 388;
                exit.height = 78;
                exit.updateHitbox();
                exit.alpha = 0;
                add(exit);
    
            super.create();
        }
    
        override function update(elapsed:Float)
        {
            text.text = code;

            if (goodCode.alpha == 1)
            {
                wrongCode.alpha = 0;
            }

            if (code.length > 30)
            {
                code = "";
                curCode = '';
                text.text = '';
                codeInt = 0;
                lengthCode.alpha = 1;
                new FlxTimer().start(1.5, function(tmr:FlxTimer) {
                   FlxTween.tween(lengthCode, {alpha: 0}, 1, {
                       ease: FlxEase.linear,
                   });
				});
            }
    
            if (FlxG.keys.justPressed.ANY)
            {
                var curKey = FlxG.keys.getIsDown()[FlxG.keys.getIsDown().length - 1].ID.toString();
                code += FlxG.keys.getIsDown()[FlxG.keys.getIsDown().length - 1].ID.toString();
                FlxG.sound.play(Paths.sound('keyboardPress'));
                trace('text: ' + code);
    
                if (neededCode.contains(curKey) && neededCode[codeInt] == curKey)
                {
                    curCode += curKey;
                    codeInt++;
                }
                else
                {
                    curCode = '';
                    text.text = '';
                    codeInt = 0;
                }
            }
    
            super.update(elapsed);
        }

    function okClick() {
        if (curCode == 'MALFUNCTION')
            {
                FlxG.mouse.visible = false;
                FlxG.sound.play(Paths.sound('mouseClick'));
                FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
                PlayState.SONG = Song.loadFromJson('malfunction', 'malfunction');
                PlayState.isStoryMode = false;
                PlayState.storyDifficulty = 3;
                new FlxTimer().start(0.07, function(tmr:FlxTimer)
                    {
                        LoadingState.loadAndSwitchState(new PlayState(), true);
                    });
                    image.alpha = 0;
                    goodCode.alpha = 1;
                    wrongCode.alpha = 0;
                    new FlxTimer().start(1.5, function(tmr:FlxTimer) {
                        FlxTween.tween(goodCode, {alpha: 0}, 1, {
                            ease: FlxEase.linear,
                        });
                     });
                    new FlxTimer().start(3, function(tmr:FlxTimer) {
                        FlxTween.tween(lengthCode, {alpha: 0}, 1, {
                            ease: FlxEase.linear,
                        });
                        FlxTween.tween(image, {alpha: 0}, 1, {
                            ease: FlxEase.linear,
                        });
                     });
                } else if (curCode != 'MALFUNCTION') {
                    FlxG.sound.play(Paths.sound('mouseClick'));
                    wrongCode.alpha = 1;
                    new FlxTimer().start(1.5, function(tmr:FlxTimer) {
                        FlxTween.tween(wrongCode, {alpha: 0}, 1, {
                            ease: FlxEase.linear,
                        });
                     });
                    code = "";
                    curCode = '';
                    text.text = '';
                    codeInt = 0;
                 }
    }

    function cancelClick() {
       FlxG.sound.play(Paths.sound('mouseClick'));
       code = "";
       curCode = '';
       text.text = '';
       codeInt = 0;
       resetCode.alpha = 1;
       new FlxTimer().start(1.5, function(tmr:FlxTimer) {
          FlxTween.tween(resetCode, {alpha: 0}, 1, {
              ease: FlxEase.linear,
          });
       });
    }

    function exitClick() {
        LoadingState.loadAndSwitchState(new MainMenuState()); 
        FlxG.sound.play(Paths.sound('mouseClick'));
     }
}