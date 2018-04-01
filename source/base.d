module base;

public {
    import std.random;

	import jmisc;
	import jec;

    import snake, fruit, status;
}

import std.stdio : writeln;
import std.datetime.stopwatch;

@safe:
enum pass = true,
	 fail = false;

/++
	Global variables
+/
struct Global {
	int windowWidth,
		windowHeight;
    int width, height;
	int fps; /// frames per second
	string fontFileName;
	int fontSize;
	Font font;
    Snake snake;
    Fruit fruit;
    Status status;
    string contestent;
    StopWatch duration;
    int updateFPS;

@trusted:
	/// basic set up
	auto setup(int[] res, immutable string WELCOME) {
		windowWidth = res[0];
		windowHeight = res[1];
        width = res[0] / 10;
        height = res[1] / 10;

        g_window = new RenderWindow(VideoMode(windowWidth, windowHeight),
                    WELCOME);

		fps = 30;

        g_checkPoints = false;
        if (int retVal = jec.setup != 0) {
            import std.stdio: writefln;

            writefln("File: %s, Error function: %s, Line: %s, Return value: %s",
                __FILE__, __FUNCTION__, __LINE__, retVal);
            return -2;
        }
2.gh;
        immutable g_fontSize = 40;
        assert(loadFont("DejaVuSans.ttf") == pass);
3.gh;
        immutable size = g_fontSize, lower = g_fontSize / 2;
        jx = new InputJex(/* position */ Vector2f(0, g_window.getSize.y - size - lower),
                        /* font size */ size,
                        /* header */ "Word: ",
                        /* Type (oneLine, or history) */ InputType.history);
        jx.setColour(Color(255, 200, 0));
        jx.addToHistory(""d);
        jx.edge = false;

        g_mode = Mode.edit;
        g_terminal = true;

        jx.addToHistory(WELCOME);
        jx.showHistory = false;

        status.setup;
        snake.setup;
        fruit.setup;

		return pass;
	}

    auto loadFont(in string fontFileName) {
        g_font = new Font;
        g_font.loadFromFile(fontFileName);
        if (! g_font) {
            import std.stdio: writeln;
            writeln("Font not load");
            return fail;
        }

        return pass;
    }

    void setText(in string newText) {
        import std.conv;

        status.setText(newText);
    }

    void process() {
        snake.process;
    }

    void draw() {
        snake.draw;
        fruit.draw;
    }
}
Global g_global;
