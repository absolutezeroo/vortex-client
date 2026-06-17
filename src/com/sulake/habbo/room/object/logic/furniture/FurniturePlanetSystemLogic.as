package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.object.IRoomObjectModelController;

    public class FurniturePlanetSystemLogic extends FurnitureLogic 
    {

        override public function initialize(data:XML):void
        {
            var modelController:IRoomObjectModelController;
            super.initialize(data);

            if (data == null)
            {
                return;
            };

            var planetSystemNodes:XMLList = data.planetsystem;

            if (planetSystemNodes.length() == 0)
            {
                return;
            };

            if (object != null)
            {
                modelController = object.getModelController();

                if (modelController != null)
                {
                    modelController.setString("furniture_planetsystem_data", planetSystemNodes);
                };
            };
        }

    }
}