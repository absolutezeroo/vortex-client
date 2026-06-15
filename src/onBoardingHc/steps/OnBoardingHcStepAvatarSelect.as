package onBoardingHc.steps
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import onBoardingHcUi.ColouredButton;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.communication.login.AvatarData;
    import flash.display.DisplayObjectContainer;
    import flash.display.Bitmap;
    import flash.utils.Timer;
    import flash.events.Event;
    import onBoardingHcUi.LoaderUI;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.ErrorEvent;
    import flash.events.MouseEvent;
    import flash.display.LoaderInfo;
    import flash.display.DisplayObject;
    import onBoardingHcUi.Button;
    import onBoardingHc.OnBoardingHc;
    import onBoardingHc.IOnBoardingHcContext;

    public class OnBoardingHcStepAvatarSelect extends Sprite
    {

        private static const avatar_halo_png:Class = HabboAvatarView_avatar_halo_png;
        private static const avatar_glow_png:Class = HabboAvatarView_avatar_glow_png;
        private static const placeholder_avatar:Class = HabboAvatarView_Habboplaceholder_avatar_png;

        private var _context:IOnBoardingHcContext;
        private var _titleField:TextField;
        private var _playButton:ColouredButton;
        private var _cancelButton:ColouredButton;
        private var _createButton:ColouredButton;
        private var _initialized:Boolean;
        private var _avatars:Vector.<AvatarData>;
        private var _avatarSpacing:int = 10;
        private var _baseUrl:String;
        private var _infoPanel:Sprite;
        private var _avatarDescription:TextField;
        private var _avatarName:TextField;
        private var _selectedIndex:int;
        private var _avatarContainers:Vector.<DisplayObjectContainer>;
        private var _haloOverlay:Bitmap;
        private var _avatarGlow:Bitmap;

        public function OnBoardingHcStepAvatarSelect(_arg_1:IOnBoardingHcContext)
        {
            _context = _arg_1;
            init();
            addEventListener("addedToStage", onAddedToStage);
        }

        public function set baseUrl(_arg_1:String):void
        {
            _baseUrl = _arg_1;
        }

        public function dispose():void
        {
            _playButton.dispose();
            _cancelButton.dispose();
            _createButton.dispose();
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            var _local_2:Timer = new Timer(20, 1);
            _local_2.addEventListener("timerComplete", onAlignElements);
            _local_2.start();
        }

        private function onAlignElements(_arg_1:TimerEvent):void
        {
            LoaderUI.lineUpVerticallyRevers(_playButton, 20, _infoPanel);
            LoaderUI.alignAnchors(_infoPanel, 0, "r", _playButton);
            LoaderUI.lineUpHorizontallyRevers(_playButton, 20, _cancelButton);
            LoaderUI.lineUpHorizontallyRevers(_cancelButton, 20, _createButton);
        }

        public function init():void
        {
            _selectedIndex = 0;

            if (_initialized)
                return;

            _initialized = true;
            _infoPanel = new Sprite();
            addChild(_infoPanel);

            var _local_1:Bitmap = LoaderUI.createBalloon(640, 100, 0, false, 995918, "none");
            _infoPanel.addChild(_local_1);
            _infoPanel.y = 180;

            _avatarDescription = LoaderUI.createTextField("", 18, 8309486, false);
            _avatarName = LoaderUI.createTextField("", 20, 0xFFFFFF, false, true, false, false);
            _avatarName.width = 260;
            _avatarName.x = 50;
            _avatarDescription.x = 50;
            _avatarDescription.width = 260;
            _infoPanel.addChild(_avatarDescription);
            _infoPanel.addChild(_avatarName);
            LoaderUI.lineUpVertically(_local_1, (15 - _local_1.height), _avatarName, 20, _avatarDescription);

            _avatarGlow = new avatar_glow_png();
            _avatarGlow.blendMode = "add";
            _avatarGlow.visible = false;

            _haloOverlay = new avatar_halo_png();
            _haloOverlay.blendMode = "overlay";
            _haloOverlay.visible = false;

            addTitleField();
            addChild(_haloOverlay);
            addChild(_avatarGlow);
            addButtons();
        }

        private function addTitleField():void
        {
            if (!_titleField)
            {
                _titleField = LoaderUI.createTextField("${connection.login.account.choose}", 40, 0xFFFFFF, false, true, false, false, "left");
                _titleField.x = 0;
                _titleField.y = 0;
                _titleField.width = 500;
                _titleField.multiline = false;
                _titleField.thickness = 50;
                addChild(_titleField);
            };
        }

        public function addButtons():void
        {
            _cancelButton = new ColouredButton("red", "${generic.cancel}", new Rectangle(0, 300, 0, 40), true, onCancel, 0xD8D8D8);
            addChild(_cancelButton);

            _playButton = new ColouredButton("gfreen", "${connection.login.play}", new Rectangle(0, 300, 0, 40), true, onChooseAvatar, 0xD8D8D8);
            _playButton.active = false;
            addChild(_playButton);

            _createButton = new ColouredButton("gfreen", "${connection.login.create_avatar}", new Rectangle(0, 300, 0, 40), true, onCreateAvatar, 0xD8D8D8);
            addChild(_createButton);
        }

        public function populateAvatars(_arg_1:Vector.<AvatarData>):void
        {
            var _local_4:Loader;
            var _local_5:URLRequest;
            var _local_3:Sprite;
            var _local_8:Bitmap;
            var _local_2:int;

            _avatarContainers = new Vector.<DisplayObjectContainer>(0);
            _avatars = _arg_1;

            var _local_6:int;

            for each (var _local_7:AvatarData in _arg_1)
            {
                if (_local_6 > 6)
                    break;

                _local_4 = new Loader();
                _local_4.name = String(_local_6);
                _local_5 = new URLRequest(getAvatarUrl(_local_7));
                _local_4.load(_local_5);
                _local_4.contentLoaderInfo.addEventListener("complete", onAvatarImageLoaded);
                _local_4.contentLoaderInfo.addEventListener("error", onImageError);
                _local_4.contentLoaderInfo.addEventListener("ioError", onImageError);
                _local_4.contentLoaderInfo.addEventListener("securityError", onImageError);

                _local_3 = new Sprite();
                _avatarContainers.push(_local_3);
                _local_8 = new placeholder_avatar();
                _local_3.addChild(_local_8);
                _local_3.addChild(_local_4);
                addChild(_local_3);
                _local_3.name = String(_local_6);
                _local_3.addEventListener("click", onAvatarClick);
                _local_2 = (((_local_6 + 1) * _avatarSpacing) + (_local_6 * 100));
                _local_3.x = _local_2;
                _local_3.y = 50;
                _local_6++;
            };

            if (_arg_1.length > 0)
            {
                updateDescription();
                _selectedIndex = 0;
                _playButton.active = true;
                _avatarGlow.visible = true;
                _haloOverlay.visible = true;
                highlightAvatar(_avatarContainers[_selectedIndex]);
            }
            else
            {
                _playButton.active = false;
            };
        }

        private function onImageError(_arg_1:ErrorEvent):void
        {
            Logger.log(("[OnBoardingHcStepAvatarSelect] Image error: " + _arg_1.text));
        }

        private function onAvatarClick(_arg_1:MouseEvent):void
        {
            _selectedIndex = _arg_1.currentTarget.name;
            updateDescription();
            highlightAvatar(_avatarContainers[_selectedIndex]);
            _playButton.active = true;
        }

        private function onAvatarImageLoaded(_arg_1:Event):void
        {
            (_arg_1.currentTarget as LoaderInfo).loader.parent.removeChildAt(0);
            _avatarGlow.visible = true;
            _haloOverlay.visible = true;
            highlightAvatar(_avatarContainers[_selectedIndex]);
        }

        private function updateDescription():void
        {
            if ((_avatars == null) || (_avatars.length == 0))
                return;

            var _local_1:AvatarData = _avatars[_selectedIndex];
            _avatarName.text = _local_1.name;
            _avatarDescription.text = _local_1.motto;
        }

        private function highlightAvatar(_arg_1:DisplayObject):void
        {
            var _local_2:int = int((_arg_1.x + (_arg_1.width / 2)));
            var _local_3:int = int((_arg_1.y + (_arg_1.height / 2)));
            _avatarGlow.x = (_local_2 - (_avatarGlow.width / 2));
            _avatarGlow.y = ((_local_3 - (_avatarGlow.height / 2)) + 15);
            _haloOverlay.x = (_local_2 - (_haloOverlay.width / 2));
            _haloOverlay.y = ((_local_3 + _haloOverlay.height) - 40);
        }

        private function getAvatarUrl(_arg_1:AvatarData):String
        {
            var _local_2:String = ((_baseUrl + "/habbo-imaging/avatarimage?user=") + _arg_1.name);

            if ((_baseUrl.indexOf("local") > -1) || (_baseUrl.indexOf("127.0.0.1") > -1))
            {
                _local_2 = (("https://www.habbo.com/habbo-imaging/avatarimage?size=m&figure=" + _arg_1.figure) + "&direction=2");
            };

            return (_local_2);
        }

        private function onCancel(_arg_1:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_LOGIN);
        }

        private function onChooseAvatar(_arg_1:Button):void
        {
            _context.loginWithAvatar(_avatars[_selectedIndex]);
        }

        private function onCreateAvatar(_arg_1:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_AVATAR_CREATE);
        }

    }
}
