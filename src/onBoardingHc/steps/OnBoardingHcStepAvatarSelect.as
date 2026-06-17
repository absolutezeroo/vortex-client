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

        public function OnBoardingHcStepAvatarSelect(context:IOnBoardingHcContext)
        {
            _context = context;
            init();
            addEventListener("addedToStage", onAddedToStage);
        }

        public function set baseUrl(baseUrl:String):void
        {
            _baseUrl = baseUrl;
        }

        public function dispose():void
        {
            _playButton.dispose();
            _cancelButton.dispose();
            _createButton.dispose();
        }

        private function onAddedToStage(stageEvent:Event):void
        {
            var alignTimer:Timer = new Timer(20, 1);
            alignTimer.addEventListener("timerComplete", onAlignElements);
            alignTimer.start();
        }

        private function onAlignElements(_:TimerEvent):void
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

            var panelBackground:Bitmap = LoaderUI.createBalloon(640, 100, 0, false, 995918, "none");
            _infoPanel.addChild(panelBackground);
            _infoPanel.y = 180;

            _avatarDescription = LoaderUI.createTextField("", 18, 8309486, false);
            _avatarName = LoaderUI.createTextField("", 20, 0xFFFFFF, false, true, false, false);
            _avatarName.width = 260;
            _avatarName.x = 50;
            _avatarDescription.x = 50;
            _avatarDescription.width = 260;
            _infoPanel.addChild(_avatarDescription);
            _infoPanel.addChild(_avatarName);
            LoaderUI.lineUpVertically(panelBackground, (15 - panelBackground.height), _avatarName, 20, _avatarDescription);

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

        public function populateAvatars(avatars:Vector.<AvatarData>):void
        {
            var avatarLoader:Loader;
            var avatarRequest:URLRequest;
            var avatarContainer:Sprite;
            var placeholder:Bitmap;
            var itemPositionX:int;

            _avatarContainers = new Vector.<DisplayObjectContainer>(0);
            _avatars = avatars;

            var avatarIndex:int;

            for each (var avatar:AvatarData in avatars)
            {
                if (avatarIndex > 6)
                    break;

                avatarLoader = new Loader();
                avatarLoader.name = String(avatarIndex);
                avatarRequest = new URLRequest(getAvatarUrl(avatar));
                avatarLoader.load(avatarRequest);
                avatarLoader.contentLoaderInfo.addEventListener("complete", onAvatarImageLoaded);
                avatarLoader.contentLoaderInfo.addEventListener("error", onImageError);
                avatarLoader.contentLoaderInfo.addEventListener("ioError", onImageError);
                avatarLoader.contentLoaderInfo.addEventListener("securityError", onImageError);

                avatarContainer = new Sprite();
                _avatarContainers.push(avatarContainer);
                placeholder = new placeholder_avatar();
                avatarContainer.addChild(placeholder);
                avatarContainer.addChild(avatarLoader);
                addChild(avatarContainer);
                avatarContainer.name = String(avatarIndex);
                avatarContainer.addEventListener("click", onAvatarClick);
                itemPositionX = (((avatarIndex + 1) * _avatarSpacing) + (avatarIndex * 100));
                avatarContainer.x = itemPositionX;
                avatarContainer.y = 50;
                avatarIndex++;
            };

            if (avatars.length > 0)
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

        private function onImageError(imageErrorEvent:ErrorEvent):void
        {
            Logger.log(("[OnBoardingHcStepAvatarSelect] Image error: " + imageErrorEvent.text));
        }

        private function onAvatarClick(clickEvent:MouseEvent):void
        {
            _selectedIndex = clickEvent.currentTarget.name;
            updateDescription();
            highlightAvatar(_avatarContainers[_selectedIndex]);
            _playButton.active = true;
        }

        private function onAvatarImageLoaded(imageEvent:Event):void
        {
            (imageEvent.currentTarget as LoaderInfo).loader.parent.removeChildAt(0);
            _avatarGlow.visible = true;
            _haloOverlay.visible = true;
            highlightAvatar(_avatarContainers[_selectedIndex]);
        }

        private function updateDescription():void
        {
            if ((_avatars == null) || (_avatars.length == 0))
                return;

            var selectedAvatar:AvatarData = _avatars[_selectedIndex];
            _avatarName.text = selectedAvatar.name;
            _avatarDescription.text = selectedAvatar.motto;
        }

        private function highlightAvatar(avatarDisplayObject:DisplayObject):void
        {
            var avatarCenterX:int = int((avatarDisplayObject.x + (avatarDisplayObject.width / 2)));
            var avatarCenterY:int = int((avatarDisplayObject.y + (avatarDisplayObject.height / 2)));
            _avatarGlow.x = (avatarCenterX - (_avatarGlow.width / 2));
            _avatarGlow.y = ((avatarCenterY - (_avatarGlow.height / 2)) + 15);
            _haloOverlay.x = (avatarCenterX - (_haloOverlay.width / 2));
            _haloOverlay.y = ((avatarCenterY + _haloOverlay.height) - 40);
        }

        private function getAvatarUrl(avatar:AvatarData):String
        {
            var avatarImageUrl:String = ((_baseUrl + "/habbo-imaging/avatarimage?user=") + avatar.name);

            if ((_baseUrl.indexOf("local") > -1) || (_baseUrl.indexOf("127.0.0.1") > -1))
            {
                avatarImageUrl = (("https://www.habbo.com/habbo-imaging/avatarimage?size=m&figure=" + avatar.figure) + "&direction=2");
            };

            return (avatarImageUrl);
        }

        private function onCancel(cancelButton:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_LOGIN);
        }

        private function onChooseAvatar(chooseAvatarButton:Button):void
        {
            _context.loginWithAvatar(_avatars[_selectedIndex]);
        }

        private function onCreateAvatar(createAvatarButton:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_AVATAR_CREATE);
        }

    }
}
