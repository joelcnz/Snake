module snake;

import base, grid;

//version = TestingFruitPopUp;

struct Snake {
    int _id;
    bool _init = true;
    RectangleShape _block;
    JSound _collect,
        _gameOver;
    Point _pos,  _dir;
    Point[] _segs;
    int _score = 0;
    Status _status;
    Keyboard.Key _up, _right, _down, _left;
    Grid _grid;
    int _turns;

    void setup(int id) {
        _id = id;

        switch(_id) {
            case 0:
                _up = Keyboard.Key.W;
                _right = Keyboard.Key.D;
                _down = Keyboard.Key.S;
                _left = Keyboard.Key.A;
            break;
            case 1:
                _up = Keyboard.Key.Up;
                _right = Keyboard.Key.Right;
                _down = Keyboard.Key.Down;
                _left = Keyboard.Key.Left;
            break;
            default:
                writeln("Player keys error!");
            break;
        }

        import std.path;

        _grid.setup;
        _status.setup(_id);
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
        _status.setText(_id == 0 ? "P1 Score: 0" : "P2 Score: 0");

        auto posx = g_global.windowWidth / 10 / (_id == 0 ? 2 : 3);
        //writeln("id: ", _id, "Start pos x: ", posx);
        _pos = Point(posx, g_global.windowHeight / 10 / 2);
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
        /+
        if (! _init) {
            immutable outcome = status(StampOrNot.stamp);
            upDateStatus(outcome);

            if (g_global.numberOfPlayers == 1) {
                import std.file;

                auto name = g_global.contestent;
                append(name ~ ".txt", outcome);
            }
        }
        _init = false;
        +/
        _score = 0;
        _turns = 0;
        g_global.duration.reset;
        g_global.duration.start;
        g_gameState = Game.playing;
    }

    auto status(StampOrNot stamp) {
        import std.file, std.conv;
        import std.string;

        long totalMsecs = g_global.duration.peek.total!"msecs";
        long seconds = totalMsecs / 1_000;
        long leftOverMsecs = (totalMsecs % 1_000) / 10;
        /+
        return format("%sTurns: %s, Score: %s\n", (stamp == StampOrNot.stamp ?
            format("Time: %s:%02d:%0d, ", seconds / 60, seconds % 60,
                                        leftOverMsecs) : ""),
                                         _turns, _score);
                                         +/
        return format("%sTurns: %s, Score: %s\n", (stamp == StampOrNot.stamp ?
            format("%s Time: %s:%02d:%0d, ", dateTimeString, seconds / 60, seconds % 60,
                                        leftOverMsecs) : ""),
                                         _turns, _score);
    }

    void process() {
        _grid.process(_pos);

        if (g_global.fruit.checkColl(_pos)) { // if collide move the fruit too
            _collect.playSnd;
            _segs ~= _pos;

            import std.conv;
            _score += 1;
            _status.setText(status(StampOrNot.noStamp));
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
        foreach(const seg; _segs[0 .. $ - 1]) // $ -1 for not counting the head (is head on it's self is aways true)
            if (_pos == seg) {
                _gameOver.playSnd;

                if (g_global.numberOfPlayers == 2) {
                    doResult;
                } else {
                    immutable outcome = status(StampOrNot.stamp);
                    upDateStatus(status(StampOrNot.noStamp));

                    if (g_global.numberOfPlayers == 1) {
                        import std.file;

                        auto name = g_global.contestent;

                        import std.path;

                        append(name.setExtension(".txt"), outcome);
                    }
                    g_gameState = Game.game_over_result;
                }
            }

        if (g_global.numberOfPlayers == 2)
            // check for collision with other snake
            foreach(const seg; g_global.snakes[_id == 0 ? 1 : 0]._segs)
                if (_pos == seg) {
                    g_gameState = Game.game_over;
                    _gameOver.playSnd;

                    if (g_global.numberOfPlayers == 2) {
                        doResult;
                    } else
                        reset;
                }
    }

    void doResult() {
        g_global.status.setText(g_global.snakes[0]._score > g_global.snakes[1]._score ? "Player One Wins!" : 
            g_global.snakes[1]._score > g_global.snakes[0]._score ? "Player Two Wins!" : "It's a Draw!");
    }

    bool checkForHit(in Point target) {
        // check for collision with self

        import std.algorithm.searching : canFind;

       return _segs.canFind(target);
    }

    void userControl() {
        Point dir = _dir;
        if (g_keys[_up].keyInput || Joystick.getAxisPosition(_id, Joystick.Axis.Y) < -50)
            _dir.X = 0,
            _dir.Y = -1;
        if (g_keys[_right].keyInput || Joystick.getAxisPosition(_id, Joystick.Axis.X) > 50)
            _dir.Y = 0,
            _dir.X = 1;
        if (g_keys[_down].keyInput || Joystick.getAxisPosition(_id, Joystick.Axis.Y) > 50)
            _dir.X = 0,
            _dir.Y = 1;
        if (g_keys[_left].keyInput || Joystick.getAxisPosition(_id, Joystick.Axis.X) < -50)
            _dir.Y = 0,
            _dir.X = -1;

        if (dir != _dir) {
            _turns += 1;
            _status.setText(status(StampOrNot.noStamp));
        }
    }


    void gridDraw() {
        _grid.draw;
    }

    void draw() {
        foreach(seg; _segs) {
            _block.position = Vector2f(seg.X * 10, seg.Y * 10);
            g_window.draw(_block);
        }
        _status.draw;
    }
}