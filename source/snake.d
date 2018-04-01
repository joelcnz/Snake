module snake;

import base;

//version = TestingFruitPopUp;

struct Snake {
    bool _init = true;
    RectangleShape _block;
    JSound _collect,
        _gameOver;
    Point _pos,  _dir;
    Point[] _segs;
    int _score = 0;

    void setup() {
        import std.path;

        _collect = new JSound(buildPath("sfx", "hit.wav"));
        _gameOver = new JSound(buildPath("sfx", "gameOver.wav"));
        _block = new RectangleShape;
        with(_block) {
            size = Vector2f(10, 10);
            fillColor = Color(255,255,255, 255);
            outlineColor = fillColor;
            outlineThickness = 0;
        }

        reset;
    }

    void reset() {
        g_global.status.setText("Score: 0");
        _pos = Point(g_global.windowWidth / 10 / 2, g_global.windowHeight / 10 / 2);
        _dir = Point(0, -1);
        _segs.length = 3; //300
        _segs[] = _pos;

        version(TestingFruitPopUp) {
            _segs.length = 0;
            foreach(y; 0 .. g_global.height - 1)
                foreach(x; 0 .. g_global.width - 1)
                    _segs ~= Point(x, y);
            _pos = Point(g_global.width - 1, 0);
        }

        g_global.fruit.setup;
        if (! _init) {
            import std.file, std.conv;
            import std.string;

            auto name = g_global.contestent;
            auto result = text("Score: ", _score);
            long totalMsecs = g_global.duration.peek.total!"msecs";
            long seconds = totalMsecs / 1_000;
            long leftOverMsecs = (totalMsecs % 1_000) / 10;
            append(name ~ ".txt", format("%s - Time: %s:%02d.%0d, Score: %s\n",
                                    name, seconds / 60, seconds % 60, leftOverMsecs, _score));
            upDateStatus(result);
        }
        _init = false;
        _score = 0;
        g_global.duration.reset;
        g_global.duration.start;
    }

    void process() {
        if (g_global.fruit.checkColl(_pos)) { // if collide move the fruit too
            _collect.playSnd;
            _segs ~= _pos;

            import std.conv;
            _score += 1;
            g_global.status.setText(text("Score: ", _score));
        }

        for(int i = 0; i < _segs.length - 1; i += 1) {
            _segs[i] = _segs[i + 1];
        }

        _pos += _dir;
        if (_pos.X < 0) _pos.X = g_global.width - 1;
        if (_pos.X > g_global.width - 1) _pos.X = 0;
        if (_pos.Y < 0) _pos.Y = g_global.height - 1;
        if (_pos.Y > g_global.height - 1) _pos.Y = 0;
        _segs[$ - 1] = _pos;

        // check for collision with self
        foreach(seg; _segs[0 .. $ - 1]) // $ -1 for not counting the head (is head on it's self is aways true)
            if (_pos == seg) {
                _gameOver.playSnd;
                reset;
            }
    }

    bool checkForHit(in Point target) {
        // check for collision with self
        foreach(seg; _segs)
            if (seg == target)
                return true;
        return false;
    }

    void userControl() {
        if (g_keys[Keyboard.Key.Up].keyInput)
            _dir.X = 0,
            _dir.Y = -1;
        if (g_keys[Keyboard.Key.Right].keyInput)
            _dir.Y = 0,
            _dir.X = 1;
        if (g_keys[Keyboard.Key.Down].keyInput)
            _dir.X = 0,
            _dir.Y = 1;
        if (g_keys[Keyboard.Key.Left].keyInput)
            _dir.Y = 0,
            _dir.X = -1;
    }

    void draw() {
        foreach(seg; _segs) {
            _block.position = Vector2f(seg.X * 10, seg.Y * 10);
            g_window.draw(_block);
        }
    }
}