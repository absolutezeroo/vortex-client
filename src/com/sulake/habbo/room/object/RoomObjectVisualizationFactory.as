package com.sulake.habbo.room.object
{
    import com.sulake.core.runtime.Component;
    import com.sulake.room.object.IRoomObjectVisualizationFactory;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDAvatarRenderManager;
    import __AS3__.vec.Vector;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualization;
    import com.sulake.habbo.room.object.visualization.room.TileCursorVisualization;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.habbo.room.object.visualization.pet.AnimatedPetVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.AnimatedFurnitureVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.ResettingAnimatedFurnitureVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurniturePosterVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureHabboWheelVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureValRandomizerVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureBottleVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurniturePlanetSystemVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureQueueTileVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurniturePartyBeamerVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureCuboidVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureGiftWrappedVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureCounterClockVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureWaterAreaVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureScoreBoardVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureFireworksVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureGiftWrappedFireworksVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureRoomBillboardVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureRoomBackgroundVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureStickieVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureMannequinVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureGuildCustomizedVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureGuildIsometricBadgeVisualization;
    import com.sulake.habbo.room.object.visualization.game.SnowballVisualization;
    import com.sulake.habbo.room.object.visualization.game.SnowSplashVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVoteCounterVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVoteMajorityVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureSoundBlockVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureBadgeDisplayVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureYoutubeDisplayVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureExternalImageVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureBuilderPlaceholderVisualization;
    import com.sulake.room.object.visualization.IRoomObjectGraphicVisualization;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualizationData;
    import com.sulake.habbo.room.object.visualization.pet.AnimatedPetVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.AvatarFurnitureVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.AnimatedFurnitureVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.SnowballVisualizationData;
    import com.sulake.room.object.visualization.utils.GraphicAssetCollection;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;

    public class RoomObjectVisualizationFactory extends Component implements IRoomObjectVisualizationFactory 
    {

        private var _habboAvatar:IAvatarRenderManager = null;
        private var _visualizationDatas:Map;
        private var _enableCaching:Boolean = true;

        public function RoomObjectVisualizationFactory(context:IContext, id:uint=0, library:IAssetLibrary=null)
        {
            super(context, id, library);
            _enableCaching = (id == 0);
            _visualizationDatas = new Map();
        }

        override protected function get dependencies():Vector.<ComponentDependency>
        {
            return (super.dependencies.concat(new <ComponentDependency>[new ComponentDependency(new IIDAvatarRenderManager(), function (avatarRenderManager:IAvatarRenderManager):void
            {
                _habboAvatar = avatarRenderManager;
            }, false)]));
        }

        override public function dispose():void
        {
            var visualizationData:IRoomObjectVisualizationData;
            var index:int;

            if (disposed)
            {
                return;
            };

            if (_visualizationDatas != null)
            {
                visualizationData = null;
                index = 0;

                while (index < _visualizationDatas.length)
                {
                    visualizationData = (_visualizationDatas.getWithIndex(index) as IRoomObjectVisualizationData);

                    if (visualizationData != null)
                    {
                        visualizationData.dispose();
                    };

                    index++;
                };

                _visualizationDatas.dispose();
                _visualizationDatas = null;
            };

            super.dispose();
        }

        public function createRoomObjectVisualization(visualizationType:String):IRoomObjectGraphicVisualization
        {
            var visualizationClass:Class;
            switch (visualizationType)
            {
                case "room":
                    visualizationClass = RoomVisualization;
                    break;
                case "tile_cursor":
                    visualizationClass = TileCursorVisualization;
                    break;
                case "user":
                    visualizationClass = AvatarVisualization;
                    break;
                case "bot":
                case "rentable_bot":
                    visualizationClass = AvatarVisualization;
                    break;
                case "pet_animated":
                    visualizationClass = AnimatedPetVisualization;
                    break;
                case "furniture_static":
                    visualizationClass = FurnitureVisualization;
                    break;
                case "furniture_animated":
                    visualizationClass = AnimatedFurnitureVisualization;
                    break;
                case "furniture_resetting_animated":
                    visualizationClass = ResettingAnimatedFurnitureVisualization;
                    break;
                case "furniture_poster":
                    visualizationClass = FurniturePosterVisualization;
                    break;
                case "furniture_habbowheel":
                    visualizationClass = FurnitureHabboWheelVisualization;
                    break;
                case "furniture_val_randomizer":
                    visualizationClass = FurnitureValRandomizerVisualization;
                    break;
                case "furniture_bottle":
                    visualizationClass = FurnitureBottleVisualization;
                    break;
                case "furniture_planet_system":
                    visualizationClass = FurniturePlanetSystemVisualization;
                    break;
                case "furniture_queue_tile":
                    visualizationClass = FurnitureQueueTileVisualization;
                    break;
                case "furniture_party_beamer":
                    visualizationClass = FurniturePartyBeamerVisualization;
                    break;
                case "furniture_cuboid":
                    visualizationClass = FurnitureCuboidVisualization;
                    break;
                case "furniture_gift_wrapped":
                    visualizationClass = FurnitureGiftWrappedVisualization;
                    break;
                case "furniture_counter_clock":
                    visualizationClass = FurnitureCounterClockVisualization;
                    break;
                case "furniture_water_area":
                    visualizationClass = FurnitureWaterAreaVisualization;
                    break;
                case "furniture_score_board":
                    visualizationClass = FurnitureScoreBoardVisualization;
                    break;
                case "furniture_fireworks":
                    visualizationClass = FurnitureFireworksVisualization;
                    break;
                case "furniture_gift_wrapped_fireworks":
                    visualizationClass = FurnitureGiftWrappedFireworksVisualization;
                    break;
                case "furniture_bb":
                    visualizationClass = FurnitureRoomBillboardVisualization;
                    break;
                case "furniture_bg":
                    visualizationClass = FurnitureRoomBackgroundVisualization;
                    break;
                case "furniture_stickie":
                    visualizationClass = FurnitureStickieVisualization;
                    break;
                case "furniture_mannequin":
                    visualizationClass = FurnitureMannequinVisualization;
                    break;
                case "furniture_guild_customized":
                    visualizationClass = FurnitureGuildCustomizedVisualization;
                    break;
                case "furniture_guild_isometric_badge":
                    visualizationClass = FurnitureGuildIsometricBadgeVisualization;
                    break;
                case "game_snowball":
                    visualizationClass = SnowballVisualization;
                    break;
                case "game_snowsplash":
                    visualizationClass = SnowSplashVisualization;
                    break;
                case "furniture_vote_counter":
                    visualizationClass = FurnitureVoteCounterVisualization;
                    break;
                case "furniture_vote_majority":
                    visualizationClass = FurnitureVoteMajorityVisualization;
                    break;
                case "furniture_soundblock":
                    visualizationClass = FurnitureSoundBlockVisualization;
                    break;
                case "furniture_badge_display":
                    visualizationClass = FurnitureBadgeDisplayVisualization;
                    break;
                case "furniture_youtube":
                    visualizationClass = FurnitureYoutubeDisplayVisualization;
                    break;
                case "furniture_external_image":
                    visualizationClass = FurnitureExternalImageVisualization;
                    break;
                case "furniture_builder_placeholder":
                    visualizationClass = FurnitureBuilderPlaceholderVisualization;
            };

            if (visualizationClass == null)
            {
                return (null);
            };

            var visualizationInstance:Object = new visualizationClass();

            if ((visualizationInstance is IRoomObjectGraphicVisualization))
            {
                return (visualizationInstance as IRoomObjectGraphicVisualization);
            };

            return (null);
        }

        public function getRoomObjectVisualizationData(cacheKey:String, visualizationType:String, xml:XML):IRoomObjectVisualizationData
        {
            var visualizationData:IRoomObjectVisualizationData;
            var avatarVisualizationData:AvatarVisualizationData;
            var petVisualizationData:AnimatedPetVisualizationData;
            var furnitureVisualizationData:AvatarFurnitureVisualizationData;
            var cachedVisualizationData:IRoomObjectVisualizationData;
            cachedVisualizationData = (_visualizationDatas.getValue(cacheKey) as IRoomObjectVisualizationData);

            if (cachedVisualizationData != null)
            {
                return (cachedVisualizationData);
            };

            var visualizationDataClass:Class;
            switch (visualizationType)
            {
                case "furniture_static":
                case "furniture_gift_wrapped":
                case "furniture_bb":
                case "furniture_bg":
                case "furniture_stickie":
                case "furniture_builder_placeholder":
                    visualizationDataClass = FurnitureVisualizationData;
                    break;
                case "furniture_animated":
                case "furniture_resetting_animated":
                case "furniture_poster":
                case "furniture_habbowheel":
                case "furniture_val_randomizer":
                case "furniture_bottle":
                case "furniture_planet_system":
                case "furniture_queue_tile":
                case "furniture_party_beamer":
                case "furniture_counter_clock":
                case "furniture_water_area":
                case "furniture_score_board":
                case "furniture_fireworks":
                case "furniture_gift_wrapped_fireworks":
                case "furniture_guild_customized":
                case "furniture_guild_isometric_badge":
                case "furniture_vote_counter":
                case "furniture_vote_majority":
                case "furniture_soundblock":
                case "furniture_badge_display":
                case "furniture_external_image":
                case "furniture_youtube":
                case "tile_cursor":
                    visualizationDataClass = AnimatedFurnitureVisualizationData;
                    break;
                case "furniture_mannequin":
                    visualizationDataClass = AvatarFurnitureVisualizationData;
                    break;
                case "room":
                    visualizationDataClass = RoomVisualizationData;
                    break;
                case "user":
                case "bot":
                case "rentable_bot":
                    visualizationDataClass = AvatarVisualizationData;
                    break;
                case "pet_animated":
                    visualizationDataClass = AnimatedPetVisualizationData;
                    break;
                case "game_snowball":
                case "game_snowsplash":
                    visualizationDataClass = SnowballVisualizationData;
            };

            if (visualizationDataClass == null)
            {
                return (null);
            };

            cachedVisualizationData = new visualizationDataClass();

            if (cachedVisualizationData != null)
            {
                visualizationData = null;
                visualizationData = (cachedVisualizationData as IRoomObjectVisualizationData);

                if (!visualizationData.initialize(xml))
                {
                    visualizationData.dispose();
                    return (null);
                };

                if ((visualizationData is AvatarVisualizationData))
                {
                    avatarVisualizationData = (cachedVisualizationData as AvatarVisualizationData);
                    avatarVisualizationData.avatarRenderer = _habboAvatar;
                }

                else
                {
                    if ((visualizationData is AnimatedPetVisualizationData))
                    {
                        petVisualizationData = (cachedVisualizationData as AnimatedPetVisualizationData);
                        petVisualizationData.commonAssets = assets;
                    }

                    else
                    {
                        if ((visualizationData is AvatarFurnitureVisualizationData))
                        {
                            furnitureVisualizationData = (cachedVisualizationData as AvatarFurnitureVisualizationData);
                            furnitureVisualizationData.avatarRenderer = _habboAvatar;
                        }

                        else
                        {
                            if ((visualizationData is SnowballVisualizationData))
                            {
                                SnowballVisualizationData(visualizationData).assets = assets;
                            };
                        };
                    };
                };

                if (_enableCaching)
                {
                    _visualizationDatas.add(cacheKey, visualizationData);
                };

                return (visualizationData);
            };

            return (null);
        }

        public function createGraphicAssetCollection():IGraphicAssetCollection
        {
            return (new GraphicAssetCollection());
        }

    }
}
