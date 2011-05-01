module LD20
  WindowWidth = 640
  WindowHeight = 480
  
  TileWidth = 32
  TileHeight = 32
  
  FullMapTilesWide = 20
  FullMapTilesHigh = 14
  MapYOffset = 1 * TileHeight
  
  MapTilesWide = FullMapTilesWide - 4
  MapTilesHigh = FullMapTilesHigh - 4
  
  WallColor = 0xFF283732
  
  PlayerStartX = FullMapTilesWide / 2 * TileWidth
  PlayerStartY = FullMapTilesHigh / 2 * TileHeight + MapYOffset
  
  PlayerXEntryWest = TileWidth
  PlayerXEntryEast = WindowWidth - PlayerXEntryWest
  
  PlayerYEntrySouth = WindowHeight - TileWidth
  PlayerYEntryNorth = MapYOffset + TileHeight
end