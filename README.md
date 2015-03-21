TMX file rules:

    - File must be Base64 encoded.
    - It is assumed that the file uses only one tileset so layers don't need to specify which tileset they're using.
    - Tile layers may have the collidable property set. If set then all the tiles on this layer will be collidable.
    - In every object, the values of x, y, width and height specified will be atributed to the object's hitbox and not its bounding box.
