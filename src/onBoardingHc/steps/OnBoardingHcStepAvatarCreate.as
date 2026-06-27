package onBoardingHc.steps
{
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.enum.AvatarFigurePartType;
    import com.sulake.habbo.avatar.structure.IFigureSetData;
    import com.sulake.habbo.avatar.structure.figure.IFigurePartSet;
    import com.sulake.habbo.avatar.structure.figure.IPalette;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar.structure.figure.ISetType;
    import flash.display.BlendMode;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import onBoardingHc.IOnBoardingHcContext;
    import onBoardingHc.OnBoardingHc;
    import onBoardingHcUi.Button;
    import onBoardingHcUi.ColorButton;
    import onBoardingHcUi.ColouredButton;
    import onBoardingHcUi.InputField;
    import onBoardingHcUi.LoaderUI;
    import onBoardingHcUi.RadioButtonGroup;
    import onBoardingHcUi._Str_650;
    import onBoardingHcUi._Str_662;
    import onBoardingHcUi._Str_862;
    import onBoardingHcUi._Str_951;
    import onBoardingHc.steps.images.AvatarEditor__Str_1109;
    import onBoardingHc.steps.images.AvatarEditor__Str_1231;
    import onBoardingHc.steps.images.AvatarEditor__Str_1394;
    import onBoardingHc.steps.images.AvatarEditor__Str_1624;
    import onBoardingHc.steps.images.AvatarEditor__Str_1918;
    import onBoardingHc.steps.images.AvatarEditor__Str_2092;

    public class OnBoardingHcStepAvatarCreate extends Sprite implements IAvatarImageListener
    {

        private static const GENDER_MALE:String = "M";
        private static const GENDER_FEMALE:String = "F";
        private static const GENDER_UNISEX:String = "U";
        private static const MALE_PRESETS:Array = [
            "hr-891-34.hd-209-10.ch-255-71.lg-280-81",
            "hr-893-42.hd-209-19.ch-230-80.lg-3290-82.sh-906-64",
            "hr-889-34.hd-200-1.ch-3030-73.lg-3023-88.sh-300-64",
            "hr-145-42.hd-185-1.ch-230-66.lg-270-82.sh-290-81",
            "hr-110-38.hd-190-1.ch-3030-85.lg-275-84.sh-290-74",
            "hr-891-42.hd-190-14.ch-230-64.lg-3290-64.sh-906-64",
            "hr-110-35.hd-185-1.ch-3110-80-25.lg-270-84.sh-905-80",
            "hr-145-43.hd-209-1.ch-809-80.lg-275-82.sh-906-64",
            "hr-889-42.hd-207-1370.ch-230-80.lg-280-80.sh-906-64",
            "hr-891-48.hd-200-1370.ch-809-84.lg-3290-84.sh-300-84",
            "hd-190-30.ch-230-82.lg-275-72.sh-905-88",
            "hd-185-10.ch-3110-85-25.lg-275-82.sh-300-84",
            "hr-893-40.hd-200-14.ch-255-75.lg-280-75.sh-906-75",
            "hr-889-45.hd-190-1370.ch-255-68.lg-3023-88.sh-906-68",
            "hr-110-45.hd-200-1371.ch-255-85.lg-280-84.sh-3068-85-25",
            "hr-893-35.hd-185-10.ch-230-1408.lg-275-72",
            "hr-145-42.hd-200-10.ch-255-64.lg-3290-64.sh-906-64",
            "hr-889-42.hd-209-10.ch-809-81.lg-3290-64.sh-300-64",
            "hr-110-39.hd-190-1371.ch-3110-80-25.lg-275-81.sh-3068-83-25",
            "hr-891-48.hd-185-20.ch-3030-71.lg-3023-80.sh-300-81",
            "hr-145-37.hd-200-1.ch-3030-75.lg-270-80.sh-3068-83-25",
            "hr-891-44.hd-207-1.ch-809-76.lg-270-76.sh-3068-76-25",
            "hr-145-48.hd-185-20.ch-3110-76-25.lg-270-74.sh-290-75",
            "hr-110-44.hd-200-30.ch-809-83.lg-270-84.sh-300-64",
            "hr-891-34.hd-207-14.ch-230-81.lg-270-76.sh-290-80"
        ];
        private static const FEMALE_PRESETS:Array = [
            "hr-891-40.hd-627-1371.ch-665-66.lg-700-82.sh-3068-68-25",
            "hr-515-48.hd-628-1.ch-635-73.lg-695-81.sh-735-83",
            "hr-891-35.hd-625-8.ch-685-73.lg-715-73.sh-907-73",
            "hr-837-45.hd-627-14.ch-670-76.lg-695-71.sh-907-73",
            "hr-892-48.hd-605-14.ch-685-64.lg-700-72.sh-906-64",
            "hr-893-32.hd-628-20.ch-823-76.lg-710-82.sh-735-76",
            "hr-892-32.hd-628-1.ch-665-81.lg-700-80.sh-3068-81-25",
            "hr-893-40.hd-610-12.ch-670-81.lg-716-81-25.sh-725-83",
            "hr-891-42.hd-625-10.ch-635-64.lg-695-64.sh-906-64",
            "hd-625-1370.ch-823-72.lg-710-74.sh-725-74",
            "hr-515-45.hd-628-1.ch-823-75.lg-710-73.sh-3068-84-25",
            "hr-893-34.hd-605-19.ch-685-84.lg-695-85.sh-906-85",
            "hr-837-39.hd-610-1.ch-685-91.lg-695-90.sh-906-80",
            "hr-891-34.hd-610-1369.ch-635-74.lg-695-82.sh-906-71",
            "hr-892-39.hd-628-1370.ch-670-64.lg-716-64-25.sh-907-64",
            "hr-837-46.hd-627-20.ch-665-76.lg-716-68-25",
            "hr-892-37.hd-605-10.ch-665-88.lg-700-88",
            "hr-892-48.hd-628-1371.ch-823-82.lg-700-71.sh-725-81",
            "hr-891-36.hd-625-8.ch-670-80.lg-715-80.sh-907-80",
            "hr-891-48.hd-628-12.ch-823-64.lg-715-64.sh-907-76",
            "hr-837-48.hd-627-14.ch-685-73.lg-695-76.sh-907-82",
            "hr-893-48.hd-605-1371.ch-665-74.lg-700-72.sh-725-74",
            "hr-515-35.hd-625-10.ch-665-72.lg-695-72.sh-906-64",
            "hr-837-35.hd-628-1.ch-635-81.lg-710-75.sh-735-81",
            "hr-893-44.hd-628-30.ch-670-76.lg-715-76.sh-907-76"
        ];
        private static const PART_BUTTON_LIMIT:int = 5;
        private static const COLOR_BUTTON_LIMIT:int = 16;
        private static const PART_BUTTON_SIZE:int = 50;
        private static const PART_BUTTON_GAP:int = 10;
        private static const PART_ROW_GAP:int = 13;
        private static const COLOR_BUTTON_SIZE:int = 50;
        private static const COLOR_BUTTON_GAP:int = 2;
        private static const LOOKS_X:int = 40;
        private static const COLORS_X:int = 375;
        private static const PREVIEW_X:int = 760;
        private static const PART_TYPES:Array = [
            AvatarFigurePartType.HAIR,
            AvatarFigurePartType.HEAD,
            AvatarFigurePartType.CHEST,
            "lg",
            AvatarFigurePartType.SHOES
        ];

        private var _context:IOnBoardingHcContext;
        private var _titleField:TextField;
        private var _looksTitle:TextField;
        private var _colorTitle:TextField;
        private var _previewTitle:TextField;
        private var _nameField:InputField;
        private var _statusField:TextField;
        private var _createButton:ColouredButton;
        private var _cancelButton:ColouredButton;
        private var _randomizeButton:_Str_650;
        private var _maleButton:_Str_862;
        private var _femaleButton:_Str_862;
        private var _genderButtonGroup:RadioButtonGroup;
        private var _cloudAnimation:RandomAvatarCloudsAnimation;
        private var _partGrid:Sprite;
        private var _colorGrid:Sprite;
        private var _previewContainer:Sprite;
        private var _avatarBitmap:Bitmap;
        private var _figureData:IFigureSetData;
        private var _selectedSets:Dictionary;
        private var _selectedColors:Dictionary;
        private var _activePartType:String = AvatarFigurePartType.HAIR;
        private var _selectedGender:String = GENDER_MALE;
        private var _initialized:Boolean;
        private var _nameValid:Boolean;
        private var _disposed:Boolean;

        public function OnBoardingHcStepAvatarCreate(context:IOnBoardingHcContext)
        {
            _context = context;
        }

        public function dispose():void
        {
            _disposed = true;

            if (_createButton)
                _createButton.dispose();

            if (_cancelButton)
                _cancelButton.dispose();

            while (numChildren > 0)
            {
                removeChildAt(0);
            };

            _context = null;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function init():void
        {
            if (_initialized)
                return;

            _initialized = true;
            _selectedSets = new Dictionary();
            _selectedColors = new Dictionary();
            _figureData = ((_context.avatarRenderManager) ? _context.avatarRenderManager.getFigureData() : null);

            addHeaders();
            addEditorPanels();
            addNameField();
            addButtons();

            if (_figureData == null)
            {
                _statusField.htmlText = "${generic.error}";
                _createButton.active = false;
                return;
            };

            resetFigure();
            renderPartGrid();
            renderColorGrid();
            updateFigurePreview();
            updateCreateButtonState();
        }

        public function reloadFigureData():void
        {
            if (((!_initialized) || (_disposed) || (!_context)))
                return;

            _figureData = ((_context.avatarRenderManager) ? _context.avatarRenderManager.getFigureData() : null);

            if (_figureData == null)
                return;

            resetFigure();
            renderPartGrid();
            renderColorGrid();
            updateFigurePreview();
            updateCreateButtonState();
        }

        private function addHeaders():void
        {
            _titleField = LoaderUI.createTextField("Choose looks", 24, 0xFFFFFF, false, true, false, false, "left");
            _titleField.x = 35;
            _titleField.y = 5;
            _titleField.width = 300;
            _titleField.thickness = 50;
            addChild(_titleField);

            _looksTitle = LoaderUI.createTextField("${login.create_avatar.choose_looks.description}", 12, 0xCDEAF4, true, true);
            _looksTitle.x = 40;
            _looksTitle.y = 338;
            _looksTitle.width = 275;
            addChild(_looksTitle);

            _colorTitle = LoaderUI.createTextField("Choose colour", 24, 0xFFFFFF, false, true, false, false, "left");
            _colorTitle.x = 370;
            _colorTitle.y = 5;
            _colorTitle.width = 300;
            _colorTitle.thickness = 50;
            addChild(_colorTitle);

            _previewTitle = LoaderUI.createTextField("This is your Habbo", 24, 0xFFFFFF, false, true, false, false, "left");
            _previewTitle.x = 700;
            _previewTitle.y = 5;
            _previewTitle.width = 300;
            _previewTitle.thickness = 50;
            addChild(_previewTitle);
        }

        private function addEditorPanels():void
        {
            _partGrid = new Sprite();
            _partGrid.x = LOOKS_X;
            _partGrid.y = 50;
            addChild(_partGrid);

            _colorGrid = new Sprite();
            _colorGrid.x = COLORS_X;
            _colorGrid.y = 50;
            addChild(_colorGrid);

            _previewContainer = new Sprite();
            _previewContainer.x = PREVIEW_X;
            _previewContainer.y = 90;
            addChild(_previewContainer);

            var halo:Bitmap = new AvatarEditor__Str_1918();
            halo.x = -55;
            halo.y = 0;
            halo.blendMode = BlendMode.ADD;
            _previewContainer.addChild(halo);

            var platform:Bitmap = new AvatarEditor__Str_1394();
            platform.x = 35;
            platform.y = 200;
            platform.blendMode = BlendMode.OVERLAY;
            _previewContainer.addChild(platform);

            _avatarBitmap = new Bitmap();
            _avatarBitmap.scaleX = 2;
            _avatarBitmap.scaleY = 2;
            _previewContainer.addChild(_avatarBitmap);

            _cloudAnimation = new RandomAvatarCloudsAnimation();
            _cloudAnimation.visible = false;
            _previewContainer.addChild(_cloudAnimation);
        }

        private function addNameField():void
        {
            _nameField = new InputField(_context, 420, "${login.create_avatar.choose_name.name}", "", "${login.create_avatar.choose_name.title}", "${login.create_avatar.choose_name.description}");
            _nameField.x = 40;
            _nameField.y = 378;
            _nameField.addEventListener(Event.CHANGE, onNameChange);
            addChild(_nameField);

            _statusField = LoaderUI.createTextField("", 14, 0xFFCC00, false, true);
            _statusField.x = 40;
            _statusField.y = 454;
            _statusField.width = 610;
            addChild(_statusField);
        }

        private function addButtons():void
        {
            _genderButtonGroup = new RadioButtonGroup(onGenderSelected);
            _maleButton = new _Str_862("M", _genderButtonGroup, LoaderUI._Str_1585, Bitmap(new AvatarEditor__Str_2092()).bitmapData, Bitmap(new AvatarEditor__Str_1624()).bitmapData, 8231575);
            _femaleButton = new _Str_862("F", _genderButtonGroup, LoaderUI._Str_1585, Bitmap(new AvatarEditor__Str_1231()).bitmapData, Bitmap(new AvatarEditor__Str_1109()).bitmapData, 8231575);
            _randomizeButton = new _Str_650(0, 0, onRandomize, 0xD8D8D8);
            _cancelButton = new ColouredButton(ColouredButton.BUTTON_RED, "${generic.cancel}", new Rectangle(605, 435, 0, 40), true, onCancel, 0xD8D8D8);
            _createButton = new ColouredButton(ColouredButton.BUTTON_GREEN, "${generic.submit}", new Rectangle(725, 435, 0, 40), true, onCreate, 0xD8D8D8);

            _maleButton.name = GENDER_MALE;
            _femaleButton.name = GENDER_FEMALE;
            _maleButton.x = 700;
            _maleButton.y = 325;
            _femaleButton.x = 790;
            _femaleButton.y = 325;
            _randomizeButton.x = 875;
            _randomizeButton.y = 315;
            _createButton.active = false;

            addChild(_maleButton);
            addChild(_femaleButton);
            addChild(_randomizeButton);
            addChild(_cancelButton);
            addChild(_createButton);
            _maleButton.selected = true;

            var hint:TextField = LoaderUI.createTextField("Can't decide? Don't worry, you can change your clothes later!", 12, 0xCDEAF4, true, true);
            hint.x = 700;
            hint.y = 378;
            hint.width = 300;
            addChild(hint);
        }

        private function resetFigure():void
        {
            var partType:String;

            _selectedSets = new Dictionary();
            _selectedColors = new Dictionary();
            _activePartType = AvatarFigurePartType.HAIR;

            if (applyRandomPreset(false))
                return;

            for each (partType in PART_TYPES)
            {
                var sets:Array = getSelectableSets(partType);

                if (sets.length > 0)
                {
                    _selectedSets[partType] = sets[0];
                    _selectedColors[partType] = getDefaultColorIds(partType);
                };
            };
        }

        private function applyRandomPreset(playAnimation:Boolean):Boolean
        {
            var presets:Array = ((_selectedGender == GENDER_FEMALE) ? FEMALE_PRESETS : MALE_PRESETS);
            var index:int = int(Math.random() * presets.length);
            var tries:int;

            while (tries < presets.length)
            {
                if (applyFigureString(presets[index]))
                {
                    if (((playAnimation) && (_cloudAnimation)))
                    {
                        _cloudAnimation.visible = true;
                        _cloudAnimation._Str_1480();
                    };

                    return (true);
                };

                index = ((index + 1) % presets.length);
                tries++;
            };

            return (false);
        }

        private function applyFigureString(figure:String):Boolean
        {
            var part:String;
            var partPieces:Array;
            var partType:String;
            var setId:int;
            var setType:ISetType;
            var partSet:IFigurePartSet;
            var newSets:Dictionary = new Dictionary();
            var newColors:Dictionary = new Dictionary();
            var parts:Array = figure.split(".");

            for each (part in parts)
            {
                partPieces = part.split("-");

                if (partPieces.length < 3)
                    continue;

                partType = partPieces[0];

                if (PART_TYPES.indexOf(partType) == -1)
                    continue;

                setId = parseInt(partPieces[1]);
                setType = ((_figureData) ? _figureData.getSetType(partType) : null);

                if (setType == null)
                    return (false);

                partSet = setType.getPartSet(setId);

                if (((partSet == null) || (!(partSet.gender == _selectedGender)) && (!(partSet.gender == GENDER_UNISEX))))
                    return (false);

                newSets[partType] = partSet;
                newColors[partType] = partPieces.slice(2);
            };

            for each (partType in PART_TYPES)
            {
                if (newSets[partType] == null)
                    return (false);
            };

            _selectedSets = newSets;
            _selectedColors = newColors;
            _activePartType = AvatarFigurePartType.HAIR;
            return (true);
        }

        private function renderPartGrid():void
        {
            clearSprite(_partGrid);

            var row:int;

            for each (var partType:String in PART_TYPES)
            {
                var sets:Array = getSelectableSets(partType);
                var column:int;

                while ((column < sets.length) && (column < PART_BUTTON_LIMIT))
                {
                    _partGrid.addChild(createPartButton(partType, sets[column], (column * (PART_BUTTON_SIZE + PART_BUTTON_GAP)), (row * (PART_BUTTON_SIZE + PART_ROW_GAP))));
                    column++;
                };

                row++;
            };
        }

        private function renderColorGrid():void
        {
            clearSprite(_colorGrid);

            var colors:Array = getSelectableColors(_activePartType);
            var index:int;

            while ((index < colors.length) && (index < COLOR_BUTTON_LIMIT))
            {
                var color:IPartColor = colors[index];
                _colorGrid.addChild(createColorButton(_activePartType, color, ((index % 4) * (COLOR_BUTTON_SIZE + COLOR_BUTTON_GAP)), (int(index / 4) * (COLOR_BUTTON_SIZE + PART_ROW_GAP))));
                index++;
            };
        }

        private function createPartButton(partType:String, partSet:IFigurePartSet, xPos:int, yPos:int):_Str_662
        {
            var button:_Str_662 = new _Str_662(xPos, yPos, onPartClick);
            button.name = (partType + "_" + partSet.id);

            var bitmapData:BitmapData = getPartPreview(partType, partSet);

            if (bitmapData != null)
            {
                button._Str_2233(bitmapData);
            };

            if (selectedPartSet(partType) == partSet.id)
            {
                button.select();
            };

            if (partType == _activePartType)
            {
                button._Str_1854();
            };

            return (button);
        }

        private function createColorButton(partType:String, color:IPartColor, xPos:int, yPos:int):ColorButton
        {
            var button:ColorButton = new ColorButton(xPos, yPos, onColorClick, 0xFFFFFF, color.rgb);
            button.name = (partType + "_" + color.id);
            button.index = color.index;
            button.club = (color.clubLevel > 0);

            if (selectedColor(partType) == color.id)
            {
                button.select();
            };

            return (button);
        }

        private function getPartPreview(partType:String, partSet:IFigurePartSet):BitmapData
        {
            var figure:String = getFigureString(partType, partSet.id);
            var image:IAvatarImage = _context.avatarRenderManager.createAvatarImage(figure, "h", _selectedGender, this);

            if (image == null)
                return (null);

            if (image.isPlaceholder())
                return (null);

            image.setDirection("full", 4);
            return (image.getImage(((partType == AvatarFigurePartType.HAIR) || (partType == AvatarFigurePartType.HEAD)) ? "head" : "full", true, 0.5));
        }

        private function updateFigurePreview():void
        {
            var image:IAvatarImage = _context.avatarRenderManager.createAvatarImage(currentFigure, "h", _selectedGender, this);

            if (image == null)
                return;

            if (image.isPlaceholder())
                return;

            image.setDirection("full", 4);

            var bitmapData:BitmapData = image.getImage("full", true);

            if (bitmapData == null)
                return;

            _avatarBitmap.bitmapData = bitmapData;
            _avatarBitmap.x = int((190 - _avatarBitmap.width) / 2);
            _avatarBitmap.y = int(190 - _avatarBitmap.height);
        }

        private function getFigureString(replacePartType:String = null, replaceSetId:int = 0):String
        {
            var parts:Array = [];

            for each (var partType:String in PART_TYPES)
            {
                var partSet:IFigurePartSet = _selectedSets[partType];

                if (partSet == null)
                    continue;

                var setId:int = ((partType == replacePartType) ? replaceSetId : partSet.id);
                var colors:Array = (_selectedColors[partType] || getDefaultColorIds(partType));

                if (colors.length == 0)
                    colors = getDefaultColorIds(partType);

                parts.push(([partType, setId].concat(colors)).join("-"));
            };

            return (parts.join("."));
        }

        private function get currentFigure():String
        {
            return (getFigureString());
        }

        private function getSelectableSets(partType:String):Array
        {
            var result:Array = [];
            var setType:ISetType = ((_figureData) ? _figureData.getSetType(partType) : null);

            if (setType == null)
                return (result);

            for each (var partSet:IFigurePartSet in setType.partSets.getValues())
            {
                if (((partSet.isSelectable) && (partSet.isPreSelectable) && (partSet.clubLevel == 0) && ((partSet.gender == _selectedGender) || (partSet.gender == GENDER_UNISEX))))
                {
                    result.push(partSet);
                };
            };

            result.sort(partSetSort);
            return (result);
        }

        private function partSetSort(left:IFigurePartSet, right:IFigurePartSet):Number
        {
            if (left.id < right.id)
                return (-1);

            if (left.id > right.id)
                return (1);

            return (0);
        }

        private function getSelectableColors(partType:String):Array
        {
            var result:Array = [];
            var setType:ISetType = ((_figureData) ? _figureData.getSetType(partType) : null);

            if (setType == null)
                return (result);

            var palette:IPalette = _figureData.getPalette(setType.paletteID);

            if (palette == null)
                return (result);

            for each (var color:IPartColor in palette.colors)
            {
                if (((color.isSelectable) && (color.clubLevel == 0)))
                {
                    result.push(color);
                };
            };

            result.sort(colorSort);
            return (result);
        }

        private function getDefaultColorIds(partType:String):Array
        {
            var colors:Array = getSelectableColors(partType);
            var preferredColorId:int = getPreferredColorId(partType);

            for each (var color:IPartColor in colors)
            {
                if (color.id == preferredColorId)
                {
                    return ([color.id]);
                };
            };

            return ((colors.length > 0) ? [IPartColor(colors[0]).id] : []);
        }

        private function getPreferredColorId(partType:String):int
        {
            switch (partType)
            {
                case AvatarFigurePartType.HEAD:
                    return (1);
                case AvatarFigurePartType.HAIR:
                    return (64);
                case AvatarFigurePartType.CHEST:
                    return (72);
                case "lg":
                case AvatarFigurePartType.SHOES:
                    return (64);
                default:
                    return (61);
            };
        }

        private function colorSort(left:IPartColor, right:IPartColor):Number
        {
            if (left.index < right.index)
                return (-1);

            if (left.index > right.index)
                return (1);

            return (0);
        }

        private function selectedPartSet(partType:String):int
        {
            var partSet:IFigurePartSet = _selectedSets[partType];
            return ((partSet) ? partSet.id : 0);
        }

        private function selectedColor(partType:String):int
        {
            var colors:Array = _selectedColors[partType];
            return (((colors) && (colors.length > 0)) ? int(colors[0]) : 0);
        }

        private function onPartClick(button:_Str_951):void
        {
            var parts:Array = String(button.name).split("_");
            var partType:String = parts[0];
            var setId:int = parseInt(parts[1]);
            var setType:ISetType = _figureData.getSetType(partType);

            if (setType == null)
                return;

            var partSet:IFigurePartSet = setType.getPartSet(setId);

            if (partSet == null)
                return;

            _activePartType = partType;
            _selectedSets[partType] = partSet;

            if (_selectedColors[partType] == null)
                _selectedColors[partType] = getDefaultColorIds(partType);

            renderPartGrid();
            renderColorGrid();
            updateFigurePreview();
        }

        private function onColorClick(button:_Str_951):void
        {
            var parts:Array = String(button.name).split("_");
            var partType:String = parts[0];
            var colorId:int = parseInt(parts[1]);
            var currentColors:Array = _selectedColors[partType];

            _activePartType = partType;
            _selectedColors[partType] = ((currentColors && currentColors.length > 1) ? [colorId, currentColors[1]] : [colorId]);

            renderPartGrid();
            renderColorGrid();
            updateFigurePreview();
        }

        private function onGenderSelected():void
        {
            var selectedButton:_Str_862 = ((_genderButtonGroup) ? _genderButtonGroup.selected : null);

            if (selectedButton)
            {
                changeGender(selectedButton.name);
            };
        }

        private function changeGender(gender:String):void
        {
            if (_selectedGender == gender)
                return;

            _selectedGender = gender;
            resetFigure();
            renderPartGrid();
            renderColorGrid();
            updateFigurePreview();
        }

        private function onRandomize(button:_Str_951):void
        {
            if (!applyRandomPreset(true))
                resetFigure();

            renderPartGrid();
            renderColorGrid();
            updateFigurePreview();
        }

        private function onNameChange(changeEvent:Event):void
        {
            _nameValid = false;
            updateCreateButtonState();

            var avatarName:String = _nameField.text;

            if ((avatarName) && (avatarName.length >= 3))
            {
                _statusField.htmlText = "${generic.loading}";
                _context.checkName(avatarName);
            }
            else
            {
                _statusField.htmlText = "${login.create_avatar.choose_name.name_too_short}";
            };
        }

        public function onNameCheckResult(response:Object, isValid:Boolean):void
        {
            if (!isValid)
            {
                _nameValid = false;
                _statusField.htmlText = "${login.create_avatar.choose_name.invalid_name}";
                updateCreateButtonState();
                return;
            };

            _nameValid = ((response) && (response.valid == true));
            _statusField.htmlText = ((_nameValid) ? "${generic.ok}" : "${login.create_avatar.choose_name.name_already_in_use}");
            updateCreateButtonState();
        }

        private function updateCreateButtonState():void
        {
            if (_createButton)
            {
                _createButton.active = ((_nameValid) && (_figureData != null));
            };
        }

        private function onCreate(createButton:Button):void
        {
            if (!_nameValid)
                return;

            var avatarName:String = _nameField.text;

            if ((!avatarName) || (avatarName.length < 3))
                return;

            _context.createAvatar(avatarName, currentFigure, _selectedGender);
        }

        private function onCancel(cancelButton:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_AVATAR_SELECT);
        }

        public function avatarImageReady(figure:String):void
        {
            if (!disposed)
            {
                renderPartGrid();
                updateFigurePreview();
            };
        }

        private function clearSprite(container:Sprite):void
        {
            while (container.numChildren > 0)
            {
                container.removeChildAt(0);
            };
        }

    }
}
