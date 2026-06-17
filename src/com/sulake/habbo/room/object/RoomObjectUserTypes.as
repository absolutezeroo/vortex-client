package com.sulake.habbo.room.object
{
    import flash.utils.Dictionary;

    public class RoomObjectUserTypes 
    {

        public static const USER:String = "user";
        public static const PET:String = "pet";
        public static const BOT:String = "bot";
        public static const RENTABLE_BOT:String = "rentable_bot";
        public static const MONSTERPLANT:String = "monsterplant";
        private static const _SafeStr_3522:Dictionary = new Dictionary();

        {
            _SafeStr_3522["user"] = 1;
            _SafeStr_3522["pet"] = 2;
            _SafeStr_3522["bot"] = 3;
            _SafeStr_3522["rentable_bot"] = 4;
        }

        public static function getTypeId(typeName:String):int
        {
            return (_SafeStr_3522[typeName]);
        }

        public static function getName(typeId:int):String
        {
            for (var typeName:String in _SafeStr_3522)
            {
                if (_SafeStr_3522[typeName] == typeId)
                {
                    return (typeName);
                };
            };

            return (null);
        }

        public static function getVisualizationType(typeName:String):String
        {
            switch (typeName)
            {
                case "bot":
                case "rentable_bot":
                    return ("user");
                default:
                    return (typeName);
            };
        }

    }
}
