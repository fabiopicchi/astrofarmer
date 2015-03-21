TMX file rules:

    - File must be Base64 encoded
    - Every tile layer must have a property named "tileset" indicating the tileset used on that layer
    - Tile layers may have the collidable property that should be written as an array of integers, indicating the number of the collidable tiles(counting from 1) on the tileset. Ex: collidable: [1, 2].
    - In every object, the values of x, y, width and height specified will be atributed to the object's hitbox and not its bounding box.
