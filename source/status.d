module status;

import base;

struct Status {
    Text _text;

    void setup() {
        _text = new Text("Score: 0", g_font, 20);
        assert(_text);
        _text.position = Vector2f(0, 0);
        _text.setColor = Color(0,180,255);
    }
    
    void setText(in string text) {
        import std.conv;

        _text.setString = text.to!dstring;
    }

    void draw() {
        g_window.draw(_text);
    }
}