module grid;

import jec;

struct Grid {
    RectangleShape _vir;
    RectangleShape _hor;

    void setup() {
        _vir = new RectangleShape();
        with(_vir) {
            size = Vector2f(10, 100);
            fillColor = Color(0,0,0);
            outlineColor = Color(128,128,128, 128);
            outlineThickness = 0;
        }
        _hor = new RectangleShape();
        with(_hor) {
            size = Vector2f(100, 10);
            fillColor = Color(0,0,0);
            outlineColor = Color(128,128,128, 128);
            outlineThickness = 0;
        }
    }

    void process(Point p) {
        _hor.position = Vector2f(0, p.Y * 10);
        _vir.position = Vector2f(p.X * 10, 0);
    }

    void draw() {
        g_window.draw(_hor);
        g_window.draw(_vir);
    }
}