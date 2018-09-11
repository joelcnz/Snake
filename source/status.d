module status;

import base;

struct Status {
    Text _text;
    Game _gameStatus;

    void setup(in int id) {
        _text = new Text("Go!", g_font, 20);
        assert(_text);
        _text.position = Vector2f(id == -1 || id == 0 ? 0 : g_global.windowWidth - 150, id == -1 ? 20 : 0);
        _text.setColor = Color(0,180,255);
    }
    
/+
    void setStatus(Game gameStatus) {
        _gameStatus = gameStatus;
    }
+/
    void setText(in string text) {
        import std.conv;

        _text.setString = text.to!dstring;
    }

    void draw() {
        g_window.draw(_text);
    }
}