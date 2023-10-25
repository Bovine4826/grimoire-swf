package grimoire.game
{
   import grimoire.Root;
   
   public class Inventory
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function Inventory()
      {
         super();
      }
      
      public static function inventoryItems() : String
      {
         return JSON.stringify(game.world.myAvatar.items);
      }
      
      public static function getItem(param1:String) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in game.world.myAvatar.items)
         {
            if(_loc2_.sName.toLowerCase() == param1.toLowerCase())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getItemByID(param1:int) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in game.world.myAvatar.items)
         {
            if(_loc2_.ItemID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function inventorySlots() : int
      {
         return game.world.myAvatar.objData.iBagSlots;
      }
      
      public static function usedInventorySlots() : int
      {
         return game.world.myAvatar.items.length;
      }
   }
}
