/++
Snake
+/
module main;

import base, snake, fruit, grid;

// program start
int main(string[] args)
{	
	import std.stdio;

	writeln("22.6.2018 fixed the (account).txt.txt (double txt problem)");

	g_global.numberOfPlayers = 1;

	if (1 == args.length && 1 == g_global.numberOfPlayers) {
		import std.stdio;

		writeln("Need a name, e.g. ./snake Joel Doe");
		
		//return -1;
		args ~= "Testing";
	}
	import std.string, std.path;
	auto Contestent = args[1 .. $].join(" ").setExtension("txt");

	writeln("Contestent: ", Contestent);
	g_checkPoints = false;
	0.gh; // check point

	import std.datetime.stopwatch;
	StopWatch timer;
	timer.start;
	
	with(g_global) {
		enum WELCOME = "Welcome to Snake! Press [LSystem] + [Q] to quit";

		setup([320, 240], WELCOME);
		upDateStatus(WELCOME);
		g_window.setFramerateLimit(fps);

		import std.algorithm;

		contestent = Contestent[0 .. Contestent.countUntil(".txt")];
		writeln("contestent ", contestent);
		updateFPS = 10;
	}

	"global is set up".gh;

	g_global.duration.stop;
	g_gameState = Game.paused;

	// main loop
    while (g_window.isOpen())
    {
        Event event; // to handle clicking the close button on the frame

        while(g_window.pollEvent(event)) // a loop for checking for events
        {
            if(event.type == event.EventType.Closed) // on the window frame
            {
                g_window.close();
            }
        }

		// for command + Q to quit/close program
		if (Keyboard.isKeyPressed(Keyboard.Key.LSystem)
			&&
			Keyboard.isKeyPressed(Keyboard.Key.Q) || g_keys[Keyboard.Key.Escape].keyInput) {
			upDateStatus("Quit");
			g_window.close;
		}

		if (g_keys[Keyboard.Key.Return].keyTrigger &&  Game.game_over_result == g_gameState) {
			with(g_global) {
				reset;
			}
		}

		if (g_keys[Keyboard.Key.Space].keyTrigger && (Game.playing == g_gameState || Game.paused == g_gameState)) {
			if (Game.playing == g_gameState) {
				g_gameState = Game.paused;
				g_global.duration.stop;
			} else {
				g_global.duration.start;
				g_gameState = Game.playing;
			}
		}

		final switch(g_gameState) {
			case Game.playing:
				with(g_global) {
					if (timer.peek.total!"msecs" > updateFPS * 10) {
						timer.reset;
						timer.start;
						process;
					}
					foreach(ref snake; snakes[0 .. g_global.numberOfPlayers])
						snake.userControl;
				}
				//grid.process;
			break;
			case Game.game_over:
			case Game.paused:
			case Game.game_over_result:
			break;
		}

		g_window.clear(Color(0,0,0)); // clear the screen
		
		//gridDraw;
		with(g_global) {
			draw;
		}

        g_window.display(); // show all graphics changes
    }
	
	return 0; // return success
}
