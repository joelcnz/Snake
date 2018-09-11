module fruit;

import base;

struct Fruit {
    RectangleShape _block;
    Point _pos;

    bool checkColl(Point b) {
        if  (_pos == b) {
            reset;
            return true;
        } else
            return false;
    }

   void setup() {
        _block = new RectangleShape;
        with(_block) {
            size = Vector2f(10, 10);
            fillColor = Color(255,0,0, 255);
            outlineColor = fillColor;
            outlineThickness = 0;
        }

        reset;
    }

    void reset() {
        do {
            _pos = Point(uniform(0, g_global.windowWidth / 10), uniform(0, g_global.windowHeight / 10));
        } while(g_global.snakes[0].checkForHit(_pos) || g_global.snakes[1].checkForHit(_pos));
        _block.position = Vector2f(_pos.X * 10, _pos.Y * 10);
    }

    void draw() {
        g_window.draw(_block);
    }
}